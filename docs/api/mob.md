---
icon: material/sheep
---

# mob[n]

Sixteen stage mobs: Minecraft's mobs (or a mod's) standing around the fight, only for the people in the song. They
stand, look, walk, jump, fall over, explode or vanish when your script says so - nothing of them is real: no AI, no
sounds of their own, nobody is hurt, the world doesn't change.

!!! info "How to use it"
    `mob[0]` to `mob[15]`. Set `type` and where it stands; move it with [mobWalk](shortcuts.md#mobwalk) and play its
    actions with [mobAction](shortcuts.md#mobaction).
    
    Where it stands is counted from the middle between the two fighters, in blocks: `x` = to your right, `z` = toward
    the opponent (negative = toward you), `y` = up. Every player's game puts them where its own fight camera shows them
    well, so the mobs stand the same way around the fight for both fighters. At most 24 blocks out.
    
    Fights only - both fighters and whoever watches the fight from inside see them; practice and replays have no world.
    With [`stage.world`](stage.md) `"fighters"` or `"off"` they're gone with the world. A player can switch them off in
    Options › Song effects › "Minecraft effects".

## Example code

```lua
-- A zombie comes for the opponent in the drop and gets blown up.
function onStart()
    mob[0].type = "zombie"
    mob[0].x = 6
    mob[0].z = 4
end

function onSection(n)
    if n == 8 then mobWalk(0, "opponent", beats(4)) end
    if n == 9 then mobAction(0, "explode") end
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [mob[n].type](#mob-type) | text | `""` | Which mob: `"zombie"`, `"minecraft:pig"`, `"iron_golem"`, a mod's `"mymod:goblin"`. `""` … |
| [mob[n].x](#mob-x) | number | `0` | Blocks to your right of the middle between the fighters (negative = to your left). |
| [mob[n].y](#mob-y) | number | `0` | Blocks up from the ground the fighters stand on. |
| [mob[n].z](#mob-z) | number | `0` | Blocks toward the opponent from the middle (negative = toward you). |
| [mob[n].look](#mob-look) | choice | `"camera"` | Where it looks: `"camera"` (at you, through the screen), `"player"`, `"opponent"`, or … |
| [mob[n].turn](#mob-turn) | number | `0` | With `look = "none"`: its direction in degrees - 0 = facing you, 90 = facing to your … |
| [mob[n].scale](#mob-scale) | number | `1` | Its size: 1 = its own, 2 = twice as big (up to 4). |
| [mob[n].visible](#mob-visible) | switch | `true` | false = hidden (it stays where it is). |
| [mob[n].baby](#mob-baby) | switch | `false` | true = a baby of its kind, where the kind has babies (a zombie, a pig, a villager). |

---

### mob[n].type { #mob-type }

<p class="mf-sig"><span class="mf-type">text</span> <code>mob[n].type</code> <span class="mf-eq">= <code>""</code></span></p>

Which mob: `"zombie"`, `"minecraft:pig"`, `"iron_golem"`, a mod's `"mymod:goblin"`. `""` = none in this slot. A
name that isn't a mob is said once in the event log.

### mob[n].x { #mob-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>mob[n].x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">-24 – 24</span><span class="mf-tag">blocks</span></p>

Blocks to your right of the middle between the fighters (negative = to your left).

### mob[n].y { #mob-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>mob[n].y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">-24 – 24</span><span class="mf-tag">blocks</span></p>

Blocks up from the ground the fighters stand on.

### mob[n].z { #mob-z }

<p class="mf-sig"><span class="mf-type">number</span> <code>mob[n].z</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">-24 – 24</span><span class="mf-tag">blocks</span></p>

Blocks toward the opponent from the middle (negative = toward you).

### mob[n].look { #mob-look }

<p class="mf-sig"><span class="mf-type">choice</span> <code>mob[n].look</code> <span class="mf-eq">= <code>"camera"</code></span></p>

Where it looks: `"camera"` (at you, through the screen), `"player"`, `"opponent"`, or `"none"` - then `turn`
decides. While it walks it looks where it goes.

One of: `"camera"`, `"player"`, `"opponent"`, `"none"`.

### mob[n].turn { #mob-turn }

<p class="mf-sig"><span class="mf-type">number</span> <code>mob[n].turn</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

With `look = "none"`: its direction in degrees - 0 = facing you, 90 = facing to your right, 180 = facing the
opponent.

### mob[n].scale { #mob-scale }

<p class="mf-sig"><span class="mf-type">number</span> <code>mob[n].scale</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 4</span></p>

Its size: 1 = its own, 2 = twice as big (up to 4).

### mob[n].visible { #mob-visible }

<p class="mf-sig"><span class="mf-type">switch</span> <code>mob[n].visible</code> <span class="mf-eq">= <code>true</code></span></p>

false = hidden (it stays where it is).

### mob[n].baby { #mob-baby }

<p class="mf-sig"><span class="mf-type">switch</span> <code>mob[n].baby</code> <span class="mf-eq">= <code>false</code></span></p>

true = a baby of its kind, where the kind has babies (a zombie, a pig, a villager).
