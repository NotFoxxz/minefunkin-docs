---
icon: material/bug-outline
---

# Errors and fixes

Something's not working? Don't panic - almost every problem has been hit by someone before, and MineFunkin tries
hard to tell you exactly what's wrong. This page helps you read what it says.

## Nothing happens

The most frustrating kind of bug: no error, just ... nothing. Work down this list, one by one - the answer is usually
in the first four:

1. **Is the file where the song is?** In the song's folder or its `events/` folder. Files of other
   songs are never read.
2. **Does the editor list it?** Open the song in the chart editor. If the file is listed under
   *can't be used* at the bottom of the inspector, the reason is right there (see below).
3. **Does the chart call it by its name?** The chart event's type must be the file's
   `event { name }` or one of its aliases (case doesn't matter). The log lists chart events no file
   defines.
4. **Is it a fight thing?** The [camera](../guides/camera.md), the [fighters](../guides/fighters.md) and `"world"` /
   `"terrain"` [effects](../guides/effects.md) only exist in a fight (at a Speaker). In practice they do nothing.
5. **Is it a window thing?** [Pop-outs and the game window](../guides/windows.md) do nothing when the player
   switched off *Let songs use windows* in the options, pop-outs can't open on Linux with Wayland, and
   `window.transparent` works on Windows only.
6. **Is it switched off?** Players can switch off built-in events under Options › MineFunkin › Song effects.
7. **Did it fail while running?** A script that runs into an error is switched off for the rest of the
   run. The log says where.
8. **Does another script overwrite it?** Two scripts setting the same property every frame: only the
   last one shows. The log names both.
9. **Paused or counting down?** Nothing runs then.

## The event log

Your best friend when debugging. `logs/minefunkin-events.log`, right next to Minecraft's `latest.log`, has everything
that happens with events. It starts fresh every time the game starts; the one before is kept as
`minefunkin-events.prev.log`.

```
[18:21:04] [INFO] Built-in events (21): Add Camera Zoom, Beat Bump, Countdown, ...
[18:21:09] [INFO] Song "showcase": 31 event files of its own: "Build Up" (events/build_up.event), ...
[18:21:09] [WARN] Song "fxtest": fxtest.event can't be used - line 5:17: 'beat' is a reserved word - pick another name
[18:21:12] [INFO] Song started: "Event Showcase" [Normal] (fight) - 101 chart events
[18:21:13] [INFO]     0.000s  Power On  [EVENT SHOWCASE] [every effect is a .event file in this song's folder]
[18:21:38] [INFO] Shader "ripple.fsh" loaded
[18:21:40] [INFO] Beat Flash on in #FFE35C
```

It writes down the built-ins and each song's own files, every file that can't be used, every song start, every chart
event as it fires (with its values), chart events no file answers to, script errors, missing sounds, pictures and
shaders, and your own `log(...)` lines. Warnings and errors also go into `latest.log`. Once the file passes 8 MB it
only takes warnings and errors, so it can't fill your disk.

## When a file can't be used

A file with a mistake in it never runs at all - better than half-running and doing weird things. The message gives
you the line and column (`line 5:17`) and says what's wrong, often with a guess at what you meant. The most common
ones:

| Message | What to do |
|---|---|
| `'beat' is a reserved word - pick another name` | That name is taken (see the list below). Rename your variable or parameter: `function onBeat(n)` instead of `onBeat(beat)`. |
| `unknown name 'x' - declare it first with local` | Every variable needs a `local` (or `shared`) first. There are no globals. Also check the spelling. |
| `unknown property strums.alhpa - did you mean alpha?` | A typo, or a property that doesn't exist. The message suggests the closest names. |
| `unknown function flipscroll() - did you mean flipScroll?` | Names are case-sensitive: `flipScroll`, not `flipscroll`. |
| `strums.alpha goes from 0 to 1, not 5` | A constant outside what the property takes (opacities and volumes 0-1, `hud.bars` 0-3, `camera.nudge` 0-5). |
| `text[i].layer takes "back", "lanes", "front", "top" - not "middle"` | A word a property or shortcut doesn't take (often with a "did you mean ...?"), or a lane that doesn't exist. |
| `flipScroll is called like this: flipScroll() or flipScroll(lane)` | A shortcut with too many or too few values. |
| `the file never names its event - add: event { name = "My Event" }` | Every file needs `event { name = "..." }`, even a song script. |
| `the top of the file holds event { }, params { }, local / shared variables and functions` | Code outside a function. Move it into `onStart`, `onEvent` or another callback. |
| `functions are defined at the top of the file, not inside another function` | Define helpers at the top level, call them from inside. Inside a function, use `function() ... end` only as an `after` callback. |
| `the file ends inside a block - an 'end' is missing` | An `if`, `for` or `function` without its `end`. |
| `expected ...` | A syntax slip: a missing `then` / `do`, a bracket, a comma between parameters. |
| `only number and colour properties can be animated` | `tween` on text or a switch. Set those directly. |
| `note[i] goes back every frame - set it in onFrame instead of tweening it` | `note[i]` is a different note from frame to frame. Work its values out in `onFrame` (see [notes one by one](../api/notes.md)). |
| `'note' is your own variable here, so note[i] isn't reachable` | A parameter or variable called `note` (`function onHit(note)`) hides the list of notes. Rename yours: `function onHit(n)`. |
| `loopSound needs a name to stop it by` | `loopSound("rain.ogg", 0.5, "rain")` - a loop has to be stoppable. |
| `every is called like this: every(time, function() ... end[, times][, "name"])` | Too many values, or the count after the name. |
| `unknown easing "bounce"` | See the [list of easings](../api/actions.md#easing-curves). |
| `'break' only works inside a for loop` | |
| `written for event format 1.0 - MineFunkin only runs 1.1 now; Song Select's update button converts it` | An old file. Press **Update old songs** in Song Select - it converts the whole song, the originals go into its `backup/` folder ([more](limits.md#old-songs-and-the-update-button)). |
| `written for event format 2.0, this MineFunkin runs 1.1 - a newer MineFunkin is needed` | The file is for a newer MineFunkin. |

### Taken names

These names already mean something, so you can't use them for your own variables, parameters or functions:

- **Words of the language:** `and`, `break`, `do`, `else`, `elseif`, `end`, `false`, `for`,
  `function`, `if`, `in`, `local`, `nil`, `not`, `or`, `return`, `then`, `true`, `while`, `repeat`,
  `until`, `goto`, `shared`, `format`, `event`, `params`
- **Built-in values:** `time`, `beat`, `step`, `bpm`, `pi`
- **Property groups:** `camera`, `hud`, `screen`, `flash`, `vignette`, `strum`, `strums`, `scroll`,
  `underlay`, `player`, `opponent`, `puppet`, `song`, `text`, `image`, `fx`, `shader`, `judgments`, `volume`,
  `window`, `popout`, `monitor`, `note`, `notes`
- **The [shortcuts](../api/shortcuts.md):** `flash`, `zoom`, `shake`, `focus`, `pose`, ...
- **Every [function](../api/functions.md) and [action](../api/actions.md):** `sin`, `snap`, `random`, `tween`,
  `after`, `log`, ...

Not taken: the names that came later - `note`, `notes`, `every`, `cancel`, `stopTween`, `loopSound`, `trigger`,
`call`, `callIn`, `preload`, `setHealth`, `addHealth`, `stopSound`, `soundVolume`, `randomInt`, `sub`, `find`,
`replace`, `trim`, `startsWith`, `endsWith`, `noteSlot`, `boyfriend`, `dad`, `bind`, `unbind`, `inspect`, `atPlace`. A variable, parameter or function of yours with
one of these names wins inside your file (see [Versions](limits.md#versions)).

`step`, `time` and `snap` are the ones *everybody* trips over at least once: call yours `n`, `dur` or `moveTime`
instead.

## Errors while it runs

These happen while the song plays. They switch that one script off for the rest of the run (the song itself goes on),
and land in the log with their line:

| Message | Cause |
|---|---|
| `there's no fighter 2 - fighters are 0 (you) and 1 (the opponent)` | `puppet[2]`: only 0 and 1 exist. |
| a lane that doesn't exist | `strum[4]`: lanes are 0-3. |
| text where a number is needed | e.g. `hud.angle = "big"`. |
| a choice property set to a word it doesn't take | e.g. `text[0].layer = "middle"`. |
| `too much work in one go (more than 50000 steps)` | More than 50,000 statements in one call - usually a loop that's far too big. |
| `this loop runs more than 10000 times` | A `for` loop with more than 10,000 rounds. |
| `functions call each other more than 64 deep` | A function that calls itself without stopping. |
| `too many 'after's waiting (more than 512)` | Usually an `after` (or `every`) scheduled every frame. |
| `there's no note 130` | `note[i]` past what's listed: loop up to `notes.count - 1`. |
| `events trigger each other more than 8 deep` | Two events that `trigger` each other in a circle. |
| `the event has no parameter 'x'` | `p.x` for a parameter the event doesn't declare. |

Writing something that isn't a number (say, a division by zero) into a number property is quietly ignored.

## Warnings in the log

These don't stop anything - the log just mentions them once, so you know:

| Warning | Meaning |
|---|---|
| a value kept inside its range | A number worked out while the song runs was outside what the property takes (`strums.alpha = 1.4`) and was set to the nearest allowed value. |
| two scripts set the same property every frame | Both write it in `onFrame`, so only the last one shows. Give each its own property (`x` and `wobbleX`) or its own part of the song. |
| a picture, sound or shader that isn't found | Check the file name and that it's in the song's folder. |
| `trigger - there's no event "X" in this song` | A `trigger("X")` for an event the song doesn't have - a typo (the warning says what was probably meant) or a song file that's missing. Nothing happens, the script goes on. |
| a pop-out or window change that isn't possible here | "Let songs use windows" switched off, Wayland, no compositor for see-through windows, or `window.transparent` on a system other than Windows. |

## Shaders

A `.fsh` that doesn't compile is switched off, and the graphics driver's message goes to the log:

```
[ERROR] Shader "broken.fsh" doesn't compile (lines count from the file's first line):
0:2(21): error: `undefinedThing' undeclared
```

`0:2` = line 2 of your file. Shader files are read once per song, so restart the song after a fix. A shader file
that isn't found is reported too. More in [Your own shaders](../guides/shaders.md).

`shader[n].status` tells a script what became of the file. The ones that need you:

| Status | Why | What to do |
|---|---|---|
| `"refused"` | The [shader check](../guides/shaders.md#which-shaders-run-the-check) said no - the log names the line. | Loop with `for` over a fixed number of rounds; no `while`, no `out` / `inout`. |
| `"broken"` | It doesn't compile. | The driver's message is in the log, as above. |
| `"too heavy"` | It took over 25 ms a frame and was switched off for the song. | Fewer picture reads, smaller loops. |
| `"disabled"` | The player switched song shaders off. | Nothing - make the song work without. |
| `"fight only"` | Target `"world"` / `"terrain"` outside a fight. | Use `"screen"` for practice. |

## Find out what your script is doing

When in doubt, ask it. `log` takes any values and writes them in one line:

```lua
function onHit(note)
    log("hit", note.lane, note.judgment, note.offset, "combo", player.combo)
end
```

Each event writes at most 200 log lines per run, so even a `log` in `onFrame` won't flood the file. And when you want to
know who set a property and why, [`inspect`](../api/shortcuts.md#inspect) tells you.
