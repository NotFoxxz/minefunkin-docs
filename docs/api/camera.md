---
icon: material/camera-outline
---

# camera

Everything about how the song is framed: the zoom and the little pop on every beat - and in a fight, the camera
behind your fighter itself. Where it stands, where it looks, how wide its lens is.

!!! info "How to use it"
    `camera` is always there, you don't have to set anything up. Change a value, tween it, and when you're done, put it
    all back with `reset(camera)` or [`resetCamera([duration])`](actions.md#resetcamera).
    
    - **In every song:** `zoom`, `bump`, `bumpEvery`, `bumpStrength`, `shake`.
    - **Only in fights:** `x`, `y`, `z`, `yaw`, `pitch`, `roll`, `fov` and `nudge` move the camera that stands behind your
      fighter. Practice has no world, so there they simply do nothing. And only you see your camera move - your
      opponent has their own.
    
    Shortcuts: [zoom](shortcuts.md#zoom), [shake](shortcuts.md#shake), [focus](shortcuts.md#focus). How it all fits
    together: [The fight camera](../guides/camera.md).
    
    <p class="mf-like">Psych: <code>camGame.zoom</code>, <code>cameraShake</code>, <code>triggerEvent('Camera Follow Pos')</code> · Kade: <code>cameraZoom</code>, <code>cameraAngle</code></p>

## Example code

```lua
format 1.1
-- Bump on every beat, and look over at the opponent for two beats.
event { name = "Look Over" }

function onBeat(b)
    camera.bump += 0.03
end

function onEvent(p)
    tween(camera.yaw, -6, beats(1), "sineInOut")
    tween(camera.fov, -8, beats(1), "sineInOut")
    after(beats(2), function() resetCamera(beats(1)) end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [camera.bump](#camera-bump) | number | `1` | The pop you see on the beat. It sits on top of `zoom`, and the game eases it back to 1 … |
| [camera.bumpEvery](#camera-bumpevery) | number | `4` | The game's own bop: every this many beats the camera pops to `bumpStrength` (below 1 … |
| [camera.bumpStrength](#camera-bumpstrength) | number | `1.02` | How far the game's own bop pops (1.02 = 2 % closer). |
| [camera.shake](#camera-shake) | number | `0` | How hard the screen shakes, as a share of its width. 0.01 is already noticeable; 0.05 is … |
| [camera.zoom](#camera-zoom) | number | `1` | A zoom that stays until you change it: 1.2 is a bit closer, 0.9 a bit further out. In a … |
| [camera.x](#camera-x) | number | `0` | Moves the fight camera to its right (negative = left). |
| [camera.y](#camera-y) | number | `0` | Moves the fight camera up (negative = down). |
| [camera.z](#camera-z) | number | `0` | Moves the fight camera forward, into the picture (negative = back). |
| [camera.yaw](#camera-yaw) | number | `0` | Turns the fight camera to the right (positive) or left. |
| [camera.pitch](#camera-pitch) | number | `0` | Tilts the fight camera up (positive) or down. |
| [camera.roll](#camera-roll) | number | `0` | Rolls the picture clockwise - on top of `hud.angle`, which rolls the camera with the HUD. … |
| [camera.fov](#camera-fov) | number | `0` | Added to the lens: negative zooms in (a tele lens), positive goes wide. |
| [camera.nudge](#camera-nudge) | number | `1` | On every note you hit, the camera leans a tiny bit in the note's direction. This is how … |

---

### camera.bump { #camera-bump }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.bump</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

The pop you see on the beat. It sits on top of `zoom`, and the game eases it back to 1 all by itself - so
don't set it, **add** to it. That way your pop and the game's own bop stack instead of cancelling out.

```lua
camera.bump += 0.03
```

### camera.bumpEvery { #camera-bumpevery }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.bumpEvery</code> <span class="mf-eq">= <code>4</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

The game's own bop: every this many beats the camera pops to `bumpStrength` (below 1 counts as 1). To switch the bop
off, set `bumpStrength` to 1.

### camera.bumpStrength { #camera-bumpstrength }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.bumpStrength</code> <span class="mf-eq">= <code>1.02</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

How far the game's own bop pops (1.02 = 2 % closer).

### camera.shake { #camera-shake }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.shake</code> <span class="mf-eq">= <code>0</code></span></p>

How hard the screen shakes, as a share of its width. 0.01 is already noticeable; 0.05 is an earthquake. It keeps
shaking until you tween it back to 0 - or use the [shake](shortcuts.md#shake) shortcut, which calms down on its own.

### camera.zoom { #camera-zoom }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.zoom</code> <span class="mf-eq">= <code>1</code></span></p>

A zoom that stays until you change it: 1.2 is a bit closer, 0.9 a bit further out. In a fight the world zooms
with it, not just the HUD.

### camera.x { #camera-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span><span class="mf-tag fight">fights only</span></p>

Moves the fight camera to its right (negative = left).

### camera.y { #camera-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span><span class="mf-tag fight">fights only</span></p>

Moves the fight camera up (negative = down).

### camera.z { #camera-z }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.z</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span><span class="mf-tag fight">fights only</span></p>

Moves the fight camera forward, into the picture (negative = back).

### camera.yaw { #camera-yaw }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.yaw</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span><span class="mf-tag fight">fights only</span></p>

Turns the fight camera to the right (positive) or left.

### camera.pitch { #camera-pitch }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.pitch</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span><span class="mf-tag fight">fights only</span></p>

Tilts the fight camera up (positive) or down.

### camera.roll { #camera-roll }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.roll</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span><span class="mf-tag fight">fights only</span></p>

Rolls the picture clockwise - on top of `hud.angle`, which rolls the camera with the HUD. `hud.angle = 180` and
`camera.roll = -180` together turn only the HUD upside down, the world stays upright.

### camera.fov { #camera-fov }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.fov</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag fight">fights only</span></p>

Added to the lens: negative zooms in (a tele lens), positive goes wide.

### camera.nudge { #camera-nudge }

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.nudge</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 5</span><span class="mf-tag fight">fights only</span></p>

On every note you hit, the camera leans a tiny bit in the note's direction. This is how much: 0 switches it off
(nice when your own script moves the camera, or for a calm part), 2 makes it twice as strong.
