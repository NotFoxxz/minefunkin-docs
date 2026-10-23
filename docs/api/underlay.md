---
icon: material/rectangle-outline
---

# underlay

The dark strip behind your lanes. Light it up on the beat, colour it, widen it, or get rid of it completely for a cleaner
look.

!!! info "How to use it"
    Always there. It follows
    `strums.x` - `underlay.x` comes on top. Pictures and texts on the [`"back"` layer](choices.md#layers) are drawn under
    it, on `"lanes"` over it.

## Example code

```lua
-- No strip in this song - the stage art shows through.
function onStart()
    underlay.alpha = 0
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [underlay.alpha](#underlay-alpha) | number | `0.65` | Its opacity: 0 = gone, 1 = solid. 0.65 = the usual dark strip. |
| [underlay.color](#underlay-color) | colour | `#000000` | Its colour. |
| [underlay.x](#underlay-x) | number | `0` | Moved to the right in pixels, on top of `strums.x`. |
| [underlay.width](#underlay-width) | number | `1` | Its width: 1 = the four lanes plus a margin, 2 = twice as wide. |

---

### underlay.alpha { #underlay-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>underlay.alpha</code> <span class="mf-eq">= <code>0.65</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Its opacity: 0 = gone, 1 = solid. 0.65 = the usual dark strip.

### underlay.color { #underlay-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>underlay.color</code> <span class="mf-eq">= <code>#000000</code></span></p>

Its colour.

### underlay.x { #underlay-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>underlay.x</code> <span class="mf-eq">= <code>0</code></span></p>

Moved to the right in pixels, on top of `strums.x`.

### underlay.width { #underlay-width }

<p class="mf-sig"><span class="mf-type">number</span> <code>underlay.width</code> <span class="mf-eq">= <code>1</code></span></p>

Its width: 1 = the four lanes plus a margin, 2 = twice as wide.
