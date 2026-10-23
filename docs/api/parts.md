---
icon: material/human
---

# Body parts

Every limb on its own: head, body, both arms, both legs. For waves, dances and poses of your own - on top of
MineFunkin's animation, or instead of it.

!!! info "How to use it"
    Write them as `player.head.pitch`, `opponent.leftArm.roll`, `puppet[i].rightLeg.scale`, `boyfriend.body.yaw` ... -
    the parts are `head`, `body`, `leftArm`, `rightArm`, `leftLeg`, `rightLeg`.
    
    "Right", "left" and "forward" are the **figure's own**: your fighter is seen from behind, so its right is your right;
    the opponent faces you, so its right is on your left. Both arms at `roll = 90` is a T-pose for either; an arm
    straight up is `roll` about 165.
    
    Everything goes **on top of** MineFunkin's own animation. With `animate = false` on the [fighter](fighters.md#animate)
    the animation stops and your values are the whole pose.
    
    Works in fights and on practice's puppets. Back home: [`resetPuppet(who)`](actions.md#resetpuppet) or
    `reset(player.head)`.

## Example code

```lua
-- A wave: the right arm goes up and swings.
player.rightArm.roll = 150
for i = 0, 3 do
    after(beats(i * 0.5), function()
        tween(player.rightArm.roll, i % 2 == 0 ? 120 : 160, beats(0.5), "sineInOut")
    end)
end
after(beats(2), function() resetPuppet("player", beats(0.5)) end)
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [player.‹part›.pitch](#part-pitch) | number | `0` | Degrees forward: the head nods, the body bends, an arm or leg swings forward. |
| [player.‹part›.yaw](#part-yaw) | number | `0` | Degrees turned to the figure's right. |
| [player.‹part›.roll](#part-roll) | number | `0` | Degrees: the head and body tilt to the figure's right, an arm or leg swings **outward**. |
| [player.‹part›.x](#part-x) | number | `0` | Moved to the figure's right, in model pixels (16 = a block). |
| [player.‹part›.y](#part-y) | number | `0` | Moved up, in model pixels. |
| [player.‹part›.z](#part-z) | number | `0` | Moved forward, in model pixels. |
| [player.‹part›.scale](#part-scale) | number | `1` | Its size, around its joint. |
| [player.‹part›.squash](#part-squash) | number | `0` | Squash (positive) or stretch (negative), around its joint, volume kept. |

---

### player.‹part›.pitch { #part-pitch }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.pitch</code> · <code>opponent.‹part›.pitch</code> · <code>puppet[i].‹part›.pitch</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

Degrees forward: the head nods, the body bends, an arm or leg swings forward.

### player.‹part›.yaw { #part-yaw }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.yaw</code> · <code>opponent.‹part›.yaw</code> · <code>puppet[i].‹part›.yaw</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

Degrees turned to the figure's right.

### player.‹part›.roll { #part-roll }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.roll</code> · <code>opponent.‹part›.roll</code> · <code>puppet[i].‹part›.roll</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

Degrees: the head and body tilt to the figure's right, an arm or leg swings **outward**.

### player.‹part›.x { #part-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.x</code> · <code>opponent.‹part›.x</code> · <code>puppet[i].‹part›.x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

Moved to the figure's right, in model pixels (16 = a block).

### player.‹part›.y { #part-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.y</code> · <code>opponent.‹part›.y</code> · <code>puppet[i].‹part›.y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

Moved up, in model pixels.

### player.‹part›.z { #part-z }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.z</code> · <code>opponent.‹part›.z</code> · <code>puppet[i].‹part›.z</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">blocks</span></p>

Moved forward, in model pixels.

### player.‹part›.scale { #part-scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.scale</code> · <code>opponent.‹part›.scale</code> · <code>puppet[i].‹part›.scale</code> <span class="mf-eq">= <code>1</code></span></p>

Its size, around its joint.

### player.‹part›.squash { #part-squash }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.‹part›.squash</code> · <code>opponent.‹part›.squash</code> · <code>puppet[i].‹part›.squash</code> <span class="mf-eq">= <code>0</code></span></p>

Squash (positive) or stretch (negative), around its joint, volume kept.
