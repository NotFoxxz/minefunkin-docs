---
icon: material/code-braces
---

# Files and code

An event file is plain text. If you've seen Lua, it'll look familiar (`function ... end`, `local`,
`if ... then ... end`) - but it's MineFunkin's own language: smaller, with a few handy extras (`c ? a : b`, `??`,
`#RRGGBB` colours), and without the parts a chart never needs. Here's all of it on one page.

## The file

```lua
format 1.1
-- What the event does, in a comment.

event {
    name = "Name",                    -- the name charts use (case doesn't matter) - required
    alias = { "Old Name", "Other" },  -- more names that run this event (optional)
    color = #7C6BFF,                  -- the marker colour in the editor
    category = "Camera",              -- the group in the editor's type picker (default "Custom")
    description = "...",              -- shown in the editor
}

params {
    -- the event's controls in the editor - see Parameters
}

local count = 0                       -- variables (see below)

function onEvent(p)                   -- functions: the callbacks and your own helpers
    count += 1
end
```

- The first line that isn't blank or a comment is the **format line**: `format 1.1`, the only version
  MineFunkin runs (`format 1.0` files from the development builds before the first release are converted with one click
  - see [versions](../help/limits.md#versions)).
- The top of a file holds only these: `event { }` (required), `params { }`, variables, and functions.
  All code goes inside functions.
- Comments: `--` (or `##`) to the end of the line, and `--[[ ... ]]` across several lines.
- Line breaks and indentation don't matter. Blocks end with `end`.
- Text goes in double or single quotes. Inside the quotes, `\n` is a new line, `\t` a tab, and `\"`
  or `\'` a quote.
- Colours are written `#RRGGBB`, or `#AARRGGBB` with alpha.
- One file defines one event and may be at most 64 KB.

## The event header

`event { }` names the event and says how the editor shows it. Every key but `name` can be left out.

| Key | |
|---|---|
| `name` | The name charts use (case doesn't matter). A song's own file with the name (or an alias) of a built-in event replaces it for that song. |
| `alias` | More names that run this event: `alias = "Old Name"` or `alias = { "A", "B" }`. |
| `color` | The marker colour in the editor, `#RRGGBB`. |
| `category` | The group in the editor's type picker (default `"Custom"`). |
| `description` | What it does - the editor shows it in the picker and the inspector. |
| `only` | `"fight"` = runs only in fights (and their replays, and watching a fight from inside); `"practice"` = only at the Retro TV. Left out = everywhere. The [event log](../help/troubleshooting.md#the-event-log) says when an event doesn't run here. |

```lua
event {
    name = "Camera Swing",
    category = "Camera",
    color = #6BB8FF,
    description = "Swings the fight camera from side to side.",
    only = "fight",          -- practice stays calm
}
```

For a check inside the code instead of the whole file: [`song.mode`](song.md#song-mode).

## Variables

```lua
local count = 0        -- at the top: this event's own variable, kept for the whole song
shared mood = "calm"   -- at the top: one value shared by every event that declares it

function onBeat(b)
    local half = b / 2  -- inside a function: lives until the end of its block
    count += 1
end
```

Top-level variables start with their value when the song starts, and again on every restart. Use a
name only after declaring it with `local`. There are no global variables. `shared` variables are how
two files talk to each other - see [song scripts](../guides/song-scripts.md#talking-to-each-other-shared).

Some names are taken (`beat`, `step`, `time`, `camera`, `flash`, ...) - the error message says so, and
[Errors and fixes](../help/troubleshooting.md#taken-names) lists them all.

## Statements

| | |
|---|---|
| `x = value` | Sets a variable or property. Also `+=`, `-=`, `*=`, `/=`. `+=` on text appends. Setting a property stops a tween on it. |
| `local x = value` | A new local. |
| `if cond then ... elseif cond then ... else ... end` | Branches. |
| `for i = 1, 10 do ... end` | Counts from 1 to 10, both ends included. `for i = 10, 1, -1 do` counts down. `break` leaves the loop. |
| `return value` | Ends the function and gives the value back. |
| `name(...)` | Calls one of your functions, an [action](actions.md) or a [shortcut](shortcuts.md). |

There are no `while` or `repeat` loops; count with `for`. Semicolons between statements are optional.

## Values and operators

Values are numbers, text, `true`, `false` and `nil`. Colours are numbers written `#RRGGBB`.
`nil`, `false`, `0` and `""` count as false in conditions.

| Operator | |
|---|---|
| `c ? a : b` | a if c, else b |
| `a ?? b` | a, or b when a is nil |
| `or`, `and`, `not` | `a or b` gives a if it counts as true, else b; `a and b` gives b if a counts as true, else a |
| `==`, `!=` (or `~=`), `<`, `<=`, `>`, `>=` | comparison; text compares ignoring case |
| `..` | joins text: `"Score " .. player.score` (`+` also joins when one side is text) |
| `+`, `-`, `*`, `/`, `%`, `^` | `%` stays non-negative for a positive divisor (`-1 % 4` = 3); `^` is power |

Built-in values (`time`, `beat`, `step`, `bpm`, `pi`) and every function (`sin`, `lerp`, `hsv`,
`beats`, ...) are on [Functions](functions.md).

## Functions inside functions: `after`

The only function you write *inside* another one is the one you hand to `after`. It runs later and
remembers every local as it was when it was made, so each round of a loop keeps its own value:

```lua
function onEvent(p)
    for lane = 0, 3 do
        after(beats(lane * 0.5), function()
            strum[lane].angle = 0
            tween(strum[lane].angle, 360, beats(1), "backOut")
        end)
    end
end
```

Lane 0 spins at once, lane 1 half a beat later, and so on. Your own helper functions go at the top of
the file: see [Functions](functions.md#your-own-functions).
