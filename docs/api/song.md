---
icon: material/music-circle-outline
---

# song

What kind of run this is (practice, a fight, a replay, someone watching), how far the song is, and who's singing right now.
Read only.

!!! info "How to use it"
    Read only. For a script that should only run in some modes there's also the `only` key of the
    [event header](language.md#the-event-header): `only = "fight"` / `only = "practice"`.
    
    Time, beat, step and BPM are the [built-in values](functions.md#built-in-values) `time`, `beat`, `step`, `bpm`.
    
    <p class="mf-like">Psych: <code>songLength</code>, <code>getSongPosition()</code>, <code>mustHitSection</code>, <code>isStoryMode</code> · Kade: <code>songPos</code></p>

## Example code

```lua
-- The camera moves only in fights; practice stays calm.
function onBeat(b)
    if song.mode == "fight" then
        camera.yaw = b % 2 == 0 ? 2 : -2
    end
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [song.fight](#song-fight) | switch, read | `false` | Whether this is a fight - your own, or one you watch from inside. |
| [song.mode](#song-mode) | choice, read | `"practice"` | `"practice"`, `"fight"`, `"replay"` (a replay of a fight) or `"watch"` (watching a fight … |
| [song.practice](#song-practice) | switch, read | `true` | Whether this is practice (the Retro TV). |
| [song.replay](#song-replay) | switch, read | `false` | Whether this is a replay. |
| [song.length](#song-length) | number, read | `0` | The song's length in ms. |
| [song.progress](#song-progress) | number, read | `0` | How far it is: 0 at the start, 1 at the end. |
| [song.singer](#song-singer) | text, read | `"none"` | Who sings right now, from the chart's notes within a beat: `"player"`, `"opponent"`, … |
| [song.side](#song-side) | text, read | `"player"` | The chart side YOU play: `"player"` (the Boyfriend part) or `"opponent"`. `boyfriend` / … |
| [song.canHeal](#song-canheal) | switch, read | `false` | Whether [setHealth / addHealth](shortcuts.md#sethealth) do something here: only in a … |

---

### song.fight { #song-fight }

<p class="mf-sig"><span class="mf-type">switch</span> <code>song.fight</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether this is a fight - your own, or one you watch from inside.

### song.mode { #song-mode }

<p class="mf-sig"><span class="mf-type">choice</span> <code>song.mode</code> <span class="mf-eq">= <code>"practice"</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

`"practice"`, `"fight"`, `"replay"` (a replay of a fight) or `"watch"` (watching a fight from inside).

One of: `"practice"`, `"fight"`, `"replay"`, `"watch"`.

### song.practice { #song-practice }

<p class="mf-sig"><span class="mf-type">switch</span> <code>song.practice</code> <span class="mf-eq">= <code>true</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether this is practice (the Retro TV).

### song.replay { #song-replay }

<p class="mf-sig"><span class="mf-type">switch</span> <code>song.replay</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether this is a replay.

### song.length { #song-length }

<p class="mf-sig"><span class="mf-type">number</span> <code>song.length</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">ms</span></p>

The song's length in ms.

### song.progress { #song-progress }

<p class="mf-sig"><span class="mf-type">number</span> <code>song.progress</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

How far it is: 0 at the start, 1 at the end.

### song.singer { #song-singer }

<p class="mf-sig"><span class="mf-type">text</span> <code>song.singer</code> <span class="mf-eq">= <code>"none"</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Who sings right now, from the chart's notes within a beat: `"player"`, `"opponent"`, `"both"` or `"none"`.

### song.side { #song-side }

<p class="mf-sig"><span class="mf-type">text</span> <code>song.side</code> <span class="mf-eq">= <code>"player"</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The chart side YOU play: `"player"` (the Boyfriend part) or `"opponent"`. `boyfriend` / `dad` follow it.

### song.canHeal { #song-canheal }

<p class="mf-sig"><span class="mf-type">switch</span> <code>song.canHeal</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether [setHealth / addHealth](shortcuts.md#sethealth) do something here: only in a fight you play.
