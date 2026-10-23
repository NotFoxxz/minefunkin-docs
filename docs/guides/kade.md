---
icon: material/swap-horizontal-bold
---

# Coming from Kade Engine

Kade Engine modcharts are a `modchart.lua` per song with hooks (`start`, `update`, `beatHit`, ...), receptors and
characters addressed by number, and global variables like `camHudAngle`. Good news: MineFunkin's
[modcharts](modcharts.md) work the same way - a song script with callbacks - so most of a Kade modchart translates
line by line.

This page maps the names (Kade Engine 1.4-1.8's modchart API), and at the end translates all of Kade's own example
modcharts, so you can see a few whole ones side by side.

## The big differences

Five things to keep in mind - they'll save you some head-scratching:

- **No compiling.** A Kade modchart needs a game built from source. Here the script is just a `.event` file in the
  song's folder, and the chart editor's **Reload** picks up your changes while you work. No waiting for a build.
- **Your four lanes, not eight receptors.** Kade numbers the receptors 0-7 (0-3 the opponent's, 4-7 yours).
  MineFunkin's `strum[0]` ... `strum[3]` are **your** lanes - Kade's 4-7. In a fight only yours are on screen;
  in practice the opponent's receptors beside them fade with `strums.opponentAlpha`.
- **Offsets, not positions.** `setActorX(x, 4)` puts receptor 4 at screen position `x`. `strum[0].x = 30` moves
  lane 0 **30 pixels away from its home**. So Kade's `defaultStrum4X + 30` is just `30` here, and 0 is home.
- **Milliseconds.** `onFrame(dt)` gets milliseconds (Kade's `elapsed` is seconds), `time` is the song time in
  ms. Durations are written `beats(2)`, `seconds(1)`.
- **The characters are Minecraft players.** `boyfriend` is `player`, `dad` is `opponent` - the real fighters in
  the world, in a fight. There's no girlfriend; a picture on the [stage](stages.md) can play her part.

## Hooks

| Kade | MineFunkin |
|---|---|
| `start(song)` | [onStart()](../api/callbacks.md#onstart) |
| `update(elapsed)` | [onFrame(dt)](../api/callbacks.md#onframe) - `dt` in ms |
| `beatHit(beat)` | [onBeat(b)](../api/callbacks.md#onbeat) |
| `stepHit(step)` | [onStep(n)](../api/callbacks.md#onstep) |
| `keyPressed(key)` | [onKeyPress(lane)](../api/callbacks.md#onkeypress) - the lane 0-3, not `"left"` / `"down"` / ... |
| `playerOneSing(note, position)` | [onHit(note)](../api/callbacks.md#onhit) |
| `playerTwoSing(note, position)` | [onOpponentHit(note)](../api/callbacks.md#onopponenthit) |
| `playerOneMiss(note, position)` | [onMiss(note)](../api/callbacks.md#onmiss) |
| `playerOneTurn()` / `playerTwoTurn()` | read `song.singer` (`"player"` / `"opponent"`) in `onBeat` |

## Receptors

| Kade | MineFunkin |
|---|---|
| `setActorX(x, i)` / `getActorX(i)` | `strum[lane].x` (an offset from home) |
| `setActorY(y, i)` / `getActorY(i)` | `strum[lane].y` |
| `setActorAngle(a, i)` / `getActorAngle(i)` | `strum[lane].angle` |
| `setActorAlpha(a, i)` | `strum[lane].alpha` (or [hideLane / showLane](../api/shortcuts.md#hidelane)) |
| `setActorScale(s, i)` | `strum[lane].scale` |
| `defaultStrum4X` ... `defaultStrum7Y` | 0 - the home of every offset; `strums.spacing` is the distance between two lanes |
| `receptor.defaultX` / `defaultY` (1.8's objects) | `strum[lane].homeX` / `homeY` - where the receptor rests on the screen, in pixels |
| `tweenPos(i, x, y, time)` | `tween(strum[lane].x, x, seconds(time))` + the same for `.y` |
| `tweenAngle(i, angle, time)` | `tween(strum[lane].angle, angle, seconds(time))` |
| `tweenFadeIn(i, alpha, time)` / `tweenFadeOut` | `tween(strum[lane].alpha, alpha, seconds(time))` |
| `tweenPosXAngle` / `tweenPosYAngle` | two tweens: `.x` (or `.y`) and `.angle` |
| `setActorVelocityX`, `setActorAccelerationX`, `setActorDragX` | no physics - work the position out in `onFrame` from `time`, or [tween](../api/actions.md#tween) it |
| `setStrumlineY(y)` / `strumLineY` | `strums.y` |
| `strumLine1Visible = false` | `strums.opponentAlpha = 0` (practice) |
| `strumLine2Visible = false` | `strums.alpha = 0` (or [hideStrums](../api/shortcuts.md#hidestrums)) |

## Notes

| Kade | MineFunkin |
|---|---|
| `getRenderedNotes()` | `notes.count` - see [notes one by one](../api/notes.md) |
| `getRenderedNoteX(i)`, `getRenderedNoteY(i)` | `note[i].distance` (ms until the hit) - positions are worked out from that |
| `getRenderedNoteType(i)` | `note[i].lane` |
| `getRenderedNoteStrumtime(i)` | `note[i].time` |
| `isSustain(i)`, `note.isSustain` | `note[i].hold > 0` |
| `note.beat` (1.8's objects) | `note[i].beat` |
| `setRenderedNotePos(x, y, i)` | `note[i].x`, `note[i].y` - offsets, set every frame |
| `setRenderedNoteAlpha(a, i)` | `note[i].alpha` |
| `setRenderedNoteScale(s, i)` | `note[i].scale` |
| `setRenderedNoteAngle(a, i)` | `note[i].angle` |
| `createWiggle(freq, amplitude, speed)` + `setNoteWiggle` / `setSustainWiggle` | the [`ripple`](../api/modifiers.md#mod-ripple) modifier: `set(0, 30, "ripple")`, `ripple.freq`, `ripple.speed` - only the lanes wave, like Kade's |

## Camera, HUD and window

| Kade | MineFunkin |
|---|---|
| `camNotes` / `camSustains` (1.8: `.angle`, `.x`, `.y`, `tweenZoom`, `.alpha`) | the lanes' own [modifiers](modifiers.md): `turnZ`, `x`, `y`, `zoom`, `fade` - e.g. `ease(beat, 2, "cubicOut", 120, "zoom")` |
| `camHudAngle` / `setHudAngle(a)` | `hud.angle` |
| `setHudPosition(x, y)` / `getHudX()` | `hud.x`, `hud.y` |
| `hudZoom` / `setHudZoom(z)` | `camera.zoom` (zooms the playfield, and in a fight the world with it) |
| `cameraZoom` / `setCamZoom(z)` | the fight camera's lens: `camera.fov` - see [the fight camera](camera.md) |
| `cameraAngle` | `camera.roll` |
| `setCamPosition(x, y)`, `followXOffset`, `followYOffset` | `camera.x`, `camera.y` |
| `showOnlyStrums = true` | [hideHud()](../api/shortcuts.md#hidehud) + [hideJudgments()](../api/shortcuts.md#hidejudgments) |
| `setWindowPos(x, y)` / `getWindowX()` | `window.x`, `window.y` - offsets from where it was ([game window](windows.md)) |
| `resizeWindow(w, h)` / `getWindowWidth()` | `window.width`, `window.height` (factors) |
| `getScreenWidth()` / `getScreenHeight()` | `monitor.width`, `monitor.height` |

## Characters and sprites

| Kade | MineFunkin |
|---|---|
| `playActorAnimation("boyfriend", "singUP", true, false)` | `pose("player", "up")` ([pose](../api/shortcuts.md#pose)) |
| `changeBoyfriendCharacter(id)` / `changeDadCharacter(id)` | `setSkin("player", "skins/bf.png")` ([setSkin](../api/shortcuts.md#setskin)) |
| `setActorX(x, "dad")` | `opponent.x` (blocks, in the fight's frame - see [the fighters](fighters.md)) |
| `makeSprite(image, id, drawBehind)` | `image[n].file = "image.png"`, `image[n].layer = "stage"` (behind) or `"back"` (in front) |

## Global variables

| Kade | MineFunkin |
|---|---|
| `curBeat`, `curStep`, `songPos` | `beat`, `step`, `time` |
| `bpm`, `crochet` | `bpm`, `beats(1)` (one beat in ms) |
| `downscroll` | `player.downscroll` |
| `scrollspeed` | `scroll.speed` (change it with [scrollTo](../api/actions.md#scrollto)) |
| `mustHit` | `song.singer == "player"` |
| `screenWidth`, `screenHeight` / `hudWidth`, `hudHeight` | `screen.width`, `screen.height` |
| `difficulty`, `fpsCap`, `flashing`, `distractions` | not available |

---

## Kade's examples, translated

Kade's wiki ships eight example modcharts. Here's each one next to its MineFunkin version - you'll notice most of them
get a bit shorter.

### The full example (receptors in a circle)

=== "Kade"

    ```text
    function update(elapsed)
        local currentBeat = (songPos / 1000) * (bpm / 60)
        for i = 0, 7 do
            setActorX(_G['defaultStrum'..i..'X'] + 32 * math.sin((currentBeat + i * 0.25) * math.pi), i)
            setActorY(_G['defaultStrum'..i..'Y'] + 32 * math.cos((currentBeat + i * 0.25) * math.pi), i)
        end
    end
    ```

=== "MineFunkin"

    ```lua
    function onFrame(dt)
        local b = time / beats(1)               -- the beat as a fraction, like Kade's currentBeat
        for lane = 0, 3 do
            strum[lane].x = 32 * sin((b + lane * 0.25) * pi)
            strum[lane].y = 32 * cos((b + lane * 0.25) * pi)
        end
    end
    ```

### Spinning receptors

=== "Kade"

    ```text
    function update(elapsed)
        for i = 0, 7 do
            setActorAngle(getActorAngle(i) + 15, i)
        end
    end
    ```

=== "MineFunkin"

    ```lua
    function onFrame(dt)
        for lane = 0, 3 do
            strum[lane].angle = time / 3          -- a full turn a little faster than every second
        end
    end
    ```

Kade adds 15 degrees per frame, so it spins faster on a faster computer (someone with 240 fps gets a very different
song!). Working the angle out from `time` spins at the same speed for everyone.

### The spinning HUD

=== "Kade"

    ```text
    function update(elapsed)
        camHudAngle = camHudAngle + 0.005
    end
    ```

=== "MineFunkin"

    ```lua
    function onFrame(dt)
        hud.angle = time / 200
    end
    ```

### Spin at a specific part of the song

=== "Kade"

    ```text
    function update(elapsed)
        if curStep >= 352 and curStep < 400 then
            for i = 0, 7 do
                setActorAngle(getActorAngle(i) + 15, i)
            end
        else
            for i = 0, 7 do
                setActorAngle(0, i)
            end
        end
    end
    ```

=== "MineFunkin"

    ```lua
    function onFrame(dt)
        local spinning = step >= 352 and step < 400
        for lane = 0, 3 do
            strum[lane].angle = spinning ? time / 3 : 0
        end
    end
    ```

### Showing and hiding the receptors and the HUD

=== "Kade"

    ```text
    function start(song)
        showOnlyStrums = true
        strumLine1Visible = false
    end
    ```

=== "MineFunkin"

    ```lua
    function onStart()
        hideHud()
        hideJudgments()
        strums.opponentAlpha = 0       -- the opponent's receptors (practice)
    end
    ```

### Looping through the notes on screen

=== "Kade"

    ```text
    function update(elapsed)
        for i = 0, getRenderedNotes() do
            setRenderedNotePos(getRenderedNoteX(i), getRenderedNoteY(i) + 10 * math.sin(songPos / 100), i)
        end
    end
    ```

=== "MineFunkin"

    ```lua
    function onFrame(dt)
        for i = 0, notes.count - 1 do
            note[i].y = 10 * sin(time / 100)    -- an offset: 0 = where the note would be anyway
        end
    end
    ```

### Centering your side

Kade moves the player's receptors to the middle of the screen. In a MineFunkin fight, your lanes already are in the
middle - nothing to do. In practice, fade the opponent's receptors out (`strums.opponentAlpha = 0`) and slide yours
over with [moveStrums](../api/shortcuts.md#movestrums) if you like.

### Jumping arrows

=== "Kade"

    ```text
    function beatHit(beat)
        for i = 0, 7 do
            setActorY(_G['defaultStrum'..i..'Y'] - 20, i)
            tweenPosYAngle(i, _G['defaultStrum'..i..'Y'], 0, 0.3)
        end
    end
    ```

=== "MineFunkin"

    ```lua
    function onBeat(b)
        for lane = 0, 3 do
            strum[lane].y = -20
            tween(strum[lane].y, 0, beats(0.5), "quadOut")
        end
    end
    ```

Want more? Lots of modchart moves - with pictures - are in the [Modcharts](modcharts.md) guide.
