---
icon: material/lightning-bolt-outline
---

# Shortcuts

The easy mode, and nothing to be ashamed of. One call each for the things charts do all the time: flash the screen,
zoom, hide the HUD, flip the scroll, swap the fighters. You don't need to know anything about properties or tweens to
use them - put them inside `onEvent` (or any other [callback](callbacks.md)) and they just work.

```lua
format 1.1

event { name = "Chorus Hit" }

function onEvent(p)
    flash(#FF6EC7)        -- a pink flash
    shake(0.01)           -- a short shake
    zoom(1.1, beats(1))   -- zoom in over one beat, and stay
    hideHud(beats(2))     -- the score line fades out
end
```

| Kind | Shortcuts |
|---|---|
| Modifiers | [ease](#ease) · [set](#set) · [add](#add) · [setMod](#setmod) · [customMod](#custommod) |
| Lanes and scroll | [flipScroll](#flipscroll) · [setScroll](#setscroll) · [hideStrums / showStrums](#hidestrums) · [hideLane / showLane](#hidelane) · [moveStrums](#movestrums) · [resetLanes](#resetlanes) |
| HUD | [hideHud / showHud](#hidehud) · [hideJudgments / showJudgments](#hidejudgments) |
| Screen | [flash](#flash) · [fadeOut / fadeIn](#fadeout) · [zoom](#zoom) · [shake](#shake) |
| Fighters | [focus](#focus) · [swapFighters](#swapfighters) · [pose](#pose) · [setPose / clearPose](#setpose) · [setSkin](#setskin) · [setModel](#setmodel) · [bind / unbind](#bind) |
| Effects | [setShaderFloat](#setshaderfloat) |
| Health <span class="mf-tag fight">fights</span> | [setHealth / addHealth](#sethealth) |
| Sound | [stopSound](#stopsound) · [soundVolume](#soundvolume) |
| Events together | [trigger](#trigger) · [call / callIn](#call) · [preload](#preload) |
| Debugging | [inspect](#inspect) |

**The duration is always optional.** Left out, hiding, showing, moving and zooming happen at once; the
flash, the fades, the shake, the camera's focus and the fighters' swap take one beat. Write durations with
`beats(2)`, `steps(4)`, `seconds(0.5)` or `ms(300)`. Everything a shortcut changes goes back by itself when
the song ends.

A word a shortcut doesn't take (`setScroll("sideways")`, `pose("plyer", "left")`) or a lane that doesn't
exist is an error when the file loads, with a "did you mean ...?" - not a surprise in the middle of the song.

## Modifiers

The [modifiers](modifiers.md): numbers that bend how a field is drawn, planned on the song's **beats**. Usually all of
it goes into `onStart`: one line per change, in any order. Seeking, watching from inside, replays and the editor all land on the same picture, because a
modifier's value only depends on the beat. The guide: [Modifiers](../guides/modifiers.md).

The last two values are the same everywhere: the **field** (1 = yours, 2-7 = ones [`copyField()`](functions.md#copyfield)
made, a text like `"1 2"` or `"all"`; left out = every field) and, for `ease`, where it starts **from** (left out =
wherever it is at that beat).

### ease

<p class="mf-sig"><code>ease(beat, beats, easing, value, modifier[, field[, from]])</code></p>

From `beat` on, over `beats` beats, the modifier eases to `value`. The [easing](choices.md#easing) is one of the usual
names - `"cubicOut"`, `"sineInOut"`, `"linear"` ... - plus two of the modifiers' own: `"instant"` (there at once) and `"arc"` (out to the value and back where it was).

The latest change that started decides: an `ease` that starts while another one runs takes over from wherever the value
is at that moment.

```lua
function onStart()
    ease(32, 2, "cubicOut", 100, "sway")         -- every field
    ease(32, 2, "cubicOut", -300, "z", 1)        -- only yours, 300 px back
    ease(40, 1, "arc", 45, "turnZ")              -- tip over and back in one beat
    ease(48, 4, "linear", 0, "sway", "all", 150)  -- from 150 down to 0
end
```

<p class="mf-like">Psych modcharting tools: <code>ease(32, 2, 'cubeOut', '100, drunk')</code></p>

### set

<p class="mf-sig"><code>set(beat, value, modifier[, field])</code></p>

At `beat`, the modifier jumps to `value`.

```lua
function onStart()
    set(64, 100, "downscroll")   -- the scroll flips at beat 64
    set(72, 0, "downscroll")
end
```


### add

<p class="mf-sig"><code>add(beat, beats, easing, amount, modifier[, field])</code></p>

Like `ease`, but to `amount` **more** than the value is at that beat - for kicks that stack on whatever is going on.

```lua
-- Every bar the field turns a quarter further.
function onStart()
    for bar = 0, 15 do
        add(bar * 4, 1, "backOut", 90, "turnZ")
    end
end
```


### setMod

<p class="mf-sig"><code>setMod(modifier, value[, field])</code></p>

The modifier is `value` right now - for values you work out yourself every frame (in `onFrame`) or that answer the
player (in `onHit`). Calling it every frame is fine: it moves one entry along instead of piling them up.

```lua
-- The field leans toward the lane you just hit.
function onHit(n)
    setMod("turnZ", (n.lane - 1.5) * 4)
end
```

<p class="mf-like">Psych modcharting tools: <code>setMod('drunk', 1)</code> · Kade: <code>receptor.angle = ...</code></p>

### customMod

<p class="mf-sig"><code>customMod(name[, default])</code></p>

A modifier of **your own**: a number on the same timeline - eased with `ease`, read with [`mod()`](functions.md#mod) -
that draws nothing by itself. Use it for values you turn into something else in `onFrame`, or to let two planned
values add up. Declare it in `onStart` of **every file** that uses it (declaring it twice is fine).

```lua
function onStart()
    customMod("glitch")
    ease(64, 4, "sineOut", 1, "glitch")
    ease(72, 1, "sineIn", 0, "glitch")
end

function onFrame(dt)
    fx.glitch = mod("glitch")             -- a planned value driving a screen effect
end
```


---

## Lanes and scroll

Lanes are numbered 0 (left), 1 (down), 2 (up), 3 (right).

### flipScroll

<p class="mf-sig"><code>flipScroll([lane])</code></p>

Downscroll becomes upscroll and the other way round - every lane, or just one.

```lua
flipScroll()      -- the whole strumline
flipScroll(2)     -- only the up lane
```

<p class="mf-like">Psych: <code>setPropertyFromClass("ClientPrefs", "downScroll", ...)</code> · Changes <code>strums.scroll</code> / <code>strum[lane].scroll</code></p>

### setScroll

<p class="mf-sig"><code>setScroll(direction[, lane])</code></p>

Sets the scroll direction: `"up"`, `"down"`, or `"auto"` (back to the player's own setting) - for every lane
or one.

```lua
setScroll("down")        -- everybody scrolls down
setScroll("up", 0)       -- except the left lane
```

### hideStrums

<p class="mf-sig"><code>hideStrums([duration])</code><br><code>showStrums([duration])</code></p>

Fades your whole strumline (receptors, notes, holds) out / in.

```lua
hideStrums(beats(2))
after(beats(8), function() showStrums(beats(1)) end)
```

<p class="mf-like">Kade: <code>showOnlyStrums</code> / <code>strumLine1Visible</code> · Changes <code>strums.alpha</code></p>

### hideLane

<p class="mf-sig"><code>hideLane(lane[, duration])</code><br><code>showLane(lane[, duration])</code></p>

Fades one lane out / in.

```lua
hideLane(1, beats(1))
```

### moveStrums

<p class="mf-sig"><code>moveStrums(x, y[, duration])</code></p>

Moves the whole strumline by that many pixels (right, down). `moveStrums(0, 0)` = home.

```lua
moveStrums(-120, 0, beats(2))     -- slide left over two beats
```

<p class="mf-like">Changes <code>strums.x</code>, <code>strums.y</code></p>

### resetLanes

<p class="mf-sig"><code>resetLanes([duration[, ease]])</code></p>

Every lane back to normal: position, wobble, angle, size, opacity, colour, note opacity, scroll direction -
and the ways in, speeds and note angles.

```lua
resetLanes(beats(1))
```

---

## HUD

### hideHud

<p class="mf-sig"><code>hideHud([duration])</code><br><code>showHud([duration])</code></p>

The score line, the song title and the hearts.

```lua
hideHud(beats(2))
```

<p class="mf-like">Psych: <code>setProperty("camHUD.alpha", 0)</code> · Changes <code>hud.alpha</code></p>

### hideJudgments

<p class="mf-sig"><code>hideJudgments([duration])</code><br><code>showJudgments([duration])</code></p>

The "Sick!" / "Good" popups, the combo and the ms label.

```lua
hideJudgments()
```

<p class="mf-like">Changes <code>judgments.alpha</code></p>

---

## Screen

### flash

<p class="mf-sig"><code>flash([colour[, duration]])</code></p>

A flash over the whole picture that fades out - white unless you give a colour. One beat unless you give a
duration.

```lua
flash()                          -- white, one beat
flash(#FF3040, beats(0.5))       -- red, half a beat
```

<p class="mf-like">Psych: <code>cameraFlash</code> · Changes <code>flash.color</code>, <code>flash.alpha</code></p>

### fadeOut

<p class="mf-sig"><code>fadeOut([colour[, duration]])</code><br><code>fadeIn([duration])</code></p>

Fades the picture to a colour (black unless given) and stays there; `fadeIn` fades back.

```lua
fadeOut(#000000, beats(0.5))                      -- a cut to black
after(beats(4), function() fadeIn(beats(2)) end)
```

<p class="mf-like">Psych: <code>cameraFade</code> · Changes <code>screen.color</code>, <code>screen.alpha</code></p>

### zoom

<p class="mf-sig"><code>zoom(z[, duration])</code></p>

Zooms to `z` (1 = normal, 1.2 = closer) and stays there. At once without a duration. In a fight the world
camera zooms along.

```lua
zoom(1.15, beats(1))
```

<p class="mf-like">Psych: <code>doTweenZoom</code> / <code>setProperty("defaultCamZoom", ...)</code> · Kade: <code>cameraZoom</code> · Changes <code>camera.zoom</code></p>

### shake

<p class="mf-sig"><code>shake(strength[, duration])</code></p>

Shakes that hard (0.01 is a good start) and calms down over the duration.

```lua
shake(0.02, beats(2))
```

<p class="mf-like">Psych: <code>cameraShake</code> · Changes <code>camera.shake</code></p>

---

## Fighters

In a fight they work on the fighters in the world; in practice (the Retro TV) `pose`, `setPose`, `setSkin`,
`setModel` and `bind(who, x, y)` work on the two puppets beside the lanes. `focus`, `swapFighters` and the places of
`bind` need a fight <span class="mf-tag fight">fights</span>.

`who` is a [fighter name](choices.md#fighter-names): `"player"`, `"opponent"`, `"boyfriend"`, `"dad"`, or `"both"`
where it makes sense.

### focus

<p class="mf-sig"><code>focus(who[, duration])</code></p>

The [fight camera](../guides/camera.md) leans toward `"opponent"` or `"player"`, or back to `"center"`.

```lua
function onBeat(b)
    if song.singer == "opponent" then focus("opponent")
    elseif song.singer == "player" then focus("player") end
end
```

<p class="mf-like">Psych: <code>cameraSetTarget</code> · Changes <code>camera.x</code>, <code>camera.z</code>, <code>camera.yaw</code></p>

### swapFighters

<p class="mf-sig"><code>swapFighters([duration])</code></p>

The fighters jump over each other and trade places. Call it again to swap back.

```lua
swapFighters(beats(1))
```

### pose

<p class="mf-sig"><code>pose(who, name)</code></p>

Plays one of the fighters' poses: `"left"`, `"down"`, `"up"`, `"right"`, `"death"`, or `"none"` to let go. A
pose holds like a held note until `"none"`.

```lua
pose("opponent", "up")
after(beats(2), function() pose("opponent", "none") end)
```

<p class="mf-like">Psych: <code>playAnim</code> / <code>characterPlayAnim</code> · Kade: <code>playActorAnimation</code></p>

### setPose

<p class="mf-sig"><code>setPose(who, pose, part, pitch[, yaw[, roll]])</code><br><code>clearPose(who[, pose])</code></p>

The song's **own** pose for a fighter, built part by part: for `"idle"`, `"left"`, `"down"`, `"up"` or `"right"`
([poses](choices.md#poses)), one [body part](parts.md) (`"head"`, `"body"`, `"leftArm"`, `"rightArm"`, `"leftLeg"`,
`"rightLeg"`) at these angles in degrees - the same signs as `player.head.pitch`. Call it once per part; the first call
on a pose starts it from the rest pose.

From then on, when a note of that direction comes, the fighter pops into **your** pose (a little overdone), holds it
and eases back - exactly like MineFunkin's own poses. A song idle stays still with a small dip every second beat.
`clearPose` gives MineFunkin's pose back - one, or all five without a name. The song's end clears them too.

In a fight the players standing around see these poses too: your game sends them along.

```lua
-- Our own "up": both arms up, head back, a slight lean.
function onStart()
    setPose("both", "up", "leftArm", 0, 0, 160)
    setPose("both", "up", "rightArm", 0, 0, 160)
    setPose("both", "up", "head", -20)
    setPose("both", "up", "body", -8)
end
```

<p class="mf-like">Psych: a character's <code>animations</code> in its JSON, <code>playAnim</code> · Kade: <code>playAnim</code></p>

### setSkin

<p class="mf-sig"><code>setSkin(who, skin)</code></p>

A fighter's Minecraft skin: a 64x64 skin `.png` from the song folder, `"opponent"` / `"player"` (that
fighter's own skin), or `""` (back to its own).

```lua
setSkin("player", "opponent")       -- the fighters wear each other's skin
setSkin("opponent", "player")
```

<p class="mf-like">Psych: the "Change Character" event · Kade: <code>changeDadCharacter</code></p>

### setModel

<p class="mf-sig"><code>setModel(who, model)</code></p>

The arm shape: `"slim"` (Alex), `"wide"` (Steve) or `"default"` (what the skin says).

```lua
setModel("both", "slim")
```

### bind

<p class="mf-sig"><code>bind(who, place)</code><br><code>bind(who, x, y[, height])</code><br><code>unbind(who)</code></p>

**A place:** `bind(who, "bf")` puts a fighter on Boyfriend's place (in front, bottom right - the camera stands behind
it), `"dad"` on the opponent's (far, left); the other fighter takes the other place. The camera never moves for it,
and [`focus`](#focus), [`atPlace`](functions.md#atplace) and everything that asks for a place follow it.

**A spot on the screen:** `bind(who, x, y[, height])` pins a fighter like a sprite: its feet at `x`, `y` (shares of the
screen, 0-1), and with `height` that tall as a share of the screen. The same as setting
[`pinned`, `screenX`, `screenY`, `screenHeight`](fighters.md#pinned).

`unbind(who)` lets go of both: back on the fight's own places (you in front), off the screen spot.

```lua
-- The Boyfriend part always in front, whichever side the one watching plays.
function onStart()
    bind("boyfriend", "bf")
end
```

```lua
-- Like a Psych stage: Boyfriend bottom right, the opponent bottom left, half the screen tall.
bind("boyfriend", 0.8, 0.98, 0.5)
bind("dad", 0.22, 0.98, 0.5)
```

<p class="mf-like">Psych: a stage's <code>boyfriend</code> / <code>opponent</code> positions, <code>setCharacterX</code></p>

---

## Effects

### setShaderFloat

<p class="mf-sig"><code>setShaderFloat(slot, "name", value)</code></p>

Sets a `uniform float` / `int` / `bool` of the song's shader in that [slot](shader.md) - the way Psych scripts drive
a `.frag` file. Up to 16 names per slot; a name the shader doesn't declare does nothing. A value that isn't set is 0,
except `iTime`, which runs with the song's seconds.

```lua
function onStart()
    shader[0].file = "chroma.frag"
    setShaderFloat(0, "intensity", 0.5)
end

function onBeat(b)
    setShaderFloat(0, "intensity", 1.5)
end
```

<p class="mf-like">Psych: <code>setShaderFloat(tag, name, value)</code> - with the slot instead of the tag</p>

---

## Health

### setHealth

<p class="mf-sig"><code>setHealth(share)</code><br><code>addHealth(share)</code></p>

Your health bar: `setHealth` sets it (1 = full, 0 = empty, which fails you), `addHealth` changes it by that
share of the bar - minus drains, plus heals. <span class="mf-tag fight">fights</span> Practice has no health,
so these do nothing there.

```lua
-- Health drain: the opponent's notes take a little, but never the last bit.
function onOpponentHit(n)
    if player.health > 0.1 then addHealth(-0.01) end
end
```

<p class="mf-like">Psych: <code>setHealth</code> / <code>addHealth</code> · Read it as <code>player.health</code></p>

---

## Sound

The sounds themselves start with the actions [playSound](actions.md#playsound) and
[loopSound](actions.md#loopsound) - see [Sounds and music](../guides/sound.md).

### stopSound

<p class="mf-sig"><code>stopSound("name")</code></p>

Stops the sound started under that name.

```lua
stopSound("rain")
```

<p class="mf-like">Psych: <code>stopSound(tag)</code></p>

### soundVolume

<p class="mf-sig"><code>soundVolume("name", volume[, duration])</code></p>

Fades a named sound to that volume (0-1). At once without a duration.

```lua
soundVolume("rain", 0, beats(4))
```

<p class="mf-like">Psych: <code>soundFadeIn</code> / <code>soundFadeOut</code> / <code>setSoundVolume</code></p>

---

## Events together

### trigger

<p class="mf-sig"><code>trigger("Event Name"[, value1[, value2]])</code></p>

Runs that event's `onEvent` right now, as if the chart had it here. The values are text, like a chart's. A
name the song doesn't have does nothing - the [event log](../help/troubleshooting.md#the-event-log) says so once,
with the name it probably should have been.

```lua
function onSection(n)
    if n == 16 then trigger("Hide HUD", "0", "1") end   -- a built-in event, with its chart values
end
```

<p class="mf-like">Psych: <code>triggerEvent(name, value1, value2)</code></p>

### call

<p class="mf-sig"><code>call("name"[, values...])</code><br><code>callIn("Event Name", "name"[, values...])</code></p>

`call` runs your function of that name in every *other* event of the song that has one, with up to 6 values.
`callIn` runs it in **one** event only, picked by its name or alias - an event added later with a function of the same
name doesn't join in. Calls can go 64 deep.

```lua
call("bigHit", 2)                  -- every event with a function bigHit(strength) runs it
callIn("Impact", "hit", 1.5)       -- only the Impact event's hit(1.5)
```

<p class="mf-like">Psych: <code>callOnLuas(name, args)</code></p>

### preload

<p class="mf-sig"><code>preload("picture.png")</code></p>

Starts loading a picture now, so it shows the moment you first use it. Put it in `onStart`.

```lua
function onStart()
    preload("stage/fire.png")
end
```

<p class="mf-like">Psych: <code>precacheImage</code></p>

---

## Debugging

### inspect

<p class="mf-sig"><code>inspect("property")</code></p>

Writes to the [event log](../help/troubleshooting.md#the-event-log) what a property is right now and **why**: its value
and default, its range and unit, which event set it, the tween moving it, and what other events wrote under it.
`"strum[2].x"` for one slot. The answer to "why is my HUD invisible?".

```lua
function onSection(n)
    if n == 8 then inspect("hud.alpha") end
end
```

The chart editor's **State** panel shows the same for every property at the playhead, without a script.

---

## What a shortcut changes

Every shortcut is made of [properties](properties.md) - the same ones you can set yourself. That matters when
you mix them with your own code: the last thing that sets a property wins. So `hideHud()` and a
`tween(hud.alpha, ...)` of your own at the same time fight each other.

| Shortcut | Changes |
|---|---|
| `flipScroll`, `setScroll` | `strums.scroll`, `strum[lane].scroll` |
| `hideStrums`, `showStrums` | `strums.alpha` |
| `hideLane`, `showLane` | `strum[lane].alpha` |
| `moveStrums` | `strums.x`, `strums.y` |
| `hideHud`, `showHud` | `hud.alpha` |
| `hideJudgments`, `showJudgments` | `judgments.alpha` |
| `flash` | `flash.color`, `flash.alpha` |
| `fadeOut`, `fadeIn` | `screen.color`, `screen.alpha` |
| `zoom` | `camera.zoom` |
| `shake` | `camera.shake` |
| `focus` | `camera.x`, `camera.z`, `camera.yaw` |
| `swapFighters` | `player.` / `opponent.` `x`, `y`, `z`, `turn` |
| `pose`, `setSkin`, `setModel` | `player.pose`, `.skin`, `.model` (and the same for `opponent.`) |
| `setPose`, `clearPose` | no property - the fighter's pose designs |
| `bind`, `unbind` | `player.place` / `opponent.place`, or `.pinned`, `.screenX`, `.screenY`, `.screenHeight` |
| `setShaderFloat` | the shader's own values (not `shader[n].a` ... `d`) |
| `inspect` | nothing - it only writes to the log |
| `setHealth`, `addHealth` | your health (read it as `player.health`) |
| `stopSound`, `soundVolume` | only the named sound |
| `trigger`, `call`, `callIn` | whatever the event or function they run changes |
| `preload` | nothing - it only loads |
