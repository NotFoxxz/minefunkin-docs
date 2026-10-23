---
icon: material/function-variant
---

# Functions and values

Functions work something out and hand you the answer, so you can use them anywhere a value fits:
`hud.angle = sin(time / 300) * 5`. (The ones that *do* something, like `tween` and `after`, are on
[Actions and timers](actions.md).)

| Kind | |
|---|---|
| [Built-in values](#built-in-values) | `time`, `beat`, `step`, `bpm`, `pi` |
| [Game state](#game-state) | score, combo, health, the song's progress, who sings - read only |
| [Durations](#durations) | `beats`, `steps`, `seconds`, `ms` |
| [Maths](#maths) | `sin`, `lerp`, `clamp`, `snap`, `pingpong`, ... |
| [Chance and noise](#chance-and-noise) | `random`, `randomInt`, `chance`, `noise` |
| [Colours](#colours) | `rgb`, `hsv`, `mix` |
| [Text](#text) | `str`, `upper`, `sub`, `find`, `replace`, ... |
| [Notes and fighters](#notes-and-fighters) | `noteSlot`, `atPlace` |
| [Your own functions](#your-own-functions) | `local function name(...) ... end` |

## Built-in values

| Name | Value |
|---|---|
| `time` | the song time in **milliseconds** |
| `beat` | the current beat (whole number, counts from 0) |
| `step` | the current step (a sixteenth, four per beat) |
| `bpm` | the tempo right now |
| `pi` | 3.14159... |

```lua
-- Sway the playfield once every two seconds, whatever the tempo.
function onFrame(dt)
    hud.angle = sin(time / 1000 * pi) * 3
end
```

<p class="mf-like">Psych: <code>getSongPosition()</code>, <code>curBeat</code>, <code>curStep</code>, <code>bpm</code> · Kade: <code>songPos</code>, <code>curBeat</code>, <code>curStep</code>, <code>bpm</code></p>

## Game state

Values the game keeps up to date; scripts read them like properties. Each has its entry on its property page:

| Page | What it answers |
|---|---|
| [player (your run)](player.md) | `player.score`, `.combo`, `.misses`, `.accuracy`, `.health`, `.downscroll` |
| [song](song.md) | `song.mode`, `.fight`, `.practice`, `.replay`, `.length`, `.progress`, `.singer`, `.side`, `.canHeal` |
| [screen](screen.md#screen-width) | `screen.width`, `screen.height` - the playfield's size |
| [strums](strums.md) / [strum[lane]](strum.md) | `strums.spacing`, `scroll.speed`, `strum[lane].isDown`, `.pressed` |
| [note[i]](notes.md) | `notes.count`, `note[i].lane`, `.time`, `.distance`, ... |
| [Fighters](fighters.md#homex) | `player.homeX`, `.homeY`, `.place` |
| [window](window.md) / [monitor](monitor.md) | the window's and the monitor's places and sizes, what works here |

```lua
-- The whole screen goes a little redder the lower your health is.
function onFrame(dt)
    screen.color = #FF0000
    screen.alpha = (1 - player.health) * 0.25
end
```

<p class="mf-like">Psych: <code>getProperty("health")</code>, <code>score</code>, <code>misses</code>, <code>rating</code>, <code>mustHitSection</code> · Kade: <code>downscroll</code>, <code>mustHit</code>, <code>screenWidth</code></p>

## Durations

Every duration in an action is in milliseconds. These turn musical lengths into milliseconds at the
tempo of the moment:

| Function | |
|---|---|
| `beats(n)` | n beats |
| `steps(n)` | n steps (a quarter beat each) |
| `seconds(n)` | n seconds |
| `ms(n)` | n milliseconds (as written - for readability) |

```lua
tween(camera.zoom, 1.1, beats(2), "sineInOut")    -- over two beats
after(steps(3), function() flash.alpha = 0.5 end)  -- three sixteenths later
```

## Maths

| Function | |
|---|---|
| `sin(x)`, `cos(x)`, `tan(x)` | x in **radians** (`pi` = half a turn) |
| `atan2(y, x)` | the angle of (x, y) in **degrees** |
| `abs(x)`, `sqrt(x)`, `exp(x)`, `ln(x)`, `pow(a, b)` | (`a ^ b` is the same as `pow(a, b)`) |
| `floor(x)`, `ceil(x)`, `round(x)`, `int(x)` | `int` cuts toward zero: `int(-1.5)` = -1, `floor(-1.5)` = -2 |
| `sign(x)` | -1, 0 or 1 |
| `min(a, b)`, `max(a, b)`, `clamp(x, lo, hi)` | |
| `lerp(a, b, t)` | from a (t = 0) to b (t = 1) |
| `smoothstep(e0, e1, x)` | 0 below e0, 1 above e1, a soft S-curve between |
| `snap(x, s)` | x rounded to a multiple of s: `snap(37, 10)` = 40 |
| `pingpong(x, length)` | 0 → length → 0 → length ... as x grows |

```lua
function onHit(note)
    -- A value that runs 0 → 1 → 0 over every bar:
    local wave = pingpong(beat % 4, 2) / 2

    -- Closer to the beat = more glow (0 ms off = 1, 80 ms or more = 0):
    local glow = 1 - smoothstep(0, 80, abs(note.offset))
    strum[note.lane].scale = 1 + 0.2 * glow * wave
end
```

## Chance and noise

| Function | |
|---|---|
| `random()` | a number from 0 to 1 |
| `random(a, b)` | a number from a to b |
| `randomInt(a, b)` | a whole number from a to b, both included: `randomInt(0, 3)` = a random lane |
| `chance(p)` | true with probability p (`chance(0.25)` = one in four) |
| `noise(x)` | smooth noise from -1 to 1. The same x always gives the same value, so it wobbles instead of jittering. |

```lua
-- A camera that drifts like a handheld one:
function onFrame(dt)
    camera.yaw = noise(time / 900) * 2
    camera.pitch = noise(time / 1100 + 50) * 1.5
end
```

`random()` gives the **same numbers every time** the song is played - on a restart, in its replay and for someone
watching from inside - so a "random" effect looks the same for everyone. Each script draws its own numbers (another
event added to the song doesn't change yours). `noise` is for a smooth wobble, `random` for a fresh pick.

## Colours

Colours are numbers written `#RRGGBB` (or `#AARRGGBB`). These make them:

| Function | |
|---|---|
| `rgb(r, g, b[, a])` | from 0-255 channels |
| `hsv(h, s, v[, a])` | hue in degrees, saturation and value 0-1, alpha 0-1 |
| `mix(c1, c2, t)` | c1 blended toward c2 by t (0-1) |

```lua
-- A colour that walks around the wheel, one turn every 4 beats:
flash.color = hsv(beat * 90 % 360, 0.7, 1)

-- Health from green to red:
underlay.color = mix(#FF3040, #30FF80, player.health)
```

`tween` on a colour property blends channel by channel, so colours fade smoothly too.

## Text

| Function | |
|---|---|
| `str(x)` | a value as text |
| `upper(s)`, `lower(s)` | |
| `len(s)` | how many characters |
| `sub(s, from[, to])` | a piece of the text, counting from 1. Negative counts from the end. |
| `find(s, part)` | where `part` first appears in `s` (from 1); 0 = not in it |
| `replace(s, what, with)` | every `what` in `s` replaced by `with` |
| `trim(s)` | the spaces at both ends cut off |
| `startsWith(s, part)`, `endsWith(s, part)` | true or false |

`..` joins text: `"Combo " .. player.combo`. `+` joins too when one side is text.

```lua
format 1.1

event {
    name = "Shout",
    description = "Shows value1 big; value2 = 'red' for red. Two lines with a | in between.",
}

function onEvent(p)
    local line = trim(p.value1)
    local bar = find(line, "|")

    if bar > 0 then
        text[2].value = upper(sub(line, 1, bar - 1))   -- before the |
        text[1].value = sub(line, bar + 1)              -- after it
    else
        text[2].value = upper(line)
    end

    text[2].color = startsWith(p.value2, "red") ? #FF3040 : #FFFFFF
end
```

| `sub` example | Gives |
|---|---|
| `sub("hello", 2, 4)` | `"ell"` |
| `sub("hello", 2)` | `"ello"` |
| `sub("hello", -3)` | `"llo"` |

`find`, `replace`, `startsWith` and `endsWith` mind upper and lower case - `"A"` isn't `"a"` for them
(while `==` ignores case).

## Modifiers

### mod

<p class="mf-sig"><code>mod(modifier[, field])</code> → number</p>

A [modifier](modifiers.md)'s value right now, on one field (left out = yours, 1). Works for your own ones
([`customMod`](shortcuts.md#custommod)) too.

```lua
function onFrame(dt)
    -- Follow the planned sway with the HUD a little.
    hud.x = mod("sway") / 10
end
```

### copyField

<p class="mf-sig"><code>copyField([source])</code> → number</p>

A new playfield: `1` (the default) = another copy of **your** notes, `0` = the **opponent's** notes, played by themselves.
Gives its number (2-7) - use it as the field in [`ease`](shortcuts.md#ease) and the others. A copy shows the same notes
you play: you hit once, every copy reacts. Call it in `onStart`. Six at most; past that it gives `-1` and says so in
the event log.

```lua
local mirror = 0

function onStart()
    mirror = copyField(1)
    set(0, 100, "flipSides", mirror)     -- the copy is mirrored
    set(0, 50, "fade", mirror)           -- and half see-through
end
```

<p class="mf-like">Psych modcharting tools: <code>addPlayfield()</code></p>

## Notes and fighters

### noteSlot

<p class="mf-sig"><code>noteSlot(id)</code></p>

Where the note with this [`id`](notes.md#note-id) is in the [`note[i]`](notes.md) list this frame, or -1 once it's
gone (hit, missed, off the screen). A note's place in the list moves on as the notes before it are hit; its `id`
stays.

```lua
local marked = -1

function onBeat(b)
    if notes.count > 0 then marked = note[notes.count - 1].id end   -- the last one on the screen
end

function onFrame(dt)
    local i = noteSlot(marked)
    if i >= 0 then note[i].scale = 1.5 end
end
```

### atPlace

<p class="mf-sig"><code>atPlace(place)</code></p>

Which fighter stands on a place right now: `atPlace("bf")` / `atPlace("dad")` gives 0 (you) or 1 (the other) - for
`puppet[atPlace("dad")]`. The places follow [`bind`](shortcuts.md#bind): without one, you stand on `"bf"`.

```lua
-- Whoever stands in the far spot glows red, whoever it is.
function onEvent(p)
    puppet[atPlace("dad")].color = #FF6060
end
```

## Your own functions

```lua
local function pulse(lane, amount)
    strum[lane].scale = 1 + amount
    tween(strum[lane].scale, 1, beats(0.5), "elasticOut")
end

local function strength(judgment)
    if judgment == "sick" then return 0.3 end
    if judgment == "good" then return 0.15 end
    return 0.05
end

function onHit(note)
    pulse(note.lane, strength(note.judgment))
end
```

Functions are defined at the top of a file (not inside another function), can take parameters and
`return` a value. They can call each other in any order: the file is read completely before anything
runs. The one function you write *inside* another is the one you hand to [after](actions.md#after) or
[every](actions.md#every).
