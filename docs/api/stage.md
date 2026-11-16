---
icon: material/theater
---

# stage

What the people in the song see around the fight. The stage never changes the real world: the players standing around
see the world as always, and the song's end puts everything back.

!!! info "How to use it"
    Fights only - both fighters see it (each game runs the song's scripts), and so does whoever watches the fight from
    inside. Practice and replays aren't changed.
    
    Mobs around the fight are [mob[n]](mob.md). Stage particles come from the [particle](shortcuts.md#particle) shortcut, lightning from
    [lightning](shortcuts.md#lightning). A player can switch the sky, the weather and everything else a song does to
    Minecraft off in Options › Song effects › "Minecraft effects".

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
| [stage.dayTime](#stage-daytime) | number | `-1` | The time of day the people in the song see, in Minecraft's numbers: 1000 morning, 6000 … |
| [stage.weather](#stage-weather) | choice | `"world"` | `"world"` (the world's own), `"clear"`, `"rain"`, `"snow"` or `"thunder"`. A change fades … |
| [stage.fog](#stage-fog) | number | `0` | 0 = the world's own fog, 1 = so thick that only a few blocks show. |
| [stage.fogColor](#stage-fogcolor) | colour | `none` | The fog's colour, and the far sky's. Its alpha is how much: `#8090A0` = all of it, … |
| [stage.tint](#stage-tint) | colour | `#FFFFFF` | The whole world - the fighters too - washed in this colour, as strong as … |
| [stage.tintAlpha](#stage-tintalpha) | number | `0` | How strong `stage.tint` is: 0 = not at all, 1 = only the colour. |

---

### stage.world { #stage-world }

<p class="mf-sig"><span class="mf-type">choice</span> <code>stage.world</code> <span class="mf-eq">= <code>"on"</code></span></p>

The Minecraft world in a fight: `"on"` = as it is, `"fighters"` = no world, only the two fighters, `"off"` = none
at all. With `"fighters"` the fighters stand over MineFunkin's own background and the `"stage"` layer (drawn on the
screen then) - the fight camera, the beat bump and the hit nudge still move them; terrain, sky, mobs and other
players are gone. Off, the fight looks like practice: the song's pictures, the notes and the HUD over MineFunkin's own
background - no world, no fighters.

One of: `"on"`, `"fighters"`, `"off"`.

### stage.dayTime { #stage-daytime }

<p class="mf-sig"><span class="mf-type">number</span> <code>stage.dayTime</code> <span class="mf-eq">= <code>-1</code></span></p>
<p class="mf-tags"><span class="mf-tag">-1 – 24000</span></p>

The time of day the people in the song see, in Minecraft's numbers: 1000 morning, 6000 noon, 12000 sunset,
13000 night, 18000 midnight, 23000 sunrise. -1 = the world's own. Tween it for a sunset in a few beats - the
sky, the sun, the stars and the light all follow.

### stage.weather { #stage-weather }

<p class="mf-sig"><span class="mf-type">choice</span> <code>stage.weather</code> <span class="mf-eq">= <code>"world"</code></span></p>

`"world"` (the world's own), `"clear"`, `"rain"`, `"snow"` or `"thunder"`. A change fades in about a second.
Rain and snow fall wherever the fight is, even in a desert.

One of: `"world"`, `"clear"`, `"rain"`, `"snow"`, `"thunder"`.

### stage.fog { #stage-fog }

<p class="mf-sig"><span class="mf-type">number</span> <code>stage.fog</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

0 = the world's own fog, 1 = so thick that only a few blocks show.

### stage.fogColor { #stage-fogcolor }

<p class="mf-sig"><span class="mf-type">colour</span> <code>stage.fogColor</code> <span class="mf-eq">= <code>none</code></span></p>

The fog's colour, and the far sky's. Its alpha is how much: `#8090A0` = all of it, `#808090A0` = half. The
default (alpha 0) keeps the world's.

### stage.tint { #stage-tint }

<p class="mf-sig"><span class="mf-type">colour</span> <code>stage.tint</code> <span class="mf-eq">= <code>#FFFFFF</code></span></p>

The whole world - the fighters too - washed in this colour, as strong as `stage.tintAlpha` says.

### stage.tintAlpha { #stage-tintalpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>stage.tintAlpha</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

How strong `stage.tint` is: 0 = not at all, 1 = only the colour.
