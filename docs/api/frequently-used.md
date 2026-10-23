---
icon: material/star-outline
---

# Frequently used

The handful of names almost every event is made of. Learn these and you can build most things - each one links to
its full entry.

## The skeleton of an event

```lua
format 1.1

event { name = "My Event" }

function onEvent(p)       -- the chart reaches the event
    flash()
end
```

| Name | |
|---|---|
| [`onEvent(p)`](callbacks.md#onevent) | the chart reaches this event - `p.value1`, `p.value2`, your [parameters](parameters.md) |
| [`onBeat(b)`](callbacks.md#onbeat) | every beat |
| [`onFrame(dt)`](callbacks.md#onframe) | every frame - for things that move all the time |
| [`onHit(note)`](callbacks.md#onhit) / [`onMiss(note)`](callbacks.md#onmiss) | you hit / missed a note |
| [`onStart()`](callbacks.md#onstart) | before the countdown - set things up, [`preload`](shortcuts.md#preload) pictures |

## Time

| Name | |
|---|---|
| [`beats(n)`, `steps(n)`, `seconds(n)`](functions.md#durations) | durations, at the song's tempo |
| [`time`, `beat`, `step`](functions.md#built-in-values) | where the song is right now |
| [`after(duration, function() ... end)`](actions.md#after) | later |
| [`every(duration, function() ... end)`](actions.md#every) | again and again |

## Making things move

| Name | |
|---|---|
| [`tween(prop, to, duration[, ease])`](actions.md#tween) | animate any number or colour - with an [easing curve](choices.md#easing) |
| [`reset(what[, duration[, ease]])`](actions.md#reset) | put it back |
| [`sin(x)`](functions.md#maths), [`lerp(a, b, t)`](functions.md#maths), [`clamp`](functions.md#maths) | for values worked out every frame |

## One-line effects

| Shortcut | |
|---|---|
| [`flash([colour])`](shortcuts.md#flash) | a flash |
| [`zoom(z[, duration])`](shortcuts.md#zoom) | zoom in, and stay |
| [`shake(strength)`](shortcuts.md#shake) | a short shake |
| [`flipScroll()`](shortcuts.md#flipscroll) | downscroll ↔ upscroll |
| [`hideHud()` / `showHud()`](shortcuts.md#hidehud) | the HUD out / in |
| [`focus(who)`](shortcuts.md#focus) | the fight camera leans toward someone |
| [`pose(who, name)`](shortcuts.md#pose) | a fighter strikes a pose |

## Properties

| Property | |
|---|---|
| [`camera.zoom`](camera.md#camera-zoom), [`camera.bump`](camera.md#camera-bump) | the zoom, the beat pop |
| [`hud.angle`](hud.md#hud-angle), [`hud.alpha`](hud.md#hud-alpha) | the HUD turned, faded |
| [`strum[lane].x`](strum.md#strum-x), [`strum[lane].alpha`](strum.md#strum-alpha) | one lane moved, faded |
| [`strums.x`](strums.md#strums-x), [`strums.alpha`](strums.md#strums-alpha) | the whole strumline |
| [`flash.alpha`](screen.md#flash-alpha), [`screen.alpha`](screen.md#screen-alpha) | colours over the picture |
| [`text[n].value`](text.md#text-value) | a text on the screen |
| [`image[n].file`](image.md#image-file) | a picture on the screen |
| [`player.squash`](fighters.md#squash), [`player.pose`](fighters.md#pose) | your fighter |
| [`fx.grayscale`](fx.md#fx-grayscale), [`fx.chromatic`](fx.md#fx-chromatic) | built-in effects |

## Reading the game

| Name | |
|---|---|
| [`player.health`](player.md#player-health), [`player.combo`](player.md#player-combo) | your run |
| [`song.singer`](song.md#song-singer) | who sings right now |
| [`song.mode`](song.md#song-mode) | practice, fight, replay or watching |
