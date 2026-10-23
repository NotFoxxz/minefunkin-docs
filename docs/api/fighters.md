---
icon: material/human-handsup
---

# Fighters

The two fighters: `player` (you) and `opponent`. Move them, turn them, squash them, tint them, pose them, re-skin them,
pin them to the screen like sprites, outline them. All of it only in your own picture, so go wild.

!!! info "How to use it"
    Every property here has several names for the same two fighters:
    
    | Name | Who |
    |---|---|
    | `player` / `puppet[0]` | you |
    | `opponent` / `puppet[1]` | the other one |
    | `boyfriend` / `dad` | by the **chart's** sides: whoever plays the Boyfriend part / the opponent part - the same as `player` / `opponent` unless you play the opponent side |
    
    **Where:** in a fight, the fighters in the world - seen only by you, the real players don't move. In practice, the two
    puppets beside the lanes follow most of it (position, size, squash, turn, tint, poses, body parts, pinning);
    `clip*`, `outline*`, `depth` and `facing` are fights only.
    
    Put one back with [`resetPuppet(who[, duration])`](actions.md#resetpuppet) or `reset(player, duration)`. Shortcuts:
    [pose](shortcuts.md#pose), [setPose](shortcuts.md#setpose), [setSkin](shortcuts.md#setskin),
    [setModel](shortcuts.md#setmodel), [swapFighters](shortcuts.md#swapfighters), [bind](shortcuts.md#bind),
    [focus](shortcuts.md#focus). Body parts: [Body parts](parts.md). The whole picture: [The fighters](../guides/fighters.md).
    
    <p class="mf-like">Psych: <code>boyfriend.x</code>, <code>dad.alpha</code>, <code>characterPlayAnim</code>, <code>setObjectCamera</code> · Kade: <code>boyfriend</code>, <code>dad</code></p>

## Example code

```lua
-- The opponent slides in from the right into the middle, looks at you, then goes back.
function onEvent(p)
    opponent.pinned = true
    opponent.screenX = 1.3
    opponent.screenY = opponent.homeY
    opponent.facing = "camera"
    tween(opponent.screenX, 0.5, beats(2), "cubicInOut")
    after(beats(8), function()
        tween(opponent.screenX, opponent.homeX, beats(2), "cubicInOut")
        after(beats(2), function() resetPuppet("opponent") end)
    end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [player.x](#x) | number | `0` | Moved to the camera's right, in blocks (practice: a block = the puppet's height / 2.1). |
| [player.y](#y) | number | `0` | Moved up, in blocks. |
| [player.z](#z) | number | `0` | Moved away from the camera, in blocks. |
| [player.scale](#scale) | number | `1` | Its size, from the feet up. |
| [player.turn](#turn) | number | `0` | Turned around its own vertical axis, in degrees: positive = to its right. |
| [player.pitch](#pitch) | number | `0` | The whole figure tipped forward (positive) or back, around its feet, in degrees. |
| [player.roll](#roll) | number | `0` | The whole figure tipped to its own right (positive) or left, around its feet, in degrees. |
| [player.alpha](#alpha) | number | `1` | Its opacity. |
| [player.color](#color) | colour | `#FFFFFF` | Multiplied onto the skin - and onto its armor, cape and head item. |
| [player.visible](#visible) | switch | `true` | false = gone. |
| [player.animate](#animate) | switch | `true` | false = MineFunkin's own animation stops: it stands in its rest pose and only your values … |
| [player.squash](#squash) | number | `0` | Squash and stretch, feet on the ground, volume kept: 0.3 = shorter and wider, -0.3 = … |
| [player.pose](#pose) | choice | `"none"` | Plays one of MineFunkin's own poses: a lane's pose pops and holds like a held note, … |
| [player.skin](#skin) | text | `""` | Its Minecraft skin: `""` = its own, `"player"` / `"opponent"` = that fighter's own (so … |
| [player.model](#model) | choice | `"default"` | The arm shape: `"default"` (what the skin says), `"wide"` (Steve, 4 pixels) or `"slim"` … |
| [player.pinned](#pinned) | switch | `false` | true = stuck to a spot on the screen like a sprite: `screenX` / `screenY` place its feet, … |
| [player.place](#place) | choice | `""` | Which spot of the fight it stands on: `"bf"` (the spot in front, where the camera stands … |
| [player.screenX](#screenx) | number | `0.5` | A pinned fighter's feet, from left to right: 0 = the left edge, 1 = the right edge. … |
| [player.screenY](#screeny) | number | `0.9` | A pinned fighter's feet, from top to bottom: 0.9 = near the bottom. Above 1 = the feet … |
| [player.depth](#depth) | number | `0` | How far from the camera a pinned fighter stands, in blocks: near = big. 0 = as far as it … |
| [player.screenHeight](#screenheight) | number | `0` | A pinned fighter's height as a share of the screen (1 = as tall as the screen), whatever … |
| [player.clipLeft](#clipleft) | number | `0` | Cuts the fighter off left of this share of the screen (0 = not cut). With the other three … |
| [player.clipTop](#cliptop) | number | `0` | Cuts the fighter off above this share of the screen (0 = not cut). |
| [player.clipRight](#clipright) | number | `1` | Cuts the fighter off right of this share of the screen (1 = not cut). |
| [player.clipBottom](#clipbottom) | number | `1` | Cuts the fighter off below this share of the screen (1 = not cut). |
| [player.facing](#facing) | choice | `"fight"` | `"fight"` = it faces where the fight turns it, `"camera"` = it looks straight at you … |
| [player.outlineAlpha](#outlinealpha) | number | `0` | A line around the fighter's silhouette: 0 = none, 1 = full. |
| [player.outlineColor](#outlinecolor) | colour | `#FFFFFF` | The outline's colour. |
| [player.outlineOnly](#outlineonly) | switch | `false` | true = only the outline shows - the fighter itself is gone (a silhouette drawn with a … |
| [player.outlineWidth](#outlinewidth) | number | `0` | The outline's width in pixels at 1080p (it scales with the window). 0 = automatic, about … |
| [player.homeX](#homex) | number, read | `0.5` | Where the fight puts its feet on the screen right now, from left to right - start a slide … |
| [player.homeY](#homey) | number, read | `0.9` | Where the fight puts its feet on the screen right now, from top to bottom. |

---

### player.x { #x }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.x</code> · <code>opponent.x</code> · <code>boyfriend.x</code> · <code>dad.x</code> · <code>puppet[i].x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

Moved to the camera's right, in blocks (practice: a block = the puppet's height / 2.1).

### player.y { #y }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.y</code> · <code>opponent.y</code> · <code>boyfriend.y</code> · <code>dad.y</code> · <code>puppet[i].y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

Moved up, in blocks.

### player.z { #z }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.z</code> · <code>opponent.z</code> · <code>boyfriend.z</code> · <code>dad.z</code> · <code>puppet[i].z</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

Moved away from the camera, in blocks.

### player.scale { #scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.scale</code> · <code>opponent.scale</code> · <code>boyfriend.scale</code> · <code>dad.scale</code> · <code>puppet[i].scale</code> <span class="mf-eq">= <code>1</code></span></p>

Its size, from the feet up.

### player.turn { #turn }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.turn</code> · <code>opponent.turn</code> · <code>boyfriend.turn</code> · <code>dad.turn</code> · <code>puppet[i].turn</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

Turned around its own vertical axis, in degrees: positive = to its right.

### player.pitch { #pitch }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.pitch</code> · <code>opponent.pitch</code> · <code>boyfriend.pitch</code> · <code>dad.pitch</code> · <code>puppet[i].pitch</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

The whole figure tipped forward (positive) or back, around its feet, in degrees.

### player.roll { #roll }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.roll</code> · <code>opponent.roll</code> · <code>boyfriend.roll</code> · <code>dad.roll</code> · <code>puppet[i].roll</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

The whole figure tipped to its own right (positive) or left, around its feet, in degrees.

### player.alpha { #alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.alpha</code> · <code>opponent.alpha</code> · <code>boyfriend.alpha</code> · <code>dad.alpha</code> · <code>puppet[i].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Its opacity.

### player.color { #color }

<p class="mf-sig"><span class="mf-type">colour</span> <code>player.color</code> · <code>opponent.color</code> · <code>boyfriend.color</code> · <code>dad.color</code> · <code>puppet[i].color</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>

Multiplied onto the skin - and onto its armor, cape and head item.

### player.visible { #visible }

<p class="mf-sig"><span class="mf-type">switch</span> <code>player.visible</code> · <code>opponent.visible</code> · <code>boyfriend.visible</code> · <code>dad.visible</code> · <code>puppet[i].visible</code> <span class="mf-eq">= <code>true</code></span></p>

false = gone.

### player.animate { #animate }

<p class="mf-sig"><span class="mf-type">switch</span> <code>player.animate</code> · <code>opponent.animate</code> · <code>boyfriend.animate</code> · <code>dad.animate</code> · <code>puppet[i].animate</code> <span class="mf-eq">= <code>true</code></span></p>

false = MineFunkin's own animation stops: it stands in its rest pose and only your values (and the body parts')
move it. Wins over `pose`.

### player.squash { #squash }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.squash</code> · <code>opponent.squash</code> · <code>boyfriend.squash</code> · <code>dad.squash</code> · <code>puppet[i].squash</code> <span class="mf-eq">= <code>0</code></span></p>

Squash and stretch, feet on the ground, volume kept: 0.3 = shorter and wider, -0.3 = taller and thinner.

### player.pose { #pose }

<p class="mf-sig"><span class="mf-type">choice</span> <code>player.pose</code> · <code>opponent.pose</code> · <code>boyfriend.pose</code> · <code>dad.pose</code> · <code>puppet[i].pose</code> <span class="mf-eq">= <code>"none"</code></span></p>

Plays one of MineFunkin's own poses: a lane's pose pops and holds like a held note, `"death"` sits it down,
`"none"` lets go (a held pose eases out like a released note). While it's set, the notes don't change it.
Your own poses: [setPose](shortcuts.md#setpose).

One of: `"none"`, `"left"`, `"down"`, `"up"`, `"right"`, `"death"` ([what they do](choices.md#poses)).

### player.skin { #skin }

<p class="mf-sig"><span class="mf-type">text</span> <code>player.skin</code> · <code>opponent.skin</code> · <code>boyfriend.skin</code> · <code>dad.skin</code> · <code>puppet[i].skin</code> <span class="mf-eq">= <code>""</code></span></p>

Its Minecraft skin: `""` = its own, `"player"` / `"opponent"` = that fighter's own (so the two can swap), or a
64x64 skin `.png` from the song folder (or its `events/` / `skins/` folder) - at most 8 files, 1 MB each.

### player.model { #model }

<p class="mf-sig"><span class="mf-type">choice</span> <code>player.model</code> · <code>opponent.model</code> · <code>boyfriend.model</code> · <code>dad.model</code> · <code>puppet[i].model</code> <span class="mf-eq">= <code>"default"</code></span></p>

The arm shape: `"default"` (what the skin says), `"wide"` (Steve, 4 pixels) or `"slim"` (Alex, 3 pixels).

One of: `"default"`, `"wide"`, `"slim"`.

### player.pinned { #pinned }

<p class="mf-sig"><span class="mf-type">switch</span> <code>player.pinned</code> · <code>opponent.pinned</code> · <code>boyfriend.pinned</code> · <code>dad.pinned</code> · <code>puppet[i].pinned</code> <span class="mf-eq">= <code>false</code></span></p>

true = stuck to a spot on the screen like a sprite: `screenX` / `screenY` place its feet, whatever the camera does.
false = back where the fight wants it, at once.

### player.place { #place }

<p class="mf-sig"><span class="mf-type">choice</span> <code>player.place</code> · <code>opponent.place</code> · <code>boyfriend.place</code> · <code>dad.place</code> · <code>puppet[i].place</code> <span class="mf-eq">= <code>""</code></span></p>

Which spot of the fight it stands on: `"bf"` (the spot in front, where the camera stands behind), `"dad"` (the far
spot), `""` = the fight's own (you in front). Set it with [`bind(who, "bf" | "dad")`](shortcuts.md#bind) - that
sets both fighters, so they swap. The camera always stays behind the `"bf"` spot.

One of: `""`, `"bf"`, `"dad"`.

### player.screenX { #screenx }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.screenX</code> · <code>opponent.screenX</code> · <code>boyfriend.screenX</code> · <code>dad.screenX</code> · <code>puppet[i].screenX</code> <span class="mf-eq">= <code>0.5</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span></p>

A pinned fighter's feet, from left to right: 0 = the left edge, 1 = the right edge. Beyond = off the screen.

### player.screenY { #screeny }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.screenY</code> · <code>opponent.screenY</code> · <code>boyfriend.screenY</code> · <code>dad.screenY</code> · <code>puppet[i].screenY</code> <span class="mf-eq">= <code>0.9</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span></p>

A pinned fighter's feet, from top to bottom: 0.9 = near the bottom. Above 1 = the feet below the bottom edge.

### player.depth { #depth }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.depth</code> · <code>opponent.depth</code> · <code>boyfriend.depth</code> · <code>dad.depth</code> · <code>puppet[i].depth</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

How far from the camera a pinned fighter stands, in blocks: near = big. 0 = as far as it really is. The camera's
zoom still makes it bigger or smaller.

### player.screenHeight { #screenheight }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.screenHeight</code> · <code>opponent.screenHeight</code> · <code>boyfriend.screenHeight</code> · <code>dad.screenHeight</code> · <code>puppet[i].screenHeight</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span></p>

A pinned fighter's height as a share of the screen (1 = as tall as the screen), whatever the camera's lens.
0 = `depth` decides.

### player.clipLeft { #clipleft }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.clipLeft</code> · <code>opponent.clipLeft</code> · <code>boyfriend.clipLeft</code> · <code>dad.clipLeft</code> · <code>puppet[i].clipLeft</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span><span class="mf-tag fight">fights only</span></p>

Cuts the fighter off left of this share of the screen (0 = not cut). With the other three it shows the fighter
only inside a box - in a window frame, a TV, a rift.

```lua
-- Only inside the frame drawn at 0.3-0.7 x 0.2-0.8.
player.clipLeft = 0.3
player.clipRight = 0.7
player.clipTop = 0.2
player.clipBottom = 0.8
```

### player.clipTop { #cliptop }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.clipTop</code> · <code>opponent.clipTop</code> · <code>boyfriend.clipTop</code> · <code>dad.clipTop</code> · <code>puppet[i].clipTop</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span><span class="mf-tag fight">fights only</span></p>

Cuts the fighter off above this share of the screen (0 = not cut).

### player.clipRight { #clipright }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.clipRight</code> · <code>opponent.clipRight</code> · <code>boyfriend.clipRight</code> · <code>dad.clipRight</code> · <code>puppet[i].clipRight</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span><span class="mf-tag fight">fights only</span></p>

Cuts the fighter off right of this share of the screen (1 = not cut).

### player.clipBottom { #clipbottom }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.clipBottom</code> · <code>opponent.clipBottom</code> · <code>boyfriend.clipBottom</code> · <code>dad.clipBottom</code> · <code>puppet[i].clipBottom</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">share of the screen</span><span class="mf-tag fight">fights only</span></p>

Cuts the fighter off below this share of the screen (1 = not cut).

### player.facing { #facing }

<p class="mf-sig"><span class="mf-type">choice</span> <code>player.facing</code> · <code>opponent.facing</code> · <code>boyfriend.facing</code> · <code>dad.facing</code> · <code>puppet[i].facing</code> <span class="mf-eq">= <code>"fight"</code></span></p>
<p class="mf-tags"><span class="mf-tag fight">fights only</span></p>

`"fight"` = it faces where the fight turns it, `"camera"` = it looks straight at you (`turn` still turns it on
top).

One of: `"fight"`, `"camera"`.

### player.outlineAlpha { #outlinealpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.outlineAlpha</code> · <code>opponent.outlineAlpha</code> · <code>boyfriend.outlineAlpha</code> · <code>dad.outlineAlpha</code> · <code>puppet[i].outlineAlpha</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span><span class="mf-tag fight">fights only</span></p>

A line around the fighter's silhouette: 0 = none, 1 = full.

### player.outlineColor { #outlinecolor }

<p class="mf-sig"><span class="mf-type">colour</span> <code>player.outlineColor</code> · <code>opponent.outlineColor</code> · <code>boyfriend.outlineColor</code> · <code>dad.outlineColor</code> · <code>puppet[i].outlineColor</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>
<p class="mf-tags"><span class="mf-tag fight">fights only</span></p>

The outline's colour.

### player.outlineOnly { #outlineonly }

<p class="mf-sig"><span class="mf-type">switch</span> <code>player.outlineOnly</code> · <code>opponent.outlineOnly</code> · <code>boyfriend.outlineOnly</code> · <code>dad.outlineOnly</code> · <code>puppet[i].outlineOnly</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag fight">fights only</span></p>

true = only the outline shows - the fighter itself is gone (a silhouette drawn with a pen).

### player.outlineWidth { #outlinewidth }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.outlineWidth</code> · <code>opponent.outlineWidth</code> · <code>boyfriend.outlineWidth</code> · <code>dad.outlineWidth</code> · <code>puppet[i].outlineWidth</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 40</span><span class="mf-tag">pixels</span><span class="mf-tag fight">fights only</span></p>

The outline's width in pixels at 1080p (it scales with the window). 0 = automatic, about 3.

### player.homeX { #homex }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.homeX</code> · <code>opponent.homeX</code> · <code>boyfriend.homeX</code> · <code>dad.homeX</code> · <code>puppet[i].homeX</code> <span class="mf-eq">= <code>0.5</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Where the fight puts its feet on the screen right now, from left to right - start a slide from here and it
doesn't jump.

### player.homeY { #homey }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.homeY</code> · <code>opponent.homeY</code> · <code>boyfriend.homeY</code> · <code>dad.homeY</code> · <code>puppet[i].homeY</code> <span class="mf-eq">= <code>0.9</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Where the fight puts its feet on the screen right now, from top to bottom.
