---
icon: material/cube-outline
---

# build[n]

Eight stage builds: blocks around the fight that only the people in the song see. Build them in Minecraft and save
them with the structure block as a `.nbt` file in the song folder, or put single blocks with
[setBlock](shortcuts.md#setblock). Move, turn and fade them by song time - the real world never changes.

!!! info "How to use it"
    `build[0]` to `build[7]`. A build stands with its bottom middle at `x`, `y`, `z`, counted like the
    [stage mobs](mob.md): from the middle between the two fighters, `x` = to your right, `z` = toward the opponent.
    At most 48 blocks on each side, and at most 20 000 blocks on the whole stage.
    
    The structure block saves to `<world>/generated/minecraft/structures/<name>.nbt` - copy that file into the song
    folder (or its `events/` folder). Blocks with a block entity (chests, signs, banners) and liquids aren't drawn.
    
    Fights only, and in the fight's replays (around the replayed fighters). With [`stage.world`](stage.md) `"fighters"`
    or `"off"` they're gone with the world. A player can switch them off in Options › Song effects › "Minecraft effects".

## Example code

```lua
-- A gate behind the opponent that turns once and fades away at the end.
function onStart()
    build[0].file = "gate.nbt"
    build[0].z = 8
end

function onSection(n)
    if n == 4 then tween(build[0].turn, 360, beats(8)) end
    if n == 12 then tween(build[0].alpha, 0, beats(4)) end
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [build[n].file](#build-file) | text | `""` | A structure file (`.nbt`, saved with Minecraft's structure block) from the song folder. … |
| [build[n].x](#build-x) | number | `0` | Blocks to your right of the middle between the fighters (negative = to your left). |
| [build[n].y](#build-y) | number | `0` | Blocks up from the ground the fighters stand on. |
| [build[n].z](#build-z) | number | `0` | Blocks toward the opponent from the middle (negative = toward you). |
| [build[n].turn](#build-turn) | number | `0` | Turned around its middle, in degrees, clockwise seen from above. |
| [build[n].alpha](#build-alpha) | number | `1` | How solid it is: 1 = solid, 0 = gone. In between it's see-through. |
| [build[n].visible](#build-visible) | switch | `true` | false = hidden. |

---

### build[n].file { #build-file }

<p class="mf-sig"><span class="mf-type">text</span> <code>build[n].file</code> <span class="mf-eq">= <code>""</code></span></p>

A structure file (`.nbt`, saved with Minecraft's structure block) from the song folder. `""` = only the blocks
[setBlock](shortcuts.md#setblock) put into this build.

### build[n].x { #build-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>build[n].x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">-24 – 24</span><span class="mf-tag">blocks</span></p>

Blocks to your right of the middle between the fighters (negative = to your left).

### build[n].y { #build-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>build[n].y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">-24 – 24</span><span class="mf-tag">blocks</span></p>

Blocks up from the ground the fighters stand on.

### build[n].z { #build-z }

<p class="mf-sig"><span class="mf-type">number</span> <code>build[n].z</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">-24 – 24</span><span class="mf-tag">blocks</span></p>

Blocks toward the opponent from the middle (negative = toward you).

### build[n].turn { #build-turn }

<p class="mf-sig"><span class="mf-type">number</span> <code>build[n].turn</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

Turned around its middle, in degrees, clockwise seen from above.

### build[n].alpha { #build-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>build[n].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

How solid it is: 1 = solid, 0 = gone. In between it's see-through.

### build[n].visible { #build-visible }

<p class="mf-sig"><span class="mf-type">switch</span> <code>build[n].visible</code> <span class="mf-eq">= <code>true</code></span></p>

false = hidden.
