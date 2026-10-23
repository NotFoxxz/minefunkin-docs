---
icon: material/auto-fix
---

# fx

Built-in effects over the picture: colour, blur, pixels, waves, glitches, bloom. No shader writing needed - set a number and
it's there.

!!! info "How to use it"
    `fx` is always there. Every effect is off at its default and nothing is computed while all of them are. They run
    while the song plays, never on the pause menu or the results. `target` says what they cover: everything, only the
    world, or the world without the fighters (the [effect targets](choices.md#effect-targets)).
    
    The player's "Fewer flashes" option (Options › MineFunkin › Accessibility) keeps `invert` and `glitch` at 0.3 and
    `brightness` at 1.3 at most.
    
    Put them back with [`resetFx([duration])`](actions.md#resetfx). Your own GLSL: [shader](shader.md). The whole
    picture: [Effects](../guides/effects.md).

## Example code

```lua
-- The drop: the world goes grey and grainy, the notes stay sharp.
function onEvent(p)
    fx.target = "world"
    tween(fx.grayscale, 1, beats(1))
    fx.grain = 0.4
    after(beats(16), function() resetFx(beats(2)) end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [fx.grayscale](#fx-grayscale) | number | `0` | 0-1: colour drained. |
| [fx.invert](#fx-invert) | number | `0` | 0-1: the colours turned inside out (0.5 = flat grey). |
| [fx.sepia](#fx-sepia) | number | `0` | 0-1: old photo. |
| [fx.hue](#fx-hue) | number | `0` | Degrees around the colour wheel. |
| [fx.saturation](#fx-saturation) | number | `1` | 0 = grey, 2 = twice as colourful. |
| [fx.contrast](#fx-contrast) | number | `1` | 0 = flat grey, 2 = hard. |
| [fx.brightness](#fx-brightness) | number | `1` | 0 = black, 2 = twice as bright. |
| [fx.chromatic](#fx-chromatic) | number | `0` | Red and blue pulled apart sideways, in pixels. |
| [fx.blur](#fx-blur) | number | `0` | Blur radius in pixels. |
| [fx.pixelate](#fx-pixelate) | number | `0` | Block size in pixels (from 2 up). |
| [fx.wave](#fx-wave) | number | `0` | The picture waves sideways, in pixels. |
| [fx.glitch](#fx-glitch) | number | `0` | 0-1: bands jump sideways and the colours split, flickering. |
| [fx.scanlines](#fx-scanlines) | number | `0` | 0-1: CRT lines. |
| [fx.grain](#fx-grain) | number | `0` | 0-1: film noise. |
| [fx.bulge](#fx-bulge) | number | `0` | Fisheye: positive bulges the middle out, negative pinches it. Around ±0.5 is a lot. |
| [fx.bloom](#fx-bloom) | number | `0` | 0-1 and up: bright parts glow. |
| [fx.target](#fx-target) | choice | `"screen"` | What they cover: `"screen"` (everything), `"world"` (the world only - the notes and HUD … |

---

### fx.grayscale { #fx-grayscale }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.grayscale</code> <span class="mf-eq">= <code>0</code></span></p>

0-1: colour drained.

### fx.invert { #fx-invert }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.invert</code> <span class="mf-eq">= <code>0</code></span></p>

0-1: the colours turned inside out (0.5 = flat grey).

### fx.sepia { #fx-sepia }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.sepia</code> <span class="mf-eq">= <code>0</code></span></p>

0-1: old photo.

### fx.hue { #fx-hue }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.hue</code> <span class="mf-eq">= <code>0</code></span></p>

Degrees around the colour wheel.

### fx.saturation { #fx-saturation }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.saturation</code> <span class="mf-eq">= <code>1</code></span></p>

0 = grey, 2 = twice as colourful.

### fx.contrast { #fx-contrast }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.contrast</code> <span class="mf-eq">= <code>1</code></span></p>

0 = flat grey, 2 = hard.

### fx.brightness { #fx-brightness }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.brightness</code> <span class="mf-eq">= <code>1</code></span></p>

0 = black, 2 = twice as bright.

### fx.chromatic { #fx-chromatic }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.chromatic</code> <span class="mf-eq">= <code>0</code></span></p>

Red and blue pulled apart sideways, in pixels.

### fx.blur { #fx-blur }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.blur</code> <span class="mf-eq">= <code>0</code></span></p>

Blur radius in pixels.

### fx.pixelate { #fx-pixelate }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.pixelate</code> <span class="mf-eq">= <code>0</code></span></p>

Block size in pixels (from 2 up).

### fx.wave { #fx-wave }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.wave</code> <span class="mf-eq">= <code>0</code></span></p>

The picture waves sideways, in pixels.

### fx.glitch { #fx-glitch }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.glitch</code> <span class="mf-eq">= <code>0</code></span></p>

0-1: bands jump sideways and the colours split, flickering.

### fx.scanlines { #fx-scanlines }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.scanlines</code> <span class="mf-eq">= <code>0</code></span></p>

0-1: CRT lines.

### fx.grain { #fx-grain }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.grain</code> <span class="mf-eq">= <code>0</code></span></p>

0-1: film noise.

### fx.bulge { #fx-bulge }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.bulge</code> <span class="mf-eq">= <code>0</code></span></p>

Fisheye: positive bulges the middle out, negative pinches it. Around ±0.5 is a lot.

### fx.bloom { #fx-bloom }

<p class="mf-sig"><span class="mf-type">number</span> <code>fx.bloom</code> <span class="mf-eq">= <code>0</code></span></p>

0-1 and up: bright parts glow.

### fx.target { #fx-target }

<p class="mf-sig"><span class="mf-type">choice</span> <code>fx.target</code> <span class="mf-eq">= <code>"screen"</code></span></p>

What they cover: `"screen"` (everything), `"world"` (the world only - the notes and HUD stay sharp) or `"terrain"`
(the world without the fighters). The last two need a fight.

One of: `"screen"`, `"world"`, `"terrain"` ([what they do](choices.md#effect-targets)).
