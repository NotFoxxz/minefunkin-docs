---
icon: material/television-shimmer
---

# screen, flash, vignette

Colours over the whole picture: a flash that fades by itself, a colour that stays (a cut to black, a red tint), and a dark
vignette around the edges. Cheap, quick, and great for big moments.

!!! info "How to use it"
    Always there. All three are drawn over the playfield and the world, under the texts and pictures on the
    [`"top"` layer](choices.md#layers).
    
    - `flash` is meant to fade: set its alpha high, tween it to 0.
    - `screen` stays until you change it - fades to black, a white-out, a tint.
    - `vignette` darkens (or tints) the edges.
    
    Shortcuts: [flash](shortcuts.md#flash), [fadeOut / fadeIn](shortcuts.md#fadeout).
    
    <p class="mf-like">Psych: <code>cameraFlash</code>, <code>cameraFade</code> · Kade: <code>flashCamera</code></p>

## Example code

```lua
-- A red flash on the drop, then a slow fade to black over the last bar.
flash.color = #FF3040
flash.alpha = 0.8
tween(flash.alpha, 0, beats(1))

after(beats(28), function()
    screen.color = #000000
    tween(screen.alpha, 1, beats(4))
end)
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [screen.color](#screen-color) | colour | `#FFFFFF` | The colour that stays over everything. |
| [screen.alpha](#screen-alpha) | number | `0` | Its opacity: 0 = not there, 1 = the whole picture in that colour. |
| [flash.color](#flash-color) | colour | `#FFFFFF` | The flash's colour. |
| [flash.alpha](#flash-alpha) | number | `0` | The flash's opacity. Set it high and tween it to 0 - the game doesn't fade it by itself. |
| [vignette.color](#vignette-color) | colour | `#000000` | The colour of the edges. |
| [vignette.alpha](#vignette-alpha) | number | `0` | How strong the edges are: 0 = none, 1 = deep. |
| [screen.width](#screen-width) | number, read | `0` | The playfield's width in pixels - the canvas the HUD and texts are laid out on, not the … |
| [screen.height](#screen-height) | number, read | `0` | The playfield's height in pixels: 480 for a 16:9 window or a narrower one, less for a … |

---

### screen.color { #screen-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>screen.color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

The colour that stays over everything.

### screen.alpha { #screen-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>screen.alpha</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span></p>

Its opacity: 0 = not there, 1 = the whole picture in that colour.

!!! info "Note"
    The song's end keeps it - a song can end on black. The results are drawn over it.

### flash.color { #flash-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>flash.color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

The flash's colour.

### flash.alpha { #flash-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>flash.alpha</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span></p>

The flash's opacity. Set it high and tween it to 0 - the game doesn't fade it by itself.

### vignette.color { #vignette-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>vignette.color</code> <span class="mf-eq">= <code>#000000</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

The colour of the edges.

### vignette.alpha { #vignette-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>vignette.alpha</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

How strong the edges are: 0 = none, 1 = deep.

### screen.width { #screen-width }

<p class="mf-sig"><span class="mf-type">number</span> <code>screen.width</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The playfield's width in pixels - the canvas the HUD and texts are laid out on, not the window's pixels: 853 for a
16:9 window or a wider one, less for a narrower window (it keeps its height then, so the notes don't shrink).

### screen.height { #screen-height }

<p class="mf-sig"><span class="mf-type">number</span> <code>screen.height</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The playfield's height in pixels: 480 for a 16:9 window or a narrower one, less for a wider window.
