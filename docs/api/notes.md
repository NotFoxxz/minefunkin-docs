---
icon: material/music-note-outline
---

# note[i]

Every note on its way to you, one by one. Make them ride in on a wave, fade as they come closer, spin, grow - the wildest
modchart effects live here.

!!! info "How to use it"
    Every frame the game lists the notes of your lanes that are on the screen (or about to be), in the order they
    come: `note[0]` is the next, up to `note[notes.count - 1]` (at most 128). Read `lane`, `time`, `distance`, ...;
    write `x`, `y`, `alpha`, `angle`, `scale`, `visible`.
    
    **Your values last one frame:** before every frame the game puts all notes back. Write them every frame in
    [onFrame](callbacks.md#onframe). A tween on a `note[i]` is an error when the file loads, for the same reason.
    
    The list only exists while a script of the song uses `note[...]` - songs without cost nothing.
    
    <p class="mf-like">Psych: <code>getPropertyFromGroup('notes', i, ...)</code>, <code>notes.length</code> · Kade: <code>notes</code> in <code>update</code></p>

## Example code

```lua
-- Swaying notes: each sways sideways by its distance, and fades in late.
function onFrame(dt)
    for i = 0, notes.count - 1 do
        note[i].x = 30 * sin(note[i].distance / 200 + note[i].lane)
        note[i].alpha = clamp(1 - (note[i].distance - 400) / 600, 0, 1)
    end
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [notes.count](#notes-count) | number, read | `0` | How many notes are listed this frame. |
| [note[i].lane](#note-lane) | number, read | `0` | Its lane: 0-3 (left, down, up, right). |
| [note[i].time](#note-time) | number, read | `0` | When it's to be hit, in song ms. |
| [note[i].beat](#note-beat) | number, read | `0` | The beat the note is on (beats follow the chart's tempo changes). Kade's `note.beat`. |
| [note[i].distance](#note-distance) | number, read | `0` | Ms until then - below 0 for a hold being played. |
| [note[i].hold](#note-hold) | number, read | `0` | A hold's length in ms (0 = a tap). |
| [note[i].held](#note-held) | switch, read | `false` | Whether it's a hold the player is holding right now. |
| [note[i].trap](#note-trap) | switch, read | `false` | Whether it's a Forced-Miss Note. |
| [note[i].id](#note-id) | number, read | `-1` | The note's number in the chart: the same note keeps it from frame to frame, while its … |
| [note[i].x](#note-x) | number | `0` | Moved to the right in pixels, with its hold. |
| [note[i].y](#note-y) | number | `0` | Moved down in pixels, with its hold. |
| [note[i].alpha](#note-alpha) | number | `1` | Its opacity. |
| [note[i].angle](#note-angle) | number | `0` | Turned clockwise, in degrees. |
| [note[i].scale](#note-scale) | number | `1` | Its size. |
| [note[i].visible](#note-visible) | switch | `true` | false = not drawn. It can still be hit. |

---

### notes.count { #notes-count }

<p class="mf-sig"><span class="mf-type">number</span> <code>notes.count</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

How many notes are listed this frame.

### note[i].lane { #note-lane }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].lane</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Its lane: 0-3 (left, down, up, right).

### note[i].time { #note-time }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].time</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">ms</span></p>

When it's to be hit, in song ms.

### note[i].beat { #note-beat }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].beat</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The beat the note is on (beats follow the chart's tempo changes). Kade's `note.beat`.

### note[i].distance { #note-distance }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].distance</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">ms</span></p>

Ms until then - below 0 for a hold being played.

### note[i].hold { #note-hold }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].hold</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">ms</span></p>

A hold's length in ms (0 = a tap).

### note[i].held { #note-held }

<p class="mf-sig"><span class="mf-type">switch</span> <code>note[i].held</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether it's a hold the player is holding right now.

### note[i].trap { #note-trap }

<p class="mf-sig"><span class="mf-type">switch</span> <code>note[i].trap</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether it's a Forced-Miss Note.

### note[i].id { #note-id }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].id</code> <span class="mf-eq">= <code>-1</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The note's number in the chart: the same note keeps it from frame to frame, while its place in the list moves
on. -1 = no note in this slot. [`noteSlot(id)`](functions.md#noteslot) finds where it is listed now.

```lua
-- Remember the next note and keep turning it, wherever it is in the list.
local spinning = -1
function onBeat(b)
    if notes.count > 0 then spinning = note[0].id end
end
function onFrame(dt)
    local i = noteSlot(spinning)
    if i >= 0 then note[i].angle = time / 2 end
end
```

### note[i].x { #note-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Moved to the right in pixels, with its hold.

### note[i].y { #note-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Moved down in pixels, with its hold.

### note[i].alpha { #note-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span></p>

Its opacity.

### note[i].angle { #note-angle }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].angle</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span><span class="mf-tag">kept at the song's end</span></p>

Turned clockwise, in degrees.

### note[i].scale { #note-scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>note[i].scale</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Its size.

### note[i].visible { #note-visible }

<p class="mf-sig"><span class="mf-type">switch</span> <code>note[i].visible</code> <span class="mf-eq">= <code>true</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

false = not drawn. It can still be hit.
