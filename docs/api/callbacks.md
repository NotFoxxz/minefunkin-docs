---
icon: material/bell-ring-outline
---

# Callbacks

Callbacks are how your script hears about the song. They're functions **the game calls** when something happens: a
beat, a hit, a miss, the chart reaching your event. You just write the ones you care about and leave out the rest -
a file can have any mix of them.

```lua
function onBeat(b)
    camera.bump += 0.02      -- runs on every beat of the song
end
```

| When | Callbacks |
|---|---|
| The song | [onStart](#onstart) · [onCountdown](#oncountdown) · [onSongStart](#onsongstart) · [onEvent](#onevent) · [onEnd](#onend) · [onFail](#onfail) |
| The music's time | [onBeat](#onbeat) · [onStep](#onstep) · [onSection](#onsection) · [onFrame](#onframe) |
| Notes | [onHit](#onhit) · [onMiss](#onmiss) · [onOpponentHit](#onopponenthit) |
| Keys | [onKeyPress](#onkeypress) · [onKeyRelease](#onkeyrelease) · [onGhostTap](#onghosttap) |
| Pause | [onPause](#onpause) · [onResume](#onresume) |

!!! info "Every callback runs for every loaded event"
    `onBeat` in your file runs on every beat - whether or not the chart has used your event yet. That's why
    a file with only `onBeat` / `onHit` and no `onEvent` works as a [song script](../guides/song-scripts.md), and why an
    event that switches a mode on checks its own `active` variable first.

**Parameters are optional and you name them yourself:** `function onBeat()` and `function onBeat(b)` both
work. Just don't call them `beat`, `step` or `time` - those are [built-in values](functions.md#built-in-values),
so the name is taken (`function onBeat(b)` still reads the current beat as `beat`).

---

## The song

### onStart

<p class="mf-sig"><code>function onStart()</code></p>

The song is set up, before the countdown - and again on every restart. Set up your pictures, texts and
starting values here.

```lua
function onStart()
    strums.alpha = 0
    tween(strums.alpha, 1, beats(4))     -- the lanes fade in during the countdown
end
```

<p class="mf-like">Psych: <code>onCreate</code> · Kade: <code>start(song)</code></p>

### onCountdown

<p class="mf-sig"><code>function onCountdown(n)</code></p>

Each step of the 3-2-1-Go countdown. **Gets** `n`: `3`, `2`, `1`, then `0` for "go".

```lua
function onCountdown(n)
    text[3].value = n == 0 ? "GO!" : str(n)
    text[3].alpha = 1
    tween(text[3].alpha, 0, beats(0.9))
end
```

<p class="mf-like">Psych: <code>onCountdownTick(counter)</code></p>

### onSongStart

<p class="mf-sig"><code>function onSongStart()</code></p>

The music starts, right after the countdown.

```lua
function onSongStart()
    showStrums(beats(1))     -- the lanes come in with the music
end
```

<p class="mf-like">Psych: <code>onSongStart</code></p>

### onEvent

<p class="mf-sig"><code>function onEvent(p)</code></p>

The song reaches a chart event of this file's name (or alias). **Gets** `p`: the event's
[parameters](parameters.md) by name (`p.speed`, `p.tint`, ...) plus the raw `p.value1` and `p.value2`.

```lua
params {
    tint = color { from = "value1", default = #FFFFFF, label = "Colour" },
}

function onEvent(p)
    flash(p.tint, beats(1))
end
```

<p class="mf-like">Psych: <code>onEvent(name, value1, value2)</code> in <code>custom_events/</code></p>

### onEnd

<p class="mf-sig"><code>function onEnd()</code></p>

The song was played to its end. Not when it was failed, left, or a fight was decided early.

```lua
function onEnd()
    text[0].value = "CLEAR!"
end
```

<p class="mf-like">Psych: <code>onEndSong</code></p>

### onFail

<p class="mf-sig"><code>function onFail()</code></p>

Your health ran out - just before the song ends as failed. Only where there's health: in fights (practice
has none).

```lua
function onFail()
    fadeOut(#000000, beats(1))
end
```

<p class="mf-like">Psych: <code>onGameOver</code></p>

---

## The music's time

Beats and steps ride the same beat as the camera bop, so everything on the beat lands together. A slow
frame never skips one: if the game hitches over a few steps, each still gets its `onStep` (and `onBeat`,
`onSection`) in order - you can hang a whole song's timeline on step numbers.

### onBeat

<p class="mf-sig"><code>function onBeat(b)</code></p>

A new beat starts. **Gets** `b`: the beat number (0, 1, 2, ...).

```lua
function onBeat(b)
    if b % 4 == 0 then camera.bump += 0.03 end   -- a pop on the first beat of every bar
end
```

<p class="mf-like">Psych: <code>onBeatHit</code> + <code>curBeat</code> · Kade: <code>beatHit(beat)</code></p>

### onStep

<p class="mf-sig"><code>function onStep(n)</code></p>

A new step starts - a sixteenth note, four per beat. **Gets** `n`: the step number.

```lua
function onStep(n)
    if n == 256 then flash() end      -- an exact moment of the song, by step
end
```

<p class="mf-like">Psych: <code>onStepHit</code> + <code>curStep</code> · Kade: <code>stepHit(step)</code></p>

### onSection

<p class="mf-sig"><code>function onSection(n)</code></p>

Every 4 beats (beats 0, 4, 8, ...), right after that beat's `onBeat`. **Gets** `n`: the section number
(0, 1, 2, ...).

```lua
function onSection(n)
    zoom(n % 2 == 0 ? 1.05 : 1, beats(1))   -- in and out, bar by bar
end
```

<p class="mf-like">Psych: <code>onSectionHit</code> + <code>curSection</code></p>

### onFrame

<p class="mf-sig"><code>function onFrame(dt)</code></p>

Every rendered frame. **Gets** `dt`: milliseconds since the last frame. Use it for anything that moves all
the time - work positions out from `time` (or `beat`), so it looks the same at any frame rate.

```lua
function onFrame(dt)
    hud.angle = sin(time / 500) * 1.5      -- a slow sway
end
```

<p class="mf-like">Psych: <code>onUpdate(elapsed)</code> · Kade: <code>update(elapsed)</code></p>

---

## Notes

The three note callbacks get the **note**:

| Field | |
|---|---|
| `note.lane` | 0-3: left, down, up, right |
| `note.judgment` | `"sick"`, `"good"`, `"bad"`, `"shit"` or `"miss"` |
| `note.offset` | how early (negative) or late it was hit, in ms; 0 for misses and the opponent |
| `note.hold` | whether it's a hold note |

!!! tip "`note` or `n`?"
    Inside `function onHit(note)` the name `note` is that one note - the [notes on their way](notes.md)
    (`note[0]`, `note[1]`, ...) are out of reach there. If you need both, call it `n`: `function onHit(n)`.

### onHit

<p class="mf-sig"><code>function onHit(note)</code></p>

You hit a note.

```lua
function onHit(note)
    if note.hold then return end
    strum[note.lane].scale = 1.15
    tween(strum[note.lane].scale, 1, beats(0.5), "backOut")
end
```

<p class="mf-like">Psych: <code>goodNoteHit</code> · Kade: <code>playerOneSing</code></p>

### onMiss

<p class="mf-sig"><code>function onMiss(note)</code></p>

You missed: a note went by, you pressed with nothing to hit (ghost tapping off), or let go of a hold too
early.

```lua
function onMiss(note)
    flash(#FF3040, beats(0.5))
end
```

<p class="mf-like">Psych: <code>noteMiss</code> + <code>noteMissPress</code> · Kade: <code>playerOneMiss</code></p>

### onOpponentHit

<p class="mf-sig"><code>function onOpponentHit(note)</code></p>

The opponent's side plays a note - the chart's opponent notes as written, in every mode.

```lua
function onOpponentHit(note)
    strum[note.lane].wobbleY = -8           -- your lane twitches when the opponent sings it
    tween(strum[note.lane].wobbleY, 0, beats(0.5), "elasticOut")
end
```

<p class="mf-like">Psych: <code>opponentNoteHit</code> · Kade: <code>playerTwoSing</code></p>

---

## Keys

### onKeyPress

<p class="mf-sig"><code>function onKeyPress(lane)</code></p>

One of your lane keys goes down - note or not. **Gets** `lane`: 0-3.

```lua
function onKeyPress(lane)
    strum[lane].scale = 0.9
end
```

<p class="mf-like">Psych: <code>onKeyPress(key)</code> · Kade: <code>keyPressed(key)</code></p>

### onKeyRelease

<p class="mf-sig"><code>function onKeyRelease(lane)</code></p>

One of your lane keys comes up. **Gets** `lane`: 0-3.

```lua
function onKeyRelease(lane)
    tween(strum[lane].scale, 1, beats(0.25))
end
```

<p class="mf-like">Psych: <code>onKeyRelease(key)</code></p>

### onGhostTap

<p class="mf-sig"><code>function onGhostTap(lane)</code></p>

A press with no note to hit. With ghost tapping off, `onMiss` comes too. **Gets** `lane`: 0-3.

```lua
function onGhostTap(lane)
    strum[lane].wobbleX = 6
    tween(strum[lane].wobbleX, 0, beats(0.5), "elasticOut")
end
```

<p class="mf-like">Psych: <code>onGhostTap(key)</code></p>

---

## Pause

While the game is paused or counting down, only `onCountdown`, `onPause` and `onResume` are called. Tweens
and `after` / `every` timers run on the song's time, so they wait while it's paused.

### onPause

<p class="mf-sig"><code>function onPause()</code></p>

The song is paused.

<p class="mf-like">Psych: <code>onPause</code></p>

### onResume

<p class="mf-sig"><code>function onResume()</code></p>

The song goes on after a pause.

<p class="mf-like">Psych: <code>onResume</code></p>

---

## In what order

Within one frame, for every loaded event - the built-ins first, then the song's own files in file-name
order: the steps, beats and sections that started, then `onFrame`. After that come the waiting `after` /
`every` functions whose time has come. Two scripts writing the same property in the same frame: the later
one wins (and the [event log](../help/troubleshooting.md#the-event-log) names both).

## Your own functions

You can write your own functions next to the callbacks. They take parameters, `return` a value, and are
called like any function:

```lua
local function pop(amount)
    camera.bump += amount
end

function onHit(note)
    pop(note.judgment == "sick" ? 0.03 : 0.01)
end
```

More on that in [Functions and values](functions.md#your-own-functions).
