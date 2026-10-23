---
icon: material/volume-high
---

# Sounds and music

Sound is half the feeling of a song. A cymbal crash on the drop, rain under a slow part, thunder rolling every eight
beats, the opponent's voice cutting out for a moment of silence - your scripts can do all of that.

There are two kinds of sound to play with: the **song's own audio** (the instrumental and the vocal tracks), which you
can make louder or quieter, and **sounds of your own**, played from `.ogg` files in the song's folder.

## The song's audio

Three properties, each from 0 to 1, on top of whatever volume the player has set:
[`volume.inst`](../api/volume.md#volume-inst) (the instrumental), [`volume.player`](../api/volume.md#volume-player)
(your vocals - the ones a miss mutes) and [`volume.opponent`](../api/volume.md#volume-opponent).

```lua
-- The opponent's voice drops out for the drop, then comes back.
function onEvent(p)
    tween(volume.opponent, 0, beats(2))
    after(beats(16), function() tween(volume.opponent, 1, beats(1)) end)
end
```

The volumes go back to 1 when the song ends, so you can't leave anyone in silence.

## Sounds of your own

A sound is an `.ogg` file in the song's folder or its `events/` folder. Five calls are all you need:

| Call | What it does |
|---|---|
| [playSound](../api/actions.md#playsound)`("boom.ogg"[, volume])` | Plays it once. |
| `playSound("boom.ogg", 1, "boom")` | ... under the name `"boom"`, so you can fade or stop it later. |
| [loopSound](../api/actions.md#loopsound)`("rain.ogg", 0.6, "rain")` | Plays it over and over until it's stopped (a loop always needs a name). |
| [soundVolume](../api/shortcuts.md#soundvolume)`("rain", 0.2[, duration])` | Fades it to that volume (0-1). |
| [stopSound](../api/shortcuts.md#stopsound)`("rain")` | Stops it. |

```lua
format 1.1

event { name = "Storm" }

function onEvent(p)
    loopSound("rain.ogg", 0.6, "rain")         -- until stopped or the song ends
    after(beats(16), function()
        soundVolume("rain", 0, beats(4))       -- fades out over 4 beats ...
    end)
    after(beats(20), function()
        stopSound("rain")                      -- ... and stops
    end)
end

function onBeat(b)
    if b % 8 == 0 then playSound("thunder.ogg", 1, "thunder") end   -- a new one replaces the one still ringing
end
```

### How they behave

A few rules, so nothing surprises you:

- **One name, one sound:** a new sound under the same name stops the old one.
- **Volumes** are 0-1, on top of MineFunkin's own volume (the sound tray, numpad +/-).
- **Pausing** the song pauses the named sounds too; they go on with the song.
- **The song's end** stops the loops; the other sounds ring out. A restart or leaving the song stops them all.
- **Limits:** a sound may be at most 5 minutes long (for longer music, use the song's own audio), and at most 32 of a
  song's sounds play at once - so an accidental `playSound` in `onFrame` can't blow up anyone's speakers. The
  [event log](../help/troubleshooting.md#the-event-log) mentions it once when that happens, and names any sound file
  it can't find.
- Each sound file is read once per song and let go when the song closes.

## Recipes

### A tick on every "sick"

A tiny reward for hitting it perfectly:

```lua
function onHit(note)
    if note.judgment == "sick" then playSound("tick.ogg", 0.4) end
end
```

### Your own countdown voice

Tired of the standard 3-2-1? Record your own:

```lua
format 1.1

event { name = "Countdown Voice", category = "Song script" }

function onCountdown(n)
    playSound(n == 0 ? "go.ogg" : n == 1 ? "one.ogg" : n == 2 ? "two.ogg" : "three.ogg")
end
```

### The music drops out on a miss

Harsh, but it makes every miss count:

```lua
function onMiss(note)
    volume.inst = 0.3
    tween(volume.inst, 1, beats(1), "quadIn")
end
```

### Rain that follows the song's mood

The rain gets quieter as the song gets louder - with a little help from a `shared` variable:

```lua
format 1.1

event { name = "Rain", category = "Song script" }

shared hype = 0      -- set by another event when the song gets loud (0-1)

function onStart()
    loopSound("rain.ogg", 0.5, "rain")
end

function onBeat(b)
    soundVolume("rain", 0.5 - 0.4 * hype, beats(1))     -- quieter when the song gets loud
end
```

<p class="mf-like">Psych: <code>playSound</code>, <code>playMusic</code>, <code>stopSound</code>, <code>soundFadeIn</code> / <code>soundFadeOut</code>, <code>setSoundVolume</code>, <code>setProperty("vocals.volume", ...)</code></p>
