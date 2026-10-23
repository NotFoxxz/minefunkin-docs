---
icon: material/package-variant-closed
---

# Built-in events

These 21 come with MineFunkin, so every song can use them without bringing a single file. They're written in the
same language as yours - nothing special about them. Which means: if you don't like how one works, put a file with
the same name in your song's folder, and your song uses yours instead.

| Event | Category | Parameters (value1 / value2) |
|---|---|---|
| Add Camera Zoom | Camera | stage zoom (Psych's camGame - not used) / HUD zoom (default 0.03; the pops add up to 1.35 at most) |
| Beat Bump | Camera | custom bop on / every N beats, zoom |
| Screen Shake | Camera | duration (s), intensity / - |
| Set Camera Zoom | Camera | zoom / ease over (beats) |
| Countdown | HUD | - |
| Hide HUD (alias Goodbye Hud) | HUD | opacity / duration (s) |
| HUD Bounce | HUD | on / intensity, `OFF` = puppets stay still |
| Move Playfield | HUD | right px, down px / over (beats) |
| Note Scramble (alias Missingno) | Notes | ease rate / - |
| Note Scramble Reset | Notes | - |
| Note Wobble | Notes | on/off, unified/offset / speed, size (px) |
| Strum Fade | Notes | opacity / over (beats) |
| Lane Position ALL (alias LaneOrientationAll) | Scroll | down/up / - |
| Lane Position Single (alias LaneOrientationSingle) | Scroll | lane / down/up/toggle |
| Scroll Speed (aliases Change Scroll Speed, Change Scrollspeed) | Scroll | speed / duration (s), flags `classic`, `modern`, `multiplier` |
| Miss Flash | Screen | on / strength |
| Show Image | Screen | picture (.png) / show for (s), width, flag `back` |
| Vignette | Screen | strength / colour, fade (beats) |
| White Flash | Screen | duration (s) / colour |
| White Screen | Screen | on / colour, fade (s) |
| Lyrics | Text | text / show for (beats), colour |

The chart editor shows their names, descriptions and settings in the player's language (German too); charts and
scripts always use the English names above.

The built-in files are good starting points for your own. They are in the mod JAR under
`assets/minefunkin/events/`. Copy one into a song folder (it replaces the built-in for that song) and
change it there. For example, HUD Bounce:

```lua
format 1.1

event {
    name = "HUD Bounce",
    color = #7C6BFF,
    category = "HUD",
    description = "Rocks the HUD on every beat (in fights the camera rolls with it). Off stops it.",
}

params {
    bouncing  = switch { from = "value1", label = "On" },
    intensity = number { from = "value2.1", default = 1, min = 0, max = 5, step = 0.05, label = "Intensity" },
    still     = flag   { from = "value2", word = "OFF", label = "Keep puppets still" },
}

local active = false
local strength = 1
local lastBeat = nil

function onEvent(p)
    active = p.bouncing
    strength = p.intensity
    hud.extras = not p.still
end

-- Checked every frame, so it bounces at once when switched on.
function onFrame(dt)
    if not active or beat == lastBeat then return end
    lastBeat = beat

    local even = beat % 2 == 0
    hud.angle = (even ? 2.5 : -2.5) * strength
    tween(hud.angle, 0, beats(0.92), "backOut")
    camera.bump += (even ? 0.0195 : 0.0065) * strength
end
```
