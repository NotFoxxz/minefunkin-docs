---
icon: material/star-four-points-outline
---

# judgments

The "Sick!" popup, the ms label and the combo number that jump up on every hit. Move them, shrink them, or hide them
for a part where you want the screen clean.

!!! info "How to use it"
    `judgments` is always there. Where they pop up by default is the player's own setting (Options › MineFunkin ›
    Display › "Judgment position"); `x` and `y` move them from there.
    
    Shortcuts: [hideJudgments / showJudgments](shortcuts.md#hidejudgments).

## Example code

```lua
-- Smaller judgments, a bit higher, for a busy part.
tween(judgments.scale, 0.7, beats(1))
tween(judgments.y, -40, beats(1))
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [judgments.alpha](#judgments-alpha) | number | `1` | Their opacity. |
| [judgments.x](#judgments-x) | number | `0` | Moved to the right, in pixels. |
| [judgments.y](#judgments-y) | number | `0` | Moved down, in pixels. |
| [judgments.scale](#judgments-scale) | number | `1` | Their size. |

---

### judgments.alpha { #judgments-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>judgments.alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Their opacity.

### judgments.x { #judgments-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>judgments.x</code> <span class="mf-eq">= <code>0</code></span></p>

Moved to the right, in pixels.

### judgments.y { #judgments-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>judgments.y</code> <span class="mf-eq">= <code>0</code></span></p>

Moved down, in pixels.

### judgments.scale { #judgments-scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>judgments.scale</code> <span class="mf-eq">= <code>1</code></span></p>

Their size.
