---
icon: material/theater
---

# stage

What the people in the song see around the fight. The stage never changes the real world: the players standing around
see the world as always, and the song's end puts everything back.

!!! info "How to use it"
    Fights only - both fighters see it (each game runs the song's scripts), and so does whoever watches the fight from
    inside. Practice and replays aren't changed.
    
    Stage particles come from the [particle](shortcuts.md#particle) shortcut.

## Example code

```lua
-- The world goes away for the bridge, a picture takes its place.
function onSection(n)
    if n == 8 then
        image[0].file = "void.png"
        image[0].layer = "stage"
        stage.world = "off"
    elseif n == 12 then
        stage.world = "on"
        image[0].file = ""
    end
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [stage.world](#stage-world) | choice | `"on"` | The Minecraft world in a fight: `"on"` = as it is, `"fighters"` = no world, only the two … |

---

### stage.world { #stage-world }

<p class="mf-sig"><span class="mf-type">choice</span> <code>stage.world</code> <span class="mf-eq">= <code>"on"</code></span></p>

The Minecraft world in a fight: `"on"` = as it is, `"fighters"` = no world, only the two fighters, `"off"` = none
at all. With `"fighters"` the fighters stand over MineFunkin's own background and the `"stage"` layer (drawn on the
screen then) - the fight camera, the beat bump and the hit nudge still move them; terrain, sky, mobs and other
players are gone. Off, the fight looks like practice: the song's pictures, the notes and the HUD over MineFunkin's own
background - no world, no fighters.

One of: `"on"`, `"fighters"`, `"off"`.
