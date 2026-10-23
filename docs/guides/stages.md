---
icon: material/image-filter-hdr
---

# Stages and sprites

In a fight, the two fighters stand in the actual Minecraft world - which is great, until your song is set in
a burning city and the fight happens in a birch forest. That's what a **stage** is for: pictures around the
fighters. A sky behind them, animated fire, dust drifting in front of them, a logo glowing under the lanes.

There's no special stage file. A stage is just a [song script](song-scripts.md) that sets up a few
[pictures](../api/image.md) in `onStart`.

<span class="mf-tag fight">fights</span> The world, the fight camera and the `"stage"` layer behind the fighters
only exist in a fight. In practice at the Retro TV, the same pictures are drawn under the two puppets - so your stage
still shows up there, it just doesn't move with a camera.

## Start with this

```lua
format 1.1
-- The song's stage: a background behind the fighters, fog in front of them.

event {
    name = "Stage",
    category = "Song script",
    description = "Sets up the song's stage pictures.",
}

function onStart()
    preload("stage/sky.png")
    preload("stage/fog.png")

    -- Behind the fighters, moving with the camera like the world.
    image[0].file = "stage/sky.png"
    image[0].layer = "stage"
    image[0].width = 1.5          -- bigger than the screen, so the camera's turns never show its edges
    image[0].height = 1.5
    image[0].follow = 1

    -- In front of the fighters, under the lanes and the HUD.
    image[1].file = "stage/fog.png"
    image[1].layer = "back"
    image[1].width = 1
    image[1].height = 1
    image[1].alpha = 0.5
end
```

Put the pictures in the song's folder (here in a `stage/` folder inside it), save the script as `stage.event` next
to the chart, and start a fight. That's a stage.

## Where a picture goes: layers

Every picture sits on a **layer**, which decides what it's in front of and what it's behind:

| Layer | In a fight | Good for |
|---|---|---|
| `"stage"` | painted onto the world, **behind the fighters** | the background, the sky, a floor, sprites behind the characters |
| `"back"` | in front of the fighters, behind the strum background | fog, rain, bars, things in front of the characters |
| `"lanes"` | on the strum background, under the notes | a logo, a glow behind the lanes |
| `"front"` | over the playfield and the HUD | flashes of pictures, captions |
| `"top"` | over everything, even a fade to black | a title that stays readable |

Inside one layer, `order` sorts them: higher numbers are drawn later, so they end up on top.

```lua
image[2].layer = "stage"
image[2].order = 1           -- in front of image[0] (order 0), still behind the fighters
```

## Moving with the camera

Normally a picture stays exactly where you put it on the screen. But in a fight the camera never sits still: it
turns towards whoever's singing, nudges a little on each of your hits and pops on the beat - and the fighters move
with it. A background that stays put would look like the fighters are sliding around on top of it. (It looks as bad
as it sounds.)

`follow = 1` fixes that: the picture moves with the camera exactly like the world does.

- `x`, `y`, `width` and `height` say where it sits while the camera rests (no turn, no zoom).
- Values between 0 and 1 move it part of the way - like a scroll factor in Psych: `0.5` for far mountains
  that move half as much.
- Only the camera's turns and zoom are followed, not `camera.x` / `.y` / `.z` - a picture has no depth.
- A [pinned fighter](fighters.md#pinned-to-the-screen) stays on its screen spot whatever the camera does: a
  picture behind a pinned fighter keeps `follow = 0`, or they drift apart.
- In practice there's no fight camera: `follow` does nothing there.

## Animated pictures

Animated backgrounds - fire, TV static, dust, a crowd bopping along - come as sheets of frames. MineFunkin
plays both kinds you'll run into.

### A grid of frames (sprite sheet)

All frames are the same size and sit in a neat grid. Tell MineFunkin how the grid is cut and how fast to play it:

```lua
function onStart()
    image[3].file = "fire.png"      -- 4 frames across, 5 down, 20 of them used
    image[3].columns = 4
    image[3].rows = 5
    image[3].frames = 20
    image[3].fps = 24               -- plays by itself, over and over
    image[3].width = 1
    image[3].height = 1
    image[3].layer = "stage"

    image[4].file = "bars.png"      -- a one-shot animation ...
    image[4].columns = 4
    image[4].rows = 3
    image[4].fps = 24
    image[4].loop = false
end

function onBeat(b)
    image[4].frame = 0              -- ... that plays again on every beat
end
```

### Psych sprites (Sparrow atlases)

This is what Psych uses: a `.png` plus a Sparrow `.xml` of the same name. The frames are packed wherever they fit,
trimmed, and sometimes turned on their side - you don't have to care about any of that. Put both files in the song's
folder and name the animation you want:

```lua
format 1.1

event { name = "Dancing Crowd" }

function onStart()
    image[2].file = "crowd.png"          -- crowd.xml must sit right next to it
    image[2].anim = "crowd bop"          -- every frame whose name starts with this
    image[2].fps = 24
    image[2].width = 0.6
    image[2].y = 0.8
    image[2].layer = "stage"
end

function onHit(n)
    if n.judgment == "sick" then
        image[2].anim = "crowd cheer"    -- another animation of the same sprite
        image[2].frame = 0
        image[2].loop = false
    end
end
```

- The frames play in the order of the number at the end of their names (`crowd bop0000`, `crowd bop0001`,
  ...), like Psych's `addAnimationByPrefix`.
- `frame`, `fps` and `loop` work as for a sheet. Set `frame = 0` to start an animation over.
- `width` and `height` measure the frame's full box, so trimmed frames don't jump around; frames stored turned
  on their side are turned back.
- `flipX` mirrors it - one sprite facing either way.
- An `.xml` may be at most 2 MB with at most 4096 frames.

### Videos

Got a cutscene or a video background? It goes in as a **folder of numbered frames**: `videos/intro/0001.jpg`,
`0002.jpg`, ... (`.jpg` or `.png`). Name the folder with a `/` at the end and play it just like a sheet:

```lua
function onEvent(p)
    image[24].file = "videos/intro/"
    image[24].width = 1
    image[24].height = 1
    image[24].layer = "top"
    image[24].fps = 15
    image[24].loop = false
    image[24].frame = 0
end
```

Any video tool can cut a video into frames like that. With ffmpeg it's one line:
`ffmpeg -i intro.mp4 -vf fps=15,scale=820:-1 videos/intro/%04d.jpg`. MineFunkin only decodes frames right before
they're needed and lets go of the ones it has shown, so even a long video won't eat your memory.

The frames have no sound. Either mix the video's sound into the song's audio, or start it with
[playSound](../api/actions.md#playsound). And during a cutscene, [`strums.input = false`](../api/strums.md#strums-input)
stops the player's keys from doing anything.

## Blend modes

By default a picture is simply painted over what's under it. `image[n].blend` mixes it in other ways: `"add"` for
light, fire and glows, `"multiply"` for shadows and tints, `"screen"` to brighten softly, `"erase"` to cut holes. All
of them are on [blend modes](../api/choices.md#blend-modes).

```lua
image[7].file = "stage/light.png"
image[7].blend = "add"
image[7].layer = "stage"
image[7].follow = 1
```

## Sharp or smooth

Pictures are drawn with **sharp pixels** by default, like the rest of the game. Pixel art stays crisp, and
sprites with see-through edges don't get weird coloured rims. Big painted art that's shown smaller or turned looks
nicer smoothed, though: `image[n].smooth = true` (that's Psych's `antialiasing`).

## Plain boxes

Sometimes you don't need a picture at all, just a coloured box. `"solid"` is a white box you colour yourself - for
bars, a curtain, a coloured sky, a floor:

```lua
format 1.1

event { name = "Red Curtain" }

function onEvent(p)
    image[6].file = "solid"
    image[6].color = #B01030
    image[6].width = 1             -- the whole width ...
    image[6].height = 1            -- ... and height
    image[6].layer = "back"
    image[6].alpha = 0
    tween(image[6].alpha, 0.8, beats(2))
end
```

## Loading on time

A picture loads in the background the first time it's drawn, and appears once it's ready - for a big one, that can
be a few frames late. Usually nobody notices, but on a big moment you will. So [preload](../api/shortcuts.md#preload)
whatever the stage shows later in `onStart`, and it loads during the countdown instead.

```lua
function onStart()
    preload("stage/fire.png")
    preload("stage/night.png")
end
```

## Coming from a Psych stage

A Psych stage is a `stages/name.json` (camera zoom, character spots) plus a `stages/name.lua` that makes the
sprites. Good news: the Lua part translates almost line by line.

| Psych stage Lua | MineFunkin |
|---|---|
| `makeLuaSprite("sky", "sky", x, y)` | `image[0].file = "sky.png"` and `x` / `y` as a **share of the screen** (0.5 = the middle), not world pixels |
| `makeAnimatedLuaSprite` + `addAnimationByPrefix` + `playAnim` | `image[n].file` (+ the `.xml`), `image[n].anim = "prefix"`, `image[n].frame = 0` |
| `makeGraphic("black", w, h, "000000")` | `image[n].file = "solid"`, `image[n].color = #000000` |
| `scaleObject("sky", 1.2, 1.2)` | `image[n].width` / `image[n].height` |
| `setScrollFactor("sky", 0.5, 0.5)` | `image[n].follow = 0.5` (one number for both directions) |
| `addLuaSprite("sky", false)` (behind the characters) | `image[n].layer = "stage"` |
| `addLuaSprite("fog", true)` (in front of them) | `image[n].layer = "back"` |
| `setObjectOrder` | `image[n].order` |
| `setProperty("sky.visible", false)` | `image[n].alpha = 0` (or `file = ""`) |
| `setProperty("sky.flipX", true)` | `image[n].flipX = true` |
| `precacheImage("sky")` | `preload("sky.png")` |
| `defaultCamZoom` in the json | `camera.zoom` / `camera.fov` - see [the fight camera](camera.md) |

The characters are the real Minecraft fighters, so character spots and character jsons have nothing to translate
to - the fighters stand where the Speaker puts them. If you want them somewhere else, or looking like someone else,
[the fighters](fighters.md) page shows you how to move, pin and re-skin them.

## Limits

You have room for a lot - 32 pictures at once (`image[0]` ... `image[31]`) and up to 128 different picture files per song: `.png`, at most
8192 pixels a side and 16 MB as a file, 512 MB of video memory together. A video folder: up to 20,000 `.jpg` /
`.png` frames, 2048 pixels a side, 8 MB a frame. Everything is freed when the song closes.
