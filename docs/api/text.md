---
icon: material/format-text
---

# text[n]

Eight texts you can put anywhere on the screen: a word on the drop, lyrics, a counter, a title card. Positions are shares
of the screen, so they sit in the same spot in every window size.

!!! info "How to use it"
    `text[0]` to `text[7]` - set `value` and it shows, `""` hides it. Positions are shares of the screen, so a text
    sits in the same place in every window size. `text[7]` is where the built-in Lyrics event writes; the others are
    free.
    
    Texts and [pictures](image.md) share the [layers](choices.md#layers): `layer` says on which, `order` sorts within it.
    
    <p class="mf-like">Psych: <code>makeLuaText</code>, <code>setTextString</code>, <code>setTextColor</code>, <code>setTextFont</code>, <code>setTextBorder</code> · Kade: —</p>

## Example code

```lua
-- "GO!" pops in on the drop and fades.
function onEvent(p)
    text[2].value = "GO!"
    text[2].y = 0.35
    text[2].size = 3
    text[2].color = #FFD040
    text[2].outline = #000000
    text[2].alpha = 1
    tween(text[2].size, 2, beats(0.5), "backOut")
    after(beats(1), function() tween(text[2].alpha, 0, beats(1)) end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [text[n].value](#text-value) | text | `""` | What it says (up to 200 characters). `""` = hidden. Numbers are turned into text: … |
| [text[n].x](#text-x) | number | `0.5` | Where its anchor sits from left to right: 0 = the left edge, 1 = the right edge. |
| [text[n].y](#text-y) | number | `0.5` | Where its anchor sits from top to bottom: 0 = the top, 1 = the bottom. |
| [text[n].size](#text-size) | number | `1` | Its size: 1 = twice the GUI font. |
| [text[n].color](#text-color) | colour | `#FFFFFF` | Its colour. |
| [text[n].alpha](#text-alpha) | number | `1` | Its opacity. |
| [text[n].angle](#text-angle) | number | `0` | Turned clockwise around its anchor, in degrees. |
| [text[n].align](#text-align) | choice | `"center"` | Which side of the text the anchor is on: `"center"`, `"left"` (the text runs to the right … |
| [text[n].layer](#text-layer) | choice | `"front"` | Which [layer](choices.md#layers) it's drawn on. |
| [text[n].order](#text-order) | number | `0` | Its place within the layer: higher = on top. Texts and pictures sort together. |
| [text[n].font](#text-font) | choice | `"default"` | Minecraft's fonts: `"default"`, `"uniform"` (smooth), `"alt"` (the enchanting table's … |
| [text[n].outline](#text-outline) | colour | `none` | A border around the letters in this colour, in place of the shadow: `text[0].outline = … |
| [text[n].wrap](#text-wrap) | number | `0` | Breaks the text into lines at this share of the screen width. 0 = one line. |

---

### text[n].value { #text-value }

<p class="mf-sig"><span class="mf-type">text</span> <code>text[n].value</code> <span class="mf-eq">= <code>""</code></span></p>

What it says (up to 200 characters). `""` = hidden. Numbers are turned into text: `text[4].value = player.combo`.

### text[n].x { #text-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].x</code> <span class="mf-eq">= <code>0.5</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Where its anchor sits from left to right: 0 = the left edge, 1 = the right edge.

### text[n].y { #text-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].y</code> <span class="mf-eq">= <code>0.5</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Where its anchor sits from top to bottom: 0 = the top, 1 = the bottom.

### text[n].size { #text-size }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].size</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Its size: 1 = twice the GUI font.

### text[n].color { #text-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>text[n].color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Its colour.

### text[n].alpha { #text-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span></p>

Its opacity.

### text[n].angle { #text-angle }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].angle</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span><span class="mf-tag">kept at the song's end</span></p>

Turned clockwise around its anchor, in degrees.

### text[n].align { #text-align }

<p class="mf-sig"><span class="mf-type">choice</span> <code>text[n].align</code> <span class="mf-eq">= <code>"center"</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Which side of the text the anchor is on: `"center"`, `"left"` (the text runs to the right of `x`) or `"right"`.

One of: `"center"`, `"left"`, `"right"`.

### text[n].layer { #text-layer }

<p class="mf-sig"><span class="mf-type">choice</span> <code>text[n].layer</code> <span class="mf-eq">= <code>"front"</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Which [layer](choices.md#layers) it's drawn on.

One of: `"front"`, `"back"`, `"lanes"`, `"top"` ([what they do](choices.md#layers)).

### text[n].order { #text-order }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].order</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Its place within the layer: higher = on top. Texts and pictures sort together.

### text[n].font { #text-font }

<p class="mf-sig"><span class="mf-type">choice</span> <code>text[n].font</code> <span class="mf-eq">= <code>"default"</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Minecraft's fonts: `"default"`, `"uniform"` (smooth), `"alt"` (the enchanting table's runes), `"illager"`.

One of: `"default"`, `"uniform"`, `"alt"`, `"illager"` ([what they do](choices.md#fonts)).

### text[n].outline { #text-outline }

<p class="mf-sig"><span class="mf-type">colour</span> <code>text[n].outline</code> <span class="mf-eq">= <code>none</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

A border around the letters in this colour, in place of the shadow: `text[0].outline = #000000`. `none` (the
default) = the usual shadow.

### text[n].wrap { #text-wrap }

<p class="mf-sig"><span class="mf-type">number</span> <code>text[n].wrap</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span></p>

Breaks the text into lines at this share of the screen width. 0 = one line.
