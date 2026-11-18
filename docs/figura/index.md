---
icon: material/account-box-outline
---

# Figura avatars

If you play with a [Figura](https://modrinth.com/mod/figura) avatar, MineFunkin works with it. Your avatar dances
along in fights, and its own script can react to the song: eyes that follow the opponent, ears that bounce on the beat,
your own animation for every arrow.

!!! info "Which Figura"
    On Minecraft 1.21.11 Figura runs as the port **NoFigura**. Both are supported - MineFunkin talks to whichever one
    is installed. Without Figura nothing of this is loaded.

## Without a script

You don't have to do anything. In a fight MineFunkin moves your player's head, body, arms and legs (the idle, the
four arrow poses, held notes, the death). Every part of your avatar that hangs on one of those (Figura's `Head`, `Body`,
`LeftArm` ... groups) moves with it - squash and stretch included.

## The `minefunkin` global

Every avatar script gets a global called `minefunkin`. It tells the script what **its** player is doing in a fight, as
this game sees it. It only reads - a script can't change the fight. Outside a fight every call answers `false`, `0` or
`nil`, so a script can run everywhere.

| Call | Answers |
|---|---|
| `minefunkin:getVersion()` | this interface's version: `"2.0"` |
| `minefunkin:isFighting()` | `true` while the player is in a fight |
| `minefunkin:getPose()` | the pose MineFunkin shows right now: `"idle"`, `"left"`, `"down"`, `"up"`, `"right"` or `"death"` |
| `minefunkin:getPoseTime()` | milliseconds since that pose started (`nil` in the idle) |
| `minefunkin:isPoseHeld()` | `true` while a long note is held |
| `minefunkin:getLastLane()` | the arrow of the newest note: `"left"`, `"down"`, `"up"` or `"right"` |
| `minefunkin:getLastJudgment()` | how that note went: `"sick"`, `"good"`, `"bad"`, `"shit"` or `"miss"` |
| `minefunkin:getLastNoteAge()` | milliseconds since that note |
| `minefunkin:isHolding(lane)` | `true` while that arrow (`"left"` ...) is held down |
| `minefunkin:getBeat()` | the song's beat as a number (`4.5` = halfway through the fifth beat) |
| `minefunkin:getBpm()` | the song's speed in beats per minute |
| `minefunkin:getSongTime()` | the song's time in milliseconds |
| `minefunkin:getCombo()` | notes hit in a row |
| `minefunkin:getMisses()` | misses so far |
| `minefunkin:getAccuracy()` | accuracy in percent |
| `minefunkin:isDead()` | `true` once the player is out (or a song plays the death pose) |
| `minefunkin:getOpponentPos()` | where the opponent's eyes are, as a world position - where this game draws them |
| `minefunkin:getOpponentName()` | the opponent's name |

The pose is exactly what you see: the notes, held notes and the poses a song's own script sets.

## Examples

Your avatar's parts have their own names - `models.model.Head.Eyes` below stands for yours.

??? example "Your own animation for every arrow"

    Make animations called `left`, `down`, `up`, `right` and `death` in Blockbench. This plays the right one on every
    note, from the start again when the same arrow comes twice.

    ```luau
    local playing, lastTime = nil, nil

    function events.tick()
      local pose = minefunkin:getPose()
      local time = minefunkin:getPoseTime()
      local again = pose == playing and time and lastTime and time < lastTime
      if pose ~= playing or again then
        if playing and animations.model[playing] then animations.model[playing]:stop() end
        if pose and pose ~= "idle" and animations.model[pose] then animations.model[pose]:play() end
        playing = pose
      end
      lastTime = time
    end
    ```

??? example "Look at the opponent"

    Turns a part toward the opponent, from where the head really is - also when a pose tips the head down or back.

    ```luau
    -- yaw (+ = to its right) and pitch (+ = up) in degrees, seen from the part's front
    local function towardOpponent(part)
      local target = minefunkin:getOpponentPos()
      if not target then return 0, 0 end
      local m = part:partToWorldMatrix()
      local d = m:copy():invert():applyDir(target - m:apply(0, 0, 0))
      return math.deg(math.atan2(d.x, -d.z)), math.deg(math.atan2(d.y, math.sqrt(d.x * d.x + d.z * d.z)))
    end

    function events.render(delta)
      local yaw, pitch = towardOpponent(models.model.Head)
      models.model.Head.Eyes:setPos(math.clamp(yaw / 40, -1, 1), math.clamp(pitch / 30, -1, 1), 0)
    end
    ```

??? example "Squint on a miss"

    ```luau
    function events.tick()
      local age = minefunkin:getLastNoteAge()
      local missed = minefunkin:getLastJudgment() == "miss" and age and age < 400
      models.model.Head.Eyes:setScale(1, missed and 0.4 or 1, 1)
    end
    ```

??? example "Ears that bounce on the beat"

    ```luau
    function events.render(delta)
      local beat = minefunkin:getBeat()
      local bounce = beat and math.abs(math.sin(beat * math.pi)) * 12 or 0
      models.model.Head.Ears:setRot(bounce, 0, 0)
    end
    ```

## Good to know

- Every game runs the avatar scripts it shows. So `minefunkin` answers what **that** game sees: your opponent's game
  sees your fight from its side, players watching from outside see it from theirs.
- Blinking or other random moves in your script can land in the middle of a pose. If that looks odd, skip them while
  `getPose()` isn't `"idle"`.
- A song can switch Figura avatars off for itself (`player.figura = false`, see
  [Fighters](../api/fighters.md#figura)). Then the fighter shows its plain Minecraft skin in that song - on that player's
  screen.
