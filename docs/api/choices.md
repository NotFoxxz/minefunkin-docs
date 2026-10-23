---
icon: material/format-list-checks
---

# Choices

Some properties and actions take one of a few fixed words - a layer, an easing curve, a pose. They're all on this
page, one list each, so you can see what every word actually does.

Don't worry about typos: a word a property can't take is an error as soon as the file loads, with a guess at what you
meant: `text[0].layer = "frnot"` → *unknown layer "frnot" - did you mean "front"?*

## Easing curves { #easing }

How a value moves from where it is to where it's going.

!!! info "How to use it"
    The last argument of [`tween`](actions.md#tween), [`reset` / `resetAll`](actions.md#reset), the reset
    actions and most [shortcuts](shortcuts.md) that take a duration. Left out = `"linear"` (`tween`) or
    `"sineInOut"` (the resets). Case doesn't matter.

```lua
tween(camera.zoom, 1.2, beats(2), "sineInOut")   -- smooth in and out
tween(player.squash, 0, beats(1), "elasticOut")  -- lands like jelly
reset(hud, beats(1), "backOut")                  -- overshoots a little on the way home
```

| Family | In | Out | In and out |
|---|---|---|---|
| linear | `linear` | | |
| sine (gentle) | `sineIn` | `sineOut` | `sineInOut` |
| quad | `quadIn` | `quadOut` | `quadInOut` |
| cubic | `cubicIn` | `cubicOut` | `cubicInOut` |
| quart | `quartIn` | `quartOut` | `quartInOut` |
| quint | `quintIn` | `quintOut` | `quintInOut` |
| expo (sharp) | `expoIn` | `expoOut` | `expoInOut` |
| circ | `circIn` | `circOut` | `circInOut` |
| back (overshoots) | `backIn` | `backOut` | `backInOut` |
| elastic (springs) | `elasticIn` | `elasticOut` | `elasticInOut` |
| bounce | `bounceIn` | `bounceOut` | `bounceInOut` |

*In* starts slow and ends fast, *out* starts fast and settles - the usual pick for something that arrives.
`backOut`, `elasticOut` and `bounceOut` overshoot and settle: good for pops, squashes and landings. Opacities and
volumes stay inside 0-1 even while an overshooting curve swings past.

**For [modifiers](modifiers.md)** ([`ease`](shortcuts.md#ease), [`add`](shortcuts.md#add)) the same names
work, plus `"instant"` (there at once) and `"arc"` (out to the value and back).

<p class="mf-like">Psych: <code>'sineInOut'</code> etc. (the same names as Flixel's FlxEase) · Kade: <code>FlxEase</code></p>

## Layers { #layers }

Where a text or picture is drawn, from the bottom up.

!!! info "How to use it"
    [`text[n].layer`](text.md#text-layer) and [`image[n].layer`](image.md#image-layer). Within a layer,
    `order` decides: higher is drawn later, so on top. Texts and pictures share it; with the same order, pictures
    come before texts and lower slots before higher ones.

```lua
image[1].file  = "logo.png"
image[1].layer = "lanes"    -- behind the notes, in front of the strum background
text[0].layer  = "top"      -- stays visible while the screen fades to black
text[0].order  = 2
```

| Layer | Drawn |
|---|---|
| `"stage"` | Pictures only. In a fight painted **onto the world**, right before the fighters - a stage's background and its sprites (use [`follow`](image.md#image-follow) so they stay on the world while the camera moves). In practice it's under the puppets. |
| `"back"` | Behind the [strum background](underlay.md) - under everything that belongs to the playfield. |
| `"lanes"` | On the strum background, under the receptors and notes. |
| `"front"` | Over the playfield and the HUD (the default). |
| `"top"` | Over everything, even the [flash and screen colours](screen.md) - a line stays readable over a cut to black. |

The vignette sits between the playfield and `"front"`, so captions stay readable while it darkens the edges.
Texts and pictures stay put on the screen: the bump, shake and HUD rotation don't move them (a picture with
`follow` moves with the fight camera instead).

<p class="mf-like">Psych: <code>addLuaSprite(tag, front)</code>, <code>setObjectOrder</code>, <code>setObjectCamera</code></p>

## Blend modes { #blend-modes }

How a picture is laid over what's under it.

!!! info "How to use it"
    [`image[n].blend`](image.md#image-blend). The default is `"normal"`.

```lua
image[3].file = "glow.png"
image[3].blend = "add"        -- a glow: only brightens
image[4].file = "shadow.png"
image[4].blend = "multiply"   -- a shadow or a tint: only darkens
```

| Mode | What it does |
|---|---|
| `"normal"` | Painted over, by its alpha. |
| `"add"` | Its colours are added - light, glows, sparks, fire. Black disappears. |
| `"multiply"` | Multiplied - darkens and tints. White disappears. |
| `"screen"` | The opposite of multiply - lightens softly. Black disappears. |
| `"erase"` | Wipes out what's under it where it's opaque. In [desktop mode](window.md#window-transparent) that's a hole to the desktop. |
| `"key"` | In desktop mode its exact #131313 pixels become holes to the desktop; the rest is drawn normally. Outside desktop mode it's a normal picture. |

<p class="mf-like">Psych: <code>setBlendMode(tag, 'add')</code></p>

## Fonts { #fonts }

Minecraft's own fonts for [`text[n].font`](text.md#text-font).

!!! info "How to use it"
    Set `text[n].font`. The default is `"default"`. A resource pack that changes a font changes it here too.

```lua
text[2].value = "the end is near"
text[2].font = "alt"    -- enchanting table runes
```

| Font | |
|---|---|
| `"default"` | Minecraft's pixel font. |
| `"uniform"` | The smooth Unicode font. |
| `"alt"` | The enchanting table's runes (Standard Galactic). |
| `"illager"` | The illagers' runes. |

<p class="mf-like">Psych: <code>setTextFont(tag, 'vcr.ttf')</code> - MineFunkin can't load font files; use these.</p>

## Poses { #poses }

MineFunkin's own poses for a fighter - the ones the notes play.

!!! info "How to use it"
    [`player.pose`](fighters.md#pose) (or the shortcut [`pose(who, name)`](shortcuts.md#pose)) plays one;
    [`setPose(who, name, ...)`](shortcuts.md#setpose) replaces one with a pose of your own for the rest of the
    song.

```lua
-- The opponent "sings" a chord with you, then drops.
opponent.pose = "left"
after(beats(1), function() opponent.pose = "right" end)
after(beats(2), function() opponent.pose = "death" end)
after(beats(6), function() opponent.pose = "none" end)
```

| Pose | |
|---|---|
| `"left"`, `"down"`, `"up"`, `"right"` | The note pose of that lane: pops at the moment it's set and holds, like a held note. Changing straight to another lane pops the new one. |
| `"death"` | The death: the fighter jolts back and sits down, and stays down. |
| `"none"` | Lets go: a held pose eases out like a released note, the death ends. The notes decide again. |
| `"idle"` | Only for [`setPose`](shortcuts.md#setpose): the rest pose the idle bob plays around. |

"Left" and "right" keep their direction on the screen: seen from behind (your fighter) or from the front (the
opponent), a `"left"` pose leans to the screen's left.

## Fighter names { #fighter-names }

How an action or shortcut is told which fighter you mean.

!!! info "How to use it"
    The `who` argument of [`pose`](shortcuts.md#pose), [`setPose` / `clearPose`](shortcuts.md#setpose),
    [`setSkin`](shortcuts.md#setskin), [`setModel`](shortcuts.md#setmodel), [`focus`](shortcuts.md#focus),
    [`bind` / `unbind`](shortcuts.md#bind), [`resetPuppet`](actions.md#resetpuppet),
    [`atPlace`](functions.md#atplace). As properties, the same names are the [Fighters](fighters.md):
    `player.x`, `dad.alpha`, `puppet[1].pose`.

```lua
pose("dad", "up")              -- whoever plays the opponent part
setSkin("both", "skins/bf.png")
resetPuppet(1, beats(1))       -- puppet[1] = the opponent
```

| Name | Who |
|---|---|
| `"player"` or `0` | You. |
| `"opponent"` or `1` | The other fighter. |
| `"boyfriend"` | Whoever plays the chart's Boyfriend part (the player side) - you, unless you play the opponent side. |
| `"dad"` | Whoever plays the chart's opponent part. |
| `"both"` | Both at once - for `pose`, `setPose`, `clearPose`, `setSkin`, `setModel`, `resetPuppet`. |
| `"center"` | Only for [`focus`](shortcuts.md#focus): the camera's middle between the two. |

Use `boyfriend` / `dad` when an effect belongs to a **part of the chart** (Boyfriend's solo), `player` /
`opponent` when it belongs to **you** (your own camera, your fighter in front). [`song.side`](song.md#song-side)
says which side you play.

## Effect targets { #effect-targets }

What an effect covers.

!!! info "How to use it"
    [`fx.target`](fx.md#fx-target) for the built-in effects, [`shader[n].target`](shader.md#shader-target)
    for each of the song's own shaders. The default is `"screen"`.

```lua
fx.target = "world"   -- the notes and the HUD stay sharp
fx.pixelate = 8
```

| Target | What gets the effect |
|---|---|
| `"screen"` | Everything: the world, the HUD, the strumline, your texts and pictures. |
| `"world"` | Only the world - the notes and the HUD stay sharp, so even a heavy effect stays playable. Fights only. |
| `"terrain"` | The world **without the two fighters**: everything around them changes, they stay as they are. Fights only. |

Practice (the Retro TV) has no world, so `"world"` and `"terrain"` do nothing there; a shader's
[`status`](shader.md#shader-status) says `"fight only"`. They run in the order terrain, world, screen.

## Scroll directions { #scroll-directions }

Which way the notes travel.

!!! info "How to use it"
    [`strums.scroll`](strums.md#strums-scroll) for every lane, [`strum[lane].scroll`](strum.md#strum-scroll)
    for one, or the shortcuts [`setScroll`](shortcuts.md#setscroll) and [`flipScroll`](shortcuts.md#flipscroll).

```lua
setScroll("down")      -- every lane
strum[0].scroll = "up" -- only the left lane goes up
```

| Direction | |
|---|---|
| `"auto"` | As the player has set it (`player.downscroll`). For one lane: follow `strums.scroll`. |
| `"up"` | Notes rise to receptors at the top. |
| `"down"` | Notes fall to receptors at the bottom. |

[`strum[lane].isDown`](strum.md#strum-isdown) says what a lane really does right now. For other angles (notes
from the side) use [`strum[lane].direction`](strum.md#strum-direction).

## Pop-out parts { #popout-parts }

What a pop-out window can show.

!!! info "How to use it"
    [`popout[n].show`](popout.md#popout-show): one or more parts, separated by commas, spaces or `+`. A part that
    is in a pop-out leaves the game window (unless [`keep`](popout.md#popout-keep) is on). Case doesn't matter.

```lua
popout[0].show = "player"
popout[1].show = "left, right"
popout[2].show = "score + health"
```

| Part | |
|---|---|
| `"player"`, `"opponent"` | A fighter: in a fight the fighter from the world, in practice its puppet. |
| `"strums"` | All four of your lanes. |
| `"left"`, `"down"`, `"up"`, `"right"` | One lane (also `"lane0"` ... `"lane3"`). |
| `"opponentStrums"` | The opponent's receptors (practice). |
| `"judgments"` | The rating popups. |
| `"score"`, `"title"`, `"health"` | One piece of the HUD. |
| `"hud"` | The whole HUD. |
| `"text0"` ... `"text7"` | A [text](text.md). |
| `"image0"` ... `"image31"` | A [picture](image.md). |
