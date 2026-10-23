---
icon: material/arrow-collapse-down
---

# strums

Your whole strumline at once: the four lanes, their scroll direction, the scroll speed - and whether your keys play at all
(handy for cutscenes).

!!! info "How to use it"
    Always there. `strums.*` is the whole strumline, [`strum[lane]`](strum.md) one lane - both add up: a lane's `x`
    comes on top of `strums.x`.
    
    Shortcuts: [hideStrums / showStrums](shortcuts.md#hidestrums), [moveStrums](shortcuts.md#movestrums),
    [flipScroll](shortcuts.md#flipscroll), [setScroll](shortcuts.md#setscroll). Scroll speed changes:
    [scrollTo / scrollBy](actions.md#scrollto).
    
    <p class="mf-like">Psych: <code>setPropertyFromGroup('strumLineNotes', ...)</code>, <code>downscroll</code> · Kade: <code>strumLine</code>, <code>setHudPosition</code></p>

## Example code

```lua
-- Middle of the song: the strumline drifts up, the opponent's lanes fade (practice).
tween(strums.y, -60, beats(4), "sineInOut")
tween(strums.opponentAlpha, 0, beats(2))
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [strums.scroll](#strums-scroll) | choice | `"auto"` | Every lane's direction: `"auto"` (the player's own setting), `"up"`, `"down"`. A lane's … |
| [strums.x](#strums-x) | number | `0` | The whole strumline moved to the right, in pixels. The strum background follows. |
| [strums.y](#strums-y) | number | `0` | The whole strumline moved down, in pixels. |
| [strums.alpha](#strums-alpha) | number | `1` | The whole strumline's opacity: receptors, notes, holds. |
| [strums.opponentAlpha](#strums-opponentalpha) | number | `1` | The opponent's receptors beside yours (practice; a fight shows only yours). |
| [strums.bump](#strums-bump) | number | `1` | How much the beat bump zooms the lanes: 1 = like the rest of the HUD, 0 = the lanes stay … |
| [strums.input](#strums-input) | switch | `true` | Whether your lane keys play. false = presses are ignored and held keys let go at once - … |
| [scroll.style](#scroll-style) | choice | `"classic"` | How a scroll speed change is drawn: `"classic"` (the speed is eased live, notes on screen … |
| [scroll.speed](#scroll-speed) | number, read | `1` | The scroll speed multiplier right now. |
| [strums.spacing](#strums-spacing) | number, read | `67` | The distance between two lanes in pixels: `strum[0].x = 3 * strums.spacing` puts lane 0 … |

---

### strums.scroll { #strums-scroll }

<p class="mf-sig"><span class="mf-type">choice</span> <code>strums.scroll</code> <span class="mf-eq">= <code>"auto"</code></span></p>

Every lane's direction: `"auto"` (the player's own setting), `"up"`, `"down"`. A lane's own
[`strum[lane].scroll`](strum.md#strum-scroll) wins over it.

One of: `"auto"`, `"up"`, `"down"` ([what they do](choices.md#scroll-directions)).

### strums.x { #strums-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>strums.x</code> <span class="mf-eq">= <code>0</code></span></p>

The whole strumline moved to the right, in pixels. The strum background follows.

### strums.y { #strums-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>strums.y</code> <span class="mf-eq">= <code>0</code></span></p>

The whole strumline moved down, in pixels.

### strums.alpha { #strums-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>strums.alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The whole strumline's opacity: receptors, notes, holds.

### strums.opponentAlpha { #strums-opponentalpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>strums.opponentAlpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The opponent's receptors beside yours (practice; a fight shows only yours).

### strums.bump { #strums-bump }

<p class="mf-sig"><span class="mf-type">number</span> <code>strums.bump</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

How much the beat bump zooms the lanes: 1 = like the rest of the HUD, 0 = the lanes stay still while the rest
bumps (for modcharts that move the lanes themselves).

### strums.input { #strums-input }

<p class="mf-sig"><span class="mf-type">switch</span> <code>strums.input</code> <span class="mf-eq">= <code>true</code></span></p>

Whether your lane keys play. false = presses are ignored and held keys let go at once - for cutscenes. Notes
that come meanwhile are missed as usual, so leave the chart empty there.

!!! info "Note"
    Replays play the recorded keys; a recording made with input off has none there anyway.

### scroll.style { #scroll-style }

<p class="mf-sig"><span class="mf-type">choice</span> <code>scroll.style</code> <span class="mf-eq">= <code>"classic"</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

How a scroll speed change is drawn: `"classic"` (the speed is eased live, notes on screen speed up with it) or
`"modern"` (notes are placed on the planned speed curve - see [scrollTo](actions.md#scrollto)).

One of: `"classic"`, `"modern"`.

### scroll.speed { #scroll-speed }

<p class="mf-sig"><span class="mf-type">number</span> <code>scroll.speed</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The scroll speed multiplier right now.

### strums.spacing { #strums-spacing }

<p class="mf-sig"><span class="mf-type">number</span> <code>strums.spacing</code> <span class="mf-eq">= <code>67</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The distance between two lanes in pixels: `strum[0].x = 3 * strums.spacing` puts lane 0 where lane 3 is.
