---
icon: material/image-outline
---

# image[n]

Thirty-two pictures: logos, stage art, sprite sheets, Psych sprites with their animations, videos, plain coloured boxes.
Everything you need to dress up a song.

!!! info "How to use it"
    `image[0]` to `image[31]` - set `file` and it shows, `""` hides it. Positions and sizes are shares of the screen.
    A picture is loaded the first time it's drawn; [`preload(file)`](shortcuts.md#preload) in `onStart` loads it
    before, so it's there on the right frame.
    
    - **Files:** a `.png` in the song folder or its `events/` folder (up to 8192 pixels a side, 128 pictures and 512 MB
      per song). `"solid"` = a plain white box to colour with `color`.
    - **Animated:** a grid sprite sheet (`columns`, `rows`, `fps`), a Psych sprite (`.png` + Sparrow `.xml`, `anim`), or
      a video as a folder of numbered frames (`"videos/intro/"`).
    - **In a fight:** the [`"stage"` layer](choices.md#layers) paints it onto the world behind the fighters, `follow`
      keeps it on the world while the camera turns.
    
    Texts and pictures share the [layers](choices.md#layers). More: [Stages and sprites](../guides/stages.md).
    
    <p class="mf-like">Psych: <code>makeLuaSprite</code>, <code>makeAnimatedLuaSprite</code>, <code>addAnimationByPrefix</code>, <code>setBlendMode</code>, <code>setScrollFactor</code> · Kade: —</p>

## Example code

```lua
-- The song's logo in the top left corner, a pulsing glow behind it.
function onStart()
    image[0].file = "logo.png"
    image[0].x = 0.16
    image[0].y = 0.14
    image[0].width = 0.24
    image[1].file = "glow.png"
    image[1].x = 0.16
    image[1].y = 0.14
    image[1].width = 0.3
    image[1].blend = "add"
    image[1].order = -1
end

function onBeat(b)
    image[1].alpha = 1
    tween(image[1].alpha, 0.3, beats(1))
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [image[n].file](#image-file) | text | `""` | The picture: a `.png` in the song folder or its `events/` folder, `"solid"` (a white … |
| [image[n].x](#image-x) | number | `0.5` | Where its middle sits from left to right: 0 = the left edge, 1 = the right edge. |
| [image[n].y](#image-y) | number | `0.5` | Where its middle sits from top to bottom: 0 = the top, 1 = the bottom. |
| [image[n].width](#image-width) | number | `0.3` | Its width as a share of the screen width. The height follows the picture's shape unless … |
| [image[n].height](#image-height) | number | `0` | Its height as a share of the screen height. 0 = follows the picture's shape; anything … |
| [image[n].alpha](#image-alpha) | number | `1` | Its opacity. |
| [image[n].angle](#image-angle) | number | `0` | Turned clockwise around its middle, in degrees. |
| [image[n].color](#image-color) | colour | `#FFFFFF` | Multiplied onto the picture (#FFFFFF = its own colours). Colours a `"solid"` box. |
| [image[n].layer](#image-layer) | choice | `"front"` | Which [layer](choices.md#layers) it's drawn on. `"stage"` paints it onto the world in a … |
| [image[n].order](#image-order) | number | `0` | Its place within the layer: higher = on top. Texts and pictures sort together. |
| [image[n].columns](#image-columns) | number | `1` | A sprite sheet: the picture is a grid of equal frames this many across, read left to … |
| [image[n].rows](#image-rows) | number | `1` | A sprite sheet: this many frames down. |
| [image[n].frames](#image-frames) | number | `0` | How many of the grid's cells are frames (0 = all of them). |
| [image[n].frame](#image-frame) | number | `0` | The frame shown, from 0. Set it to 0 to play an animation again; a tween on it plays it … |
| [image[n].fps](#image-fps) | number | `0` | Frames a second it plays at by itself (0 = it stays on `frame`). |
| [image[n].loop](#image-loop) | switch | `true` | Starts over after the last frame (true) or stops on it (false). |
| [image[n].follow](#image-follow) | number | `0` | How much it moves with the fight camera: 1 = like the world, so the fighters never slide … |
| [image[n].flipX](#image-flipx) | switch | `false` | Mirrored left to right. |
| [image[n].flipY](#image-flipy) | switch | `false` | Mirrored upside down. |
| [image[n].anim](#image-anim) | text | `""` | A Psych sprite (the `.png` with a Sparrow `.xml` of the same name next to it): plays the … |
| [image[n].blend](#image-blend) | choice | `"normal"` | How it's laid over what's under it: `"normal"`, `"add"` (glows), `"multiply"` (darkens - … |
| [image[n].smooth](#image-smooth) | switch | `false` | false (default) = drawn with sharp pixels, like the game. true = smoothed - for big, … |

---

### image[n].file { #image-file }

<p class="mf-sig"><span class="mf-type">text</span> <code>image[n].file</code> <span class="mf-eq">= <code>""</code></span></p>

The picture: a `.png` in the song folder or its `events/` folder, `"solid"` (a white box), or a folder of video
frames ending in `/` (`"videos/intro/"` = `intro/0001.jpg`, `0002.jpg`, ... played like a sprite sheet). `""` =
hidden.

### image[n].x { #image-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].x</code> <span class="mf-eq">= <code>0.5</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Where its middle sits from left to right: 0 = the left edge, 1 = the right edge.

### image[n].y { #image-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].y</code> <span class="mf-eq">= <code>0.5</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Where its middle sits from top to bottom: 0 = the top, 1 = the bottom.

### image[n].width { #image-width }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].width</code> <span class="mf-eq">= <code>0.3</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Its width as a share of the screen width. The height follows the picture's shape unless `height` is set.

### image[n].height { #image-height }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].height</code> <span class="mf-eq">= <code>0</code></span></p>

Its height as a share of the screen height. 0 = follows the picture's shape; anything else stretches it.

### image[n].alpha { #image-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span></p>

Its opacity.

### image[n].angle { #image-angle }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].angle</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span><span class="mf-tag">kept at the song's end</span></p>

Turned clockwise around its middle, in degrees.

### image[n].color { #image-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>image[n].color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Multiplied onto the picture (#FFFFFF = its own colours). Colours a `"solid"` box.

### image[n].layer { #image-layer }

<p class="mf-sig"><span class="mf-type">choice</span> <code>image[n].layer</code> <span class="mf-eq">= <code>"front"</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Which [layer](choices.md#layers) it's drawn on. `"stage"` paints it onto the world in a fight.

One of: `"front"`, `"back"`, `"lanes"`, `"top"`, `"stage"` ([what they do](choices.md#layers)).

### image[n].order { #image-order }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].order</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Its place within the layer: higher = on top. Texts and pictures sort together.

### image[n].columns { #image-columns }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].columns</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">1 – 64</span><span class="mf-tag">kept at the song's end</span></p>

A sprite sheet: the picture is a grid of equal frames this many across, read left to right, top to bottom.

### image[n].rows { #image-rows }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].rows</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">1 – 64</span><span class="mf-tag">kept at the song's end</span></p>

A sprite sheet: this many frames down.

### image[n].frames { #image-frames }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].frames</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 4096</span><span class="mf-tag">kept at the song's end</span></p>

How many of the grid's cells are frames (0 = all of them).

### image[n].frame { #image-frame }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].frame</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

The frame shown, from 0. Set it to 0 to play an animation again; a tween on it plays it at your speed.

### image[n].fps { #image-fps }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].fps</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 240</span><span class="mf-tag">kept at the song's end</span></p>

Frames a second it plays at by itself (0 = it stays on `frame`).

### image[n].loop { #image-loop }

<p class="mf-sig"><span class="mf-type">switch</span> <code>image[n].loop</code> <span class="mf-eq">= <code>true</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Starts over after the last frame (true) or stops on it (false).

### image[n].follow { #image-follow }

<p class="mf-sig"><span class="mf-type">number</span> <code>image[n].follow</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag">kept at the song's end</span><span class="mf-tag fight">fights only</span></p>

How much it moves with the fight camera: 1 = like the world, so the fighters never slide over it while the camera
turns, nudges and bumps; 0 = it stays on the screen. `x` / `y` / `width` / `height` are where it sits while the
camera rests.

### image[n].flipX { #image-flipx }

<p class="mf-sig"><span class="mf-type">switch</span> <code>image[n].flipX</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Mirrored left to right.

### image[n].flipY { #image-flipy }

<p class="mf-sig"><span class="mf-type">switch</span> <code>image[n].flipY</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Mirrored upside down.

### image[n].anim { #image-anim }

<p class="mf-sig"><span class="mf-type">text</span> <code>image[n].anim</code> <span class="mf-eq">= <code>""</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

A Psych sprite (the `.png` with a Sparrow `.xml` of the same name next to it): plays the frames whose names start
with this, at `fps`. `""` = the whole picture.

### image[n].blend { #image-blend }

<p class="mf-sig"><span class="mf-type">choice</span> <code>image[n].blend</code> <span class="mf-eq">= <code>"normal"</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

How it's laid over what's under it: `"normal"`, `"add"` (glows), `"multiply"` (darkens - shadows, tints),
`"screen"` (lightens), `"erase"` (wipes out what's under it - in desktop mode a hole to the desktop), `"key"` (in desktop mode its
exact #131313 pixels become holes to the desktop; elsewhere like normal).

One of: `"normal"`, `"add"`, `"multiply"`, `"screen"`, `"erase"`, `"key"` ([what they do](choices.md#blend-modes)).

<p class="mf-like">Psych: <code>setBlendMode</code></p>

### image[n].smooth { #image-smooth }

<p class="mf-sig"><span class="mf-type">switch</span> <code>image[n].smooth</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

false (default) = drawn with sharp pixels, like the game. true = smoothed - for big, detailed art that's drawn
smaller or turned. Psych's `antialiasing`.
