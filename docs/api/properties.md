---
icon: material/format-list-bulleted-type
---

# Properties

Almost everything you'll do in a script comes down to this: change a **property**. A property is a value with a
name, like `camera.zoom`, `strum[2].alpha` or `player.scale`. The game looks at all of them every frame, so the moment
you set one, the picture changes. Three things you can do with any of them:

```lua
camera.zoom = 1.2                                -- set it
tween(camera.zoom, 1, beats(2), "sineInOut")     -- animate it
reset(camera.zoom)                               -- put it back to its default
```

## Where to find what

| Group | Page |
|---|---|
| `camera.*` - zoom, beat pop, shake, the fight camera | [camera](camera.md) |
| `hud.*` - score line, title, hearts, bars, the playfield's angle and offset | [hud](hud.md) |
| `judgments.*` - the rating popups | [judgments](judgments.md) |
| `screen.*`, `flash.*`, `vignette.*` - colours over the picture | [screen, flash, vignette](screen.md) |
| `strums.*`, `scroll.*` - the whole strumline, the scroll, your keys | [strums](strums.md) |
| `strum[lane].*` - one lane, its way in and speed | [strum[lane]](strum.md) |
| `underlay.*` - the strum background | [underlay](underlay.md) |
| `notes.count`, `note[i].*` - every note on its way | [note[i]](notes.md) |
| `text[n].*` - eight texts | [text[n]](text.md) |
| `image[n].*` - 32 pictures, sheets, Psych sprites, videos | [image[n]](image.md) |
| `player.*`, `opponent.*`, `boyfriend.*`, `dad.*`, `puppet[i].*` - the fighters | [Fighters](fighters.md) |
| `player.head.*`, `.leftArm.*`, ... - body parts | [Body parts](parts.md) |
| `fx.*` - built-in effects | [fx](fx.md) |
| `shader[n].*` - the song's own shaders | [shader[n]](shader.md) |
| `volume.*` - the song's audio | [volume](volume.md) |
| `window.*`, `popout[n].*`, `monitor.*` - windows | [window](window.md), [popout[n]](popout.md), [monitor](monitor.md) |
| `song.*`, `player.score`, ... - the game's state (read only) | [song](song.md), [player (your run)](player.md) |

`strum[lane]` exists once per lane (0 left, 1 down, 2 up, 3 right), `text[n]` has 8 slots (0-7),
`image[n]` 32 (0-31), `shader[n]` 4, `popout[n]` 8, `puppet[i]` 2 (0 = you, 1 = the opponent), `note[i]`
up to 128 (as many as `notes.count` says).

## Kinds of properties

| Kind | Example | |
|---|---|---|
| number | `hud.angle = 15` | Can be tweened. Opacities (`*.alpha`) and volumes go from 0 to 1. |
| colour | `flash.color = #FF3040` | Written `#RRGGBB`. Can be tweened: colours blend channel by channel. |
| on / off | `player.visible = false` | `true` or `false`. |
| choice | `text[0].layer = "top"` | One of a few words, listed with the property. |
| text | `text[0].value = "GO!"` | |
| *read* | `player.combo` | Can only be read. |

A fixed value a property can't take (`strums.alpha = 5`, `text[0].layer = "middle"`) is an error as soon as the file
loads, so you catch it right away. A number worked out while the song runs is just kept inside the allowed range, and
the event log mentions it once.

## One thing at a time

The one rule worth remembering: a property holds just one value. Setting it stops a tween on it, and two scripts
writing it every frame overwrite each other - only the last one shows (the
[event log](../help/troubleshooting.md#the-event-log) names both). So give every effect that runs all the time its own
property. That's exactly why lanes have two offsets (`x` *and* `wobbleX`) and the camera has `zoom` *and* `bump`.

## When the song ends

You don't have to clean up after yourself - the moving parts go home on their own: the HUD, the zoom and shake, the
strumline and every lane, the strum background, the fight camera, the fighters (skins and the song's own poses
included), the audio volumes, the effects and shaders, the game window and the pop-out windows. Texts and pictures
disappear.

Some things are **kept** on purpose, because the results screen is drawn over them: the flash, screen and vignette
colours (a song can end on a cut to black), the beat bump's settings, `hud.extras`, `scroll.style`, and the layout of
texts, pictures and shaders. Every property page tags them *kept at the song's end*.

## Putting things back yourself

Mid-song, you often want things back *now*. [`reset`](actions.md#reset) puts a property, a group (`reset(hud)`), a
slot (`reset(strum[2])`) or a fighter back - at once, or eased: `reset(hud, beats(1), "backOut")`.
[`resetAll`](actions.md#reset) does everything at once.
