---
icon: material/human-greeting
---

# character[n]

Eight sprite characters: a Psych sprite (a `.png` with its Sparrow `.xml`) that sings by itself. Name its poses by the
animation names in its `.xml` - MineFunkin plays the idle on the beat, a sing pose on every note of its side, held
through long notes, and the miss pose when you miss.

!!! info "How to use it"
    `character[0]` to `character[7]`. Set `file` and `side`, then name the poses with
    [characterPose](shortcuts.md#characterpose); play your own poses with [characterPlay](shortcuts.md#characterplay).
    
    | Pose | When MineFunkin plays it |
    |---|---|
    | `idle` | on the beat while it isn't singing |
    | `danceLeft`, `danceRight` | instead of `idle`, one after the other every beat (a GF) |
    | `left`, `down`, `up`, `right` | a note of its side in that lane - it stays one beat after the note |
    | `leftHold` ... `rightHold` | over and over while a long note is held (else the sing pose's last frame stays) |
    | `leftMiss` ... `rightMiss` | you missed a note in that lane |
    | `cheer` | every `cheerEvery` notes of your combo |
    | `sad` | your combo of 10 or more broke |
    
    Works in fights and in practice, drawn on the screen like the [pictures](image.md). The 3D fighters stay - switch the
    world off ([`stage.world`](stage.md) `"off"`) for a sprite-only song, or keep only the fighters with `"fighters"`.
    
    <p class="mf-like">Psych: <code>characters/*.json</code> (<code>animations</code>, <code>offsets</code>, <code>flip_x</code>, <code>scale</code>) · Kade: —</p>

## Example code

```lua
-- A Boyfriend sprite that sings your notes.
function onStart()
    character[0].file = "characters/bf.png"     -- + bf.xml next to it
    character[0].side = "bf"
    character[0].x = 0.78
    character[0].y = 0.92
    characterPose(0, "idle", "BF idle dance")
    characterPose(0, "left", "BF NOTE LEFT", 5, -6)
    characterPose(0, "down", "BF NOTE DOWN", -20, -51)
    characterPose(0, "up", "BF NOTE UP", -46, 27)
    characterPose(0, "right", "BF NOTE RIGHT", -48, -7)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [character[].file](#character-file) | text | `""` | The sprite: a `.png` with its Sparrow `.xml` of the same name next to it, from the song … |
| [character[].side](#character-side) | choice | `"none"` | Whose notes it sings: `"bf"` = the chart's player side, `"dad"` = the opponent side, … |
| [character[].x](#character-x) | number | `0.5` | Where its feet are, across: 0 = the left edge, 1 = the right. The middle of the bottom of … |
| [character[].y](#character-y) | number | `0.9` | Where its feet are, down: 0 = the top, 1 = the bottom. |
| [character[].scale](#character-scale) | number | `1` | Its size: 1 = the sprite's own pixels on a 1280 x 720 screen - the size it has in a Psych … |
| [character[].alpha](#character-alpha) | number | `1` | Its opacity. |
| [character[].color](#character-color) | colour | `#FFFFFF` | A tint multiplied onto it. |
| [character[].flipX](#character-flipx) | switch | `false` | Mirrored. |
| [character[].layer](#character-layer) | choice | `"back"` | The [layer](choices.md#layers) it's drawn on. In a fight with the world on, `"stage"` is … |
| [character[].order](#character-order) | number | `0` | Its place within the layer, together with the pictures and texts there: higher = in front. |
| [character[].fps](#character-fps) | number | `24` | How fast its poses play, frames a second. |
| [character[].danceEvery](#character-danceevery) | number | `0` | It dances every this many beats. 0 = by itself: every beat with `danceLeft` / … |
| [character[].cheerEvery](#character-cheerevery) | number | `0` | Its `"cheer"` pose plays every this many notes of your combo. 0 = never. |
| [character[].smooth](#character-smooth) | switch | `true` | Smoothed when it's scaled. `false` = sharp pixels (pixel-art sprites). |
| [character[].follow](#character-follow) | number | `0` | How much it moves and grows with the fight camera, like [`image[n].follow`](image.md): 0 … |

---

### character[].file { #character-file }

<p class="mf-sig"><span class="mf-type">text</span> <code>character[].file</code> <span class="mf-eq">= <code>""</code></span></p>

The sprite: a `.png` with its Sparrow `.xml` of the same name next to it, from the song folder (or its `events/`
folder). `""` = no character in this slot.

### character[].side { #character-side }

<p class="mf-sig"><span class="mf-type">choice</span> <code>character[].side</code> <span class="mf-eq">= <code>"none"</code></span></p>

Whose notes it sings: `"bf"` = the chart's player side, `"dad"` = the opponent side, `"both"`, or `"none"` - it only
dances and reacts (a GF, a crowd).

One of: `"none"`, `"bf"`, `"dad"`, `"both"`.

### character[].x { #character-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].x</code> <span class="mf-eq">= <code>0.5</code></span></p>

Where its feet are, across: 0 = the left edge, 1 = the right. The middle of the bottom of its idle pose stands there.

### character[].y { #character-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].y</code> <span class="mf-eq">= <code>0.9</code></span></p>

Where its feet are, down: 0 = the top, 1 = the bottom.

### character[].scale { #character-scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].scale</code> <span class="mf-eq">= <code>1</code></span></p>

Its size: 1 = the sprite's own pixels on a 1280 x 720 screen - the size it has in a Psych mod, whatever the window.

### character[].alpha { #character-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Its opacity.

### character[].color { #character-color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>character[].color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>

A tint multiplied onto it.

### character[].flipX { #character-flipx }

<p class="mf-sig"><span class="mf-type">switch</span> <code>character[].flipX</code> <span class="mf-eq">= <code>false</code></span></p>

Mirrored.

### character[].layer { #character-layer }

<p class="mf-sig"><span class="mf-type">choice</span> <code>character[].layer</code> <span class="mf-eq">= <code>"back"</code></span></p>

The [layer](choices.md#layers) it's drawn on. In a fight with the world on, `"stage"` is drawn like `"back"`.

One of: `"back"`, `"lanes"`, `"front"`, `"top"`, `"stage"`.

### character[].order { #character-order }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].order</code> <span class="mf-eq">= <code>0</code></span></p>

Its place within the layer, together with the pictures and texts there: higher = in front.

### character[].fps { #character-fps }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].fps</code> <span class="mf-eq">= <code>24</code></span></p>

How fast its poses play, frames a second.

### character[].danceEvery { #character-danceevery }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].danceEvery</code> <span class="mf-eq">= <code>0</code></span></p>

It dances every this many beats. 0 = by itself: every beat with `danceLeft` / `danceRight`, else every 2nd beat.

### character[].cheerEvery { #character-cheerevery }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].cheerEvery</code> <span class="mf-eq">= <code>0</code></span></p>

Its `"cheer"` pose plays every this many notes of your combo. 0 = never.

### character[].smooth { #character-smooth }

<p class="mf-sig"><span class="mf-type">switch</span> <code>character[].smooth</code> <span class="mf-eq">= <code>true</code></span></p>

Smoothed when it's scaled. `false` = sharp pixels (pixel-art sprites).

### character[].follow { #character-follow }

<p class="mf-sig"><span class="mf-type">number</span> <code>character[].follow</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

How much it moves and grows with the fight camera, like [`image[n].follow`](image.md): 0 = fixed on the screen, 1 = in the
world.
