---
icon: material/tune-variant
---

# Modifiers

Some modcharts are just a long list of lines like *"at beat 32, over 2 beats, ease sway to 100"*. MineFunkin has that
built in.

A **modifier** is a number that bends how a playfield is drawn - `sway` makes the lanes sway, `downscroll` flips the
scroll, `turnZ` turns the whole field, `cam.z` pulls the camera back. There are about seventy of them, they work in
3D, and you can have up to six extra playfields next to yours. Hitting never changes: whatever the field looks like,
you press at the same moment.

!!! tip "Two ways to modchart"
    The [Modcharts](modcharts.md) page moves lanes with properties (`strum[0].x = ...`) in `onFrame` - the Psych and
    Kade way. Modifiers are the planned way: you write *when* and *to what*, the game works out every frame in between.
    Mix them freely.

## Your first one

Save this as `modchart.event` in the song's folder and play the song:

```lua
format 1.1

event { name = "Modchart", category = "Song script" }

function onStart()
    ease(16, 2, "cubicOut", 100, "sway")      -- beat 16: sway in over 2 beats
    ease(16, 2, "cubicOut", 50, "hover")      -- and bob up and down
    ease(30, 2, "cubicIn", 0, "sway")         -- and calm down again
    ease(30, 2, "cubicIn", 0, "hover")
    set(32, 100, "downscroll")                -- beat 32: the scroll flips
    set(40, 0, "downscroll")                  -- beat 40: back
end
```

Everything happens in `onStart`, before the song plays: you **plan** the changes on the song's beats. That's all a
modchart of this kind is - a list.

- [`ease(beat, beats, easing, value, modifier)`](../api/shortcuts.md#ease) - from `beat` on, over `beats` beats, to
  `value`.
- [`set(beat, value, modifier)`](../api/shortcuts.md#set) - jumps there at `beat`.
- [`add(beat, beats, easing, amount, modifier)`](../api/shortcuts.md#add) - `amount` more than it is at that moment.

Beats count from the song's start (beat 0) and follow tempo changes. Half beats are fine: `ease(32.5, 0.25, ...)`.

## How the numbers work

Most modifiers are **percent**: 0 = off, 100 = the full effect, 200 = twice that, -100 = the other way. A few are pixels
(`x`, `slideY`, `cam.z` ...) - measured on a 1280 x 720 screen, so a number fits whatever
size the game window is - and a few degrees (`turnZ`, `faceY` ...). Every one of them, with what it does, is on the
[Modifiers](../api/modifiers.md) page of the Event API.

When two changes overlap, **the one that started last decides**, and it starts from wherever the value is at that
moment. So you never have to work out "where is it right now?" - just say where it should go:

```lua
ease(8, 4, "linear", 100, "sway")     -- 0 -> 100 over beats 8-12
ease(10, 1, "linear", 0, "sway")      -- at beat 10 it's 50: from 50 down to 0
```

If you *do* want a fixed start, give it as the last value: `ease(10, 1, "linear", 0, "sway", 1, 200)` starts at 200.

## One lane, or all four

Many modifiers have a form for a single lane: add the lane's number (0 left, 1 down, 2 up, 3 right).

```lua
set(48, 100, "downscroll1")   -- only the down lane scrolls the other way
set(48, 100, "downscroll3")   -- and the right lane
ease(48, 2, "backOut", -40, "slideY0")  -- the left lane hops up 40 px
```

The lane's own value **adds** to the field's: `sway` 50 and `sway2` 50 = lane 2 sways at 100.

## More playfields

Your notes are on field **1**. [`copyField()`](../api/functions.md#copyfield) gives you another one - a copy of your notes
with modifiers of its own. You play once; every copy reacts.

```lua
local left = 0
local right = 0

function onStart()
    left = copyField(1)
    right = copyField(1)
    set(0, -320, "x", left)
    set(0, 320, "x", right)
    set(0, 60, "fade", left)                -- the copies are see-through
    set(0, 60, "fade", right)
    ease(64, 4, "sineInOut", 100, "flipSides", right)   -- one of them mirrors itself
end
```

The last value of `ease`, `set` and `add` is the field: a number, or a text like `"1 2"` or `"all"`. Left out = every
field. `copyField(0)` shows the **opponent's** notes instead, played by themselves - field 0 itself (the opponent's own
row) is never drawn with modifiers, because a fight never shows the opponent's lanes.

## 3D

Fields live in a little 3D space: `z` brings a field toward you, `turnX` tips it back like a road, `turnY` turns
it sideways, `faceY` flips the arrows like cards. Each field has a camera you can move (`cam.z`, `cam.rotY`) and a lens
(`cam.fov`, 45 = normal, wider = stronger 3D).

```lua
function onStart()
    ease(96, 4, "cubicOut", -50, "turnX")        -- tip the field back
    ease(96, 4, "cubicOut", 600, "cam.z")        -- and step back to see it
    ease(104, 2, "sineInOut", 360, "faceY")      -- every arrow flips once
    ease(112, 4, "cubicIn", 0, "turnX")
    ease(112, 4, "cubicIn", 0, "cam.z")
end
```

Arrows are flat pictures: seen from the side they get thin, like a card. From behind
they still show their arrow the right way round - left stays left, right stays right.

## Changing them live

Sometimes a value can't be planned - it answers the player, or you work it out from something else. Then use
[`setMod`](../api/shortcuts.md#setmod) and read with [`mod()`](../api/functions.md#mod):

```lua
-- The field tips toward the lane you just hit, and settles.
function onHit(n)
    setMod("turnZ", (n.lane - 1.5) * 6)
end

function onFrame(dt)
    setMod("turnZ", mod("turnZ") * 0.9)
end
```

`setMod` in `onFrame` is fine - it doesn't pile anything up. It does win over a planned `ease` on the same modifier
from that moment on, so give live values their own modifiers.

## Your own modifiers

[`customMod("name")`](../api/shortcuts.md#custommod) makes a modifier of your own: you plan it with `ease` like any other, it
draws nothing, and in `onFrame` you turn it into whatever you like. That's how two planned values can add up, or how a
planned curve drives a screen effect:

```lua
function onStart()
    customMod("glitch")
    ease(128, 0.5, "cubicOut", 1, "glitch")
    ease(128.5, 2, "cubicIn", 0, "glitch")
end

function onFrame(dt)
    fx.glitch = mod("glitch")
end
```

Declare your own ones in `onStart` of every file that uses them (twice is fine). A name the game doesn't know - and you
didn't declare - is an error when the file loads, with a "did you mean ...?".

## Coming from Psych or Kade

The names are MineFunkin's own, so a port means rewriting the lines with our names (a name the game doesn't know is an
error with a "did you mean ...?"):

| Engine | Theirs | Here |
|---|---|---|
| Psych (modcharting tools) | `ease(32, 2, 'cubeOut', '100, drunk')` | `ease(32, 2, "cubicOut", 100, "sway")` |
| Psych (modcharting tools) | `setMod('drunk', 1)`, `addPlayfield()` | `setMod("sway", 100)`, `copyField(1)` |
| Kade 1.8 | `camNotes.angle`, `createWiggle` | `turnZ`, the `ripple` modifier |

Modifier names from Psych's modcharting tools and ours:

| Theirs | Ours |
|---|---|
| `drunk`, `tipsy`, `bumpy`, `tornado`, `beat` | `sway`, `hover`, `bulge`, `twister`, `kick` |
| `confusion`, `dizzy`, `tiny`, `pulse` | `twirl`, `tumble`, `shrinkArrows`, `breathe` |
| `confusionXOffset` / `YOffset` / `Offset` | `faceX`, `faceY`, `faceZ` |
| `reverse`, `flip`, `invert` | `downscroll`, `flipSides`, `swapPairs` |
| `movex`, `movey`, `movez` | `slideX`, `slideY`, `slideZ` |
| `rotationx`, `rotationy`, `rotationz` | `turnX`, `turnY`, `turnZ` |
| `mini` | `shrink` |
| `xmod`, `boost`, `brake`, `wave` | `speed`, `speedUp`, `slowDown`, `speedWave` |
| `dark`, `stealth` | `fadeStrums`, `fadeNotes` |
| `hidden`, `sudden` (+ `offset`) | `hideNear`, `hideFar` (+ `.offset`, `.fade`) |
| Kade's note wiggle | `ripple` (+ `.freq`, `.speed`) |

Easings are the usual names (`"sineInOut"`, `"cubicOut"` ...). Every modifier, with what it
does, is on the [Modifiers](../api/modifiers.md) page.

## Good to know

- **It's the drawing only.** Notes are judged exactly as without modifiers - in practice and in fights.
- **Seeking is free.** A modifier's value depends only on the beat, so skipping in a replay, watching a fight from inside
  or the editor's preview land on exactly the same picture.
- **A script that breaks takes its changes with it.** Its planned modifiers go, the others stay.
- **Limits:** 200 000 planned changes per song, 8 fields (yours, the opponent's, 6 of your own), 256 own modifiers.
- Modifiers reset with the song: a restart starts from your `onStart` again.
