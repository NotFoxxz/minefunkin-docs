---
icon: material/script-outline
---

# Song scripts

Some things don't happen at one moment - they happen *all the time*. The camera popping on every hit. A combo counter.
The lanes swaying through a whole verse. For those you don't want to place an event on every note. You want a script
that just listens to the whole song.

If you know Psych Engine, those are its song scripts. MineFunkin doesn't need a separate kind of file for them, because
of one simple rule: **every callback of every loaded event runs for the whole song** - whether the chart ever places
that event or not. So a file with only `onBeat`, `onHit` or `onFrame` and no `onEvent` *is* a song script.

```lua
format 1.1
-- A song script: the camera pops on every hit, harder on a "sick".

event {
    name = "Hit Pop",
    category = "Song script",
    description = "No chart event needed - it runs for the whole song.",
}

function onHit(note)
    camera.bump += note.judgment == "sick" ? 0.02 : 0.008
end
```

Drop it into the song's folder and it's on from the very first note. It still needs its `event { name }` line,
though - that's how it shows up in the editor's footer and in the log.

## What a song script can listen to

| When | Callback |
|---|---|
| the song is set up, the countdown, the music starts, the end | [onStart](../api/callbacks.md#onstart), [onCountdown](../api/callbacks.md#oncountdown), [onSongStart](../api/callbacks.md#onsongstart), [onEnd](../api/callbacks.md#onend) |
| every beat, step, section (4 beats), frame | [onBeat](../api/callbacks.md#onbeat), [onStep](../api/callbacks.md#onstep), [onSection](../api/callbacks.md#onsection), [onFrame](../api/callbacks.md#onframe) |
| your hits and misses, the opponent's notes | [onHit](../api/callbacks.md#onhit), [onMiss](../api/callbacks.md#onmiss), [onOpponentHit](../api/callbacks.md#onopponenthit) |
| the lane keys | [onKeyPress](../api/callbacks.md#onkeypress), [onKeyRelease](../api/callbacks.md#onkeyrelease), [onGhostTap](../api/callbacks.md#onghosttap) |
| pause, resume, health running out | [onPause](../api/callbacks.md#onpause), [onResume](../api/callbacks.md#onresume), [onFail](../api/callbacks.md#onfail) |

A song can have as many as you like, side by side - say one for the [modchart](modcharts.md), one for the
[stage](stages.md), one for the [sounds](sound.md). Keeping them apart makes each one easier to find later.

## Song script or chart event?

| | Chart event | Song script |
|---|---|---|
| Starts | when the chart reaches it (`onEvent`) | at the song's start (`onStart`) |
| Good for | one moment, or switching a mode on and off | reacting to the whole song: hits, misses, beats |
| Example | [Beat Flash](tutorial.md) (switched on and off by events) | the showcase's Combo Meter |

Lots of events are a bit of both: `onEvent` switches a mode on or off, and `onBeat` / `onFrame` do the work while it's
on. Most of the [Event Showcase](showcase.md) is built like this:

```lua
params {
    on = bool { from = "value1", default = true, label = "On" },
}

local active = false

function onEvent(p)
    active = p.on
end

function onBeat(b)
    if not active then return end
    -- ... the effect, on every beat ...
end
```

## Talking to each other: `shared`

Every file keeps its variables to itself. When two files need to agree on something, use `shared`: a `shared`
variable is one single value for every file that declares it under the same name.

```lua
-- build_up.event
shared hype = 0

function onEvent(p)
    hype = 1
end
```

```lua
-- cam_sway.event (a song script)
shared hype = 0

function onFrame(dt)
    hud.angle = sin(time / 400) * 2 * (1 + hype)
end
```

Both say `shared hype`, so the moment Build Up sets it, Cam Sway sways harder. The first file that declares it decides
the starting value, and like everything else it goes back to that when the song starts over.

## Starting another event: `trigger` and `call`

Sometimes one event should set off another. A script can fire an event as if the chart had placed it right there, or
run a function another file defines:

```lua
format 1.1

event { name = "Drop Combo" }

function onEvent(p)
    trigger("Screen Shake", 0.6, 0.4)    -- runs that event's onEvent with value1 / value2
    call("spawnConfetti", 12)            -- every other file with a function spawnConfetti runs it
end
```

[trigger](../api/shortcuts.md#trigger) takes the event's name and its two values, just like the chart editor writes
them. [call](../api/shortcuts.md#call) runs the function of that name in every *other* event file of the song that
has one. Typo in the name? It's written to the event log once, and your script carries on.

## Practice or fight: `only` and `song.mode`

A song can be played at the Retro TV (practice, on your own) or at a Speaker (a fight, with people watching). Some
things only make sense in one of them - a camera swinging round looks great in a fight, but practice has no world
for it to swing through.

If a whole file belongs to fights only, say so in its header:

```lua
event {
    name = "Camera Swing",
    only = "fight",      -- runs only in fights (and their replays, and when someone watches from inside)
}
```

For smaller decisions inside a file, ask [`song.mode`](../api/song.md#song-mode). It's `"practice"`, `"fight"`,
`"replay"` or `"watch"`:

```lua
function onBeat(b)
    if song.mode == "practice" then return end
    camera.yaw = b % 2 == 0 ? 2 : -2
end
```

## Cutscenes: no countdown, no keys

Want the song to open with a little scene before anyone has to play?

```lua
function onStart()
    hud.countdown = false        -- no 3-2-1-GO (onCountdown still runs, so you can do your own)
end

function onEvent(p)              -- placed where the cutscene starts
    strums.input = false         -- the lane keys do nothing ...
    after(seconds(8), function() strums.input = true end)   -- ... until it's over
end
```

Leave the chart empty under a cutscene - notes that come by while the keys are off count as misses.

## A song that starts later (practice)

A difficulty can start somewhere in the middle of the song - great for a practice version of a long song's hard last
part. That's a key in the song file, not a script: [`"start"`](../songs/files.md). Your scripts still see the whole
song, though: everything before the start is run through quickly in the background, so effects and stages are exactly
where they'd be.

## Good to know

- Built-in events run first, then the song's own files in path order. If two scripts write the same property in the
  same frame, the later one wins. So give every effect that runs all the time its own property - the
  [Event Showcase](showcase.md) calls them "channels".
- While the game is paused or counting down, `onFrame`, `onBeat`, `onStep` and the timers wait. Only
  [onCountdown](../api/callbacks.md#oncountdown), [onPause](../api/callbacks.md#onpause) and
  [onResume](../api/callbacks.md#onresume) run then. Tweens follow the song's time, so they wait too.
- A song script that crashes while running is switched off for the rest of that run. What went wrong is in the
  [event log](../help/troubleshooting.md).
- Players can switch off *built-in* events in their options (Options › MineFunkin › Song effects) - but never your
  song's own files.
- An empty song script to start from is in [Templates](templates.md#song-script).
