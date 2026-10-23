---
icon: material/arrow-down-bold-outline
---

# strum[lane]

One of your four lanes: its receptor, its notes and its holds. This is where modcharts happen - move a lane, spin it,
fade it, change where its notes come from.

!!! info "How to use it"
    `strum[0]` = left, `strum[1]` = down, `strum[2]` = up, `strum[3]` = right - also in loops: `for i = 0, 3 do
    strum[i].alpha = 0.5 end`. Everything adds to the whole strumline's values ([strums](strums.md)).
    
    **Two offsets:** `x` / `y` and `wobbleX` / `wobbleY` add up. Let one effect own `x` (a sway, a slide) and another
    `wobble` (a jiggle on the beat) and they don't fight - setting a property stops a tween on it.
    
    Shortcuts: [hideLane / showLane](shortcuts.md#hidelane), [flipScroll](shortcuts.md#flipscroll),
    [resetLanes](shortcuts.md#resetlanes). Recipes: [Modcharts](../guides/modcharts.md).
    
    <p class="mf-like">Psych: <code>setPropertyFromGroup('playerStrums', i, 'x', ...)</code>, <code>noteTweenX</code> · Kade: <code>receptor</code>, <code>setActorX</code></p>

## Example code

```lua
-- Every lane sways on its own, a beat apart.
function onFrame(dt)
    for i = 0, 3 do
        strum[i].x = 20 * sin(time / 300 + i)
    end
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [strum[lane].x](#strum-x) | number | `0` | The lane moved to the right, in pixels. |
| [strum[lane].y](#strum-y) | number | `0` | The lane moved down, in pixels. |
| [strum[lane].wobbleX](#strum-wobblex) | number | `0` | A second offset to the right, added on top of `x` - for a second effect on the same lane. |
| [strum[lane].wobbleY](#strum-wobbley) | number | `0` | A second offset down, added on top of `y`. |
| [strum[lane].alpha](#strum-alpha) | number | `1` | The lane's opacity: receptor, notes, holds. |
| [strum[lane].noteAlpha](#strum-notealpha) | number | `1` | Only the lane's notes and holds - the receptor stays (for hide-near / hide-far modcharts). |
| [strum[lane].color](#strum-color) | colour | `#FFFFFF` | Multiplied onto the lane's receptor, notes and holds (#FFFFFF = their own colours). |
| [strum[lane].angle](#strum-angle) | number | `0` | The lane's rotation in degrees, clockwise: receptor and note heads. |
| [strum[lane].scale](#strum-scale) | number | `1` | The lane's size: receptor, notes, hold width. |
| [strum[lane].scroll](#strum-scroll) | choice | `"auto"` | The lane's own direction: `"auto"` (follows [`strums.scroll`](strums.md#strums-scroll)), … |
| [strum[lane].isDown](#strum-isdown) | switch, read | `false` | Whether the lane scrolls down right now. |
| [strum[lane].pressed](#strum-pressed) | switch, read | `false` | Whether the player holds the lane's key right now. |
| [strum[lane].homeX](#strum-homex) | number, read | `0` | Where the lane's receptor rests on the screen, in pixels from the left - before `x`, … |
| [strum[lane].homeY](#strum-homey) | number, read | `0` | Where the lane's receptor rests on the screen, in pixels from the top (it changes with … |
| [strum[lane].direction](#strum-direction) | number | `0` | The lane's way in, turned clockwise around the receptor, in degrees: 90 = in from the … |
| [strum[lane].speed](#strum-speed) | number | `1` | The lane's own scroll speed on top of the song's: 2 = its notes come twice as fast, 0.5 = … |
| [strum[lane].noteAngle](#strum-noteangle) | number | `0` | The lane's notes turned, in degrees, on top of `angle` - the receptor stays. |

---

### strum[lane].x { #strum-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].x</code> <span class="mf-eq">= <code>0</code></span></p>

The lane moved to the right, in pixels.

### strum[lane].y { #strum-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].y</code> <span class="mf-eq">= <code>0</code></span></p>

The lane moved down, in pixels.

### strum[lane].wobbleX { #strum-wobblex }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].wobbleX</code> <span class="mf-eq">= <code>0</code></span></p>

A second offset to the right, added on top of `x` - for a second effect on the same lane.

### strum[lane].wobbleY { #strum-wobbley }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].wobbleY</code> <span class="mf-eq">= <code>0</code></span></p>

A second offset down, added on top of `y`.

### strum[lane].alpha { #strum-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The lane's opacity: receptor, notes, holds.

### strum[lane].noteAlpha { #strum-notealpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].noteAlpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Only the lane's notes and holds - the receptor stays (for hide-near / hide-far modcharts).

### strum[lane].color { #strum-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>strum[lane].color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>

Multiplied onto the lane's receptor, notes and holds (#FFFFFF = their own colours).

### strum[lane].angle { #strum-angle }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].angle</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

The lane's rotation in degrees, clockwise: receptor and note heads.

### strum[lane].scale { #strum-scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].scale</code> <span class="mf-eq">= <code>1</code></span></p>

The lane's size: receptor, notes, hold width.

### strum[lane].scroll { #strum-scroll }

<p class="mf-sig"><span class="mf-type">choice</span> <code>strum[lane].scroll</code> <span class="mf-eq">= <code>"auto"</code></span></p>

The lane's own direction: `"auto"` (follows [`strums.scroll`](strums.md#strums-scroll)), `"up"`, `"down"`.

One of: `"auto"`, `"up"`, `"down"` ([what they do](choices.md#scroll-directions)).

### strum[lane].isDown { #strum-isdown }

<p class="mf-sig"><span class="mf-type">switch</span> <code>strum[lane].isDown</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether the lane scrolls down right now.

### strum[lane].pressed { #strum-pressed }

<p class="mf-sig"><span class="mf-type">switch</span> <code>strum[lane].pressed</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether the player holds the lane's key right now.

### strum[lane].homeX { #strum-homex }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].homeX</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Where the lane's receptor rests on the screen, in pixels from the left - before `x`, `wobbleX` and the
strumline's own offsets. Kade's `receptor.defaultX`.

### strum[lane].homeY { #strum-homey }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].homeY</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Where the lane's receptor rests on the screen, in pixels from the top (it changes with the scroll direction).
Kade's `receptor.defaultY`.

### strum[lane].direction { #strum-direction }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].direction</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

The lane's way in, turned clockwise around the receptor, in degrees: 90 = in from the side, 180 = from the other
end. The notes stay upright.
Psych's `direction` 90 is our 0.

### strum[lane].speed { #strum-speed }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].speed</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 20</span></p>

The lane's own scroll speed on top of the song's: 2 = its notes come twice as fast, 0.5 = half.

### strum[lane].noteAngle { #strum-noteangle }

<p class="mf-sig"><span class="mf-type">number</span> <code>strum[lane].noteAngle</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

The lane's notes turned, in degrees, on top of `angle` - the receptor stays.
