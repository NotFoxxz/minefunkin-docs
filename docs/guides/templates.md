---
icon: material/file-document-multiple-outline
---

# Templates

Nobody likes starting from a blank file. So here are some that already work: copy one into a text editor, save it
with `.event` at the end in the song's folder (or its `events/` folder), and change it into whatever you need. Each
one runs as it is - you can place it and press play before you've touched a line.

| I want ... | Template |
|---|---|
| an event I place in the chart, that does one thing | [One moment](#one-moment) |
| an event that switches an effect on and off | [On and off](#on-and-off) |
| something that runs for the whole song, no chart event | [Song script](#song-script) |
| lanes and notes that move | [Modchart](#modchart) |
| pictures around the fighters | [Stage](#stage) |
| every callback, to see what's there | [Everything](#everything) |

## One moment

The simplest kind: you place it in the chart, something happens right there.

```lua
format 1.1
-- What this event does, in one line.

event {
    name = "My Event",
    color = #7C6BFF,
    category = "Custom",
    description = "Shown in the chart editor.",
}

params {
    strength = number { from = "value1", default = 1, min = 0, max = 3, step = 0.1, label = "Strength" },
}

function onEvent(p)
    flash(#FFFFFF, beats(0.5))
    camera.bump += 0.03 * p.strength
end
```

## On and off

For effects that last a while. Place it once with *On* ticked where the effect starts, and once more with it
unticked where it stops - the code in `onBeat` runs in between.

```lua
format 1.1
-- An effect that runs from one chart event to the next.

event {
    name = "My Effect",
    category = "Custom",
    description = "On: the effect runs. Off: it stops.",
}

params {
    on = bool { from = "value1", default = true, label = "On" },
}

local active = false

function onEvent(p)
    active = p.on

    if not active then
        resetLanes(beats(1))      -- put back what the effect moved
    end
end

function onBeat(b)
    if not active then return end
    -- the effect, on every beat
end
```

## Song script

No chart event needed at all. Every callback of every event file in the song runs from start to end, so this one
simply listens - to every hit, every miss, whatever you put in.

```lua
format 1.1
-- Runs for the whole song.

event {
    name = "My Song Script",
    category = "Song script",
    description = "No chart event needed.",
}

function onStart()
    -- before the countdown
end

function onHit(note)
    -- every note you hit
end

function onMiss(note)
    -- every miss
end
```

## Modchart

All the lane movement of a song in one file, so you don't have to hunt for it later. This one makes the lanes wobble
between steps 64 and 128, then puts them back.

```lua
format 1.1
-- The song's modchart: everything that moves the lanes, in one place.

event {
    name = "Modchart",
    category = "Song script",
    description = "Runs for the whole song.",
}

function onFrame(dt)
    -- moves all the time; work it out from time or beat
    if step >= 64 and step < 128 then
        for lane = 0, 3 do
            strum[lane].wobbleX = 12 * sin(time / 300 + lane)
        end
    end
end

function onStep(n)
    if n == 128 then resetLanes(beats(1)) end
end
```

Lots more ideas in the [Modcharts](modcharts.md) guide.

## Stage

A background behind the fighters. Swap the file name for your own picture.

```lua
format 1.1
-- The song's stage pictures.

event {
    name = "Stage",
    category = "Song script",
    description = "A background behind the fighters.",
}

function onStart()
    preload("stage/background.png")

    image[0].file = "stage/background.png"
    image[0].layer = "stage"      -- behind the fighters
    image[0].width = 1.5
    image[0].height = 1.5
    image[0].follow = 1           -- moves with the fight camera
end
```

Animated sprites, layers and more in [Stages and sprites](stages.md).

## Everything

Every callback the game has, all empty. Handy when you want to see what's there - delete the ones you don't need.

```lua
format 1.1
-- Every callback the game has.

event {
    name = "Everything",
    category = "Custom",
}

function onStart() end            -- the song is set up, before the countdown
function onCountdown(n) end       -- 3, 2, 1, then 0 for "go"
function onSongStart() end        -- the music starts
function onEvent(p) end           -- the chart reaches this event
function onBeat(b) end            -- every beat
function onStep(n) end            -- every step (four per beat)
function onSection(n) end         -- every 4 beats
function onFrame(dt) end          -- every frame, dt = ms since the last one
function onHit(note) end          -- you hit a note
function onMiss(note) end         -- you missed
function onOpponentHit(note) end  -- the opponent plays a note
function onKeyPress(lane) end     -- a lane key goes down
function onKeyRelease(lane) end   -- a lane key comes up
function onGhostTap(lane) end     -- a press with nothing to hit
function onPause() end            -- the song is paused
function onResume() end           -- it goes on
function onFail() end             -- your health ran out (fights)
function onEnd() end              -- the song was played to its end
```

What each one gets and when exactly it runs: [Callbacks](../api/callbacks.md).
