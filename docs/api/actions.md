---
icon: material/play-circle-outline
---

# Actions and timers

Actions *do* things: animate a property, run code later, put things back, play a sound. They're the building blocks
everything else is made of - even the [shortcuts](shortcuts.md) (`flash()`, `zoom()`, `flipScroll()`, ...) are just
ready-made actions for the common cases.

| Kind | Actions |
|---|---|
| Animate | [tween](#tween) · [approach](#approach) · [stopTween](#stoptween) |
| Later and again | [after](#after) · [every](#every) · [cancel](#cancel) |
| Put things back | [reset / resetAll](#reset) · [resetCamera](#resetcamera) · [resetPuppet](#resetpuppet) · [resetFx](#resetfx) · [resetWindow](#resetwindow) |
| The song | [scrollTo / scrollBy](#scrollto) · [countdown](#countdown) · [scatterStrums](#scatterstrums) |
| Sound | [playSound](#playsound) · [loopSound](#loopsound) |
| Debugging | [log / print](#log) |

**Durations** are milliseconds. Write them with `beats(2)`, `steps(4)`, `seconds(0.5)` or `ms(300)` -
`beats` and `steps` use the tempo at the moment of the call, so a song's tempo changes are taken care of.

---

## Animate

### tween

<p class="mf-sig"><code>tween(prop, to, duration[, ease])</code></p>

Animates a property from where it is now to `to`.

| | |
|---|---|
| `prop` | a number or colour [property](properties.md): `camera.zoom`, `strum[2].x`, `flash.color`, ... |
| `to` | where it ends up |
| `duration` | how long - `beats(2)`, `seconds(1)`; 0 = at once |
| `ease` | *optional* - how it moves, one of the [easing curves](#easing-curves) (default `"linear"`) |

```lua
tween(camera.zoom, 1.2, beats(2), "sineInOut")   -- zoom in over two beats
tween(flash.color, #FF0000, beats(1))             -- colours blend channel by channel
```

Setting the property directly stops a tween on it, and a new tween replaces the old one. Opacities stay
inside 0-1 even when an overshooting ease (`backOut`, `elasticOut`) swings past.

<p class="mf-like">Psych: <code>doTweenX</code>, <code>doTweenAlpha</code>, <code>doTweenZoom</code>, <code>noteTweenX</code>, <code>startTween</code> · Kade: <code>tweenPos</code>, <code>tweenAngle</code>, <code>tweenFadeIn</code></p>

### approach

<p class="mf-sig"><code>approach(prop, to, rate)</code></p>

Moves a property a share of the way toward `to` every 60th of a second - it follows a moving target smoothly, at
the same speed whatever the frame rate. `rate` is that share, 0-1 (0.05 = gentle, 0.3 = snappy).

```lua
function onFrame(dt)
    approach(hud.angle, player.combo > 50 ? 2 : 0, 0.05)   -- tilts while the combo is high
end
```

### stopTween

<p class="mf-sig"><code>stopTween(prop)</code></p>

Stops a tween right where it is. (`reset` would put the property back to its default instead.)

```lua
stopTween(camera.zoom)       -- the zoom stays where the tween had got to
```

<p class="mf-like">Psych: <code>cancelTween(tag)</code></p>

---

## Later and again

### after

<p class="mf-sig"><code>after(duration, function() ... end[, "name"])</code></p>

Runs the function that much later, in song time. It remembers every local as it was when you called
`after`, so each round of a loop keeps its own value:

```lua
function onEvent(p)
    for lane = 0, 3 do
        after(beats(lane * 0.5), function()
            tween(strum[lane].angle, 360, beats(1), "backOut")   -- one lane after the other
        end)
    end
end
```

With a name, [cancel](#cancel) can drop it before it runs.

<p class="mf-like">Psych: <code>runTimer(tag, seconds)</code> + <code>onTimerCompleted</code></p>

### every

<p class="mf-sig"><code>every(duration, function() ... end[, times][, "name"])</code></p>

Runs the function again and again, one duration apart - `times` times, or until the song ends. The first
run is one duration from now. Its locals stay from one run to the next, so a counter inside it counts on.

```lua
function onEvent(p)
    local ticks = 0

    every(beats(1), function()                -- 8 times, once a beat
        ticks += 1
        text[2].value = str(ticks)
    end, 8)

    every(beats(0.5), function()              -- until cancel("blink")
        strums.alpha = strums.alpha == 1 ? 0.6 : 1
    end, "blink")
end
```

It runs at most once a frame, however short the duration.

<p class="mf-like">Psych: <code>runTimer(tag, seconds, loops)</code></p>

### cancel

<p class="mf-sig"><code>cancel("name")</code></p>

Drops this event's waiting `after` / `every` calls with that name. Other events' timers aren't touched.

```lua
after(beats(16), function()
    cancel("blink")
    strums.alpha = 1
end)
```

<p class="mf-like">Psych: <code>cancelTimer(tag)</code></p>

---

## Put things back

### reset

<p class="mf-sig"><code>reset(what[, duration[, ease]])</code><br><code>resetAll([duration[, ease]])</code></p>

Puts things back to their defaults - at once, or eased over a duration (the [easing](choices.md#easing) defaults to
`"sineInOut"`). `what` is:

| `what` | Puts back |
|---|---|
| one property: `hud.angle`, `strum[2].x` | that property |
| a group: `hud`, `judgments`, `underlay`, `camera`, `fx`, `screen`, `flash`, `vignette`, `volume`, ... | every property of it (`camera` with the bump settings) |
| `strums` | the whole strumline and every lane |
| one slot: `strum[2]`, `text[0]`, `image[4]`, `shader[1]` | everything of that slot |
| `text`, `image`, `shader` | every slot |
| a fighter: `player`, `opponent`, `boyfriend`, `dad`, `puppet[i]` | like [resetPuppet](#resetpuppet) |
| a body part: `player.head` | that part |
| `window` | like [resetWindow](#resetwindow) |
| `popout[n]` | eases it home, then closes it |

`resetAll` puts back every property the scripts can write. Numbers and colours ease; texts and switches change at
once. A text, picture or shader reset over a duration fades out (alpha / amount to 0) and is cleared at the end -
unless a script writes to it meanwhile. Tweens on what's reset stop.

```lua
reset(hud.angle)                         -- at once
reset(hud, beats(1), "backOut")          -- the whole HUD, overshooting a little
reset(strum[2], beats(0.5))              -- one lane
reset(text[0], beats(1))                 -- fades out, then empty
resetAll(beats(2))                       -- everything, over two beats
```

The song's end resets the moving parts by itself - see [When the song ends](properties.md#when-the-song-ends).

<p class="mf-like">Psych: — (set every value back by hand) · Kade: —</p>

### resetCamera

<p class="mf-sig"><code>resetCamera([duration[, ease]])</code></p>

Puts the [fight camera](../guides/camera.md) back: at once, or gliding home over the duration. <span class="mf-tag fight">fights</span>

```lua
resetCamera(beats(2))
```

### resetPuppet

<p class="mf-sig"><code>resetPuppet(who[, duration[, ease]])</code></p>

Puts a [fighter](../guides/fighters.md) back - position, size, turn, tint, body parts: `"player"`, `"opponent"`,
`"both"`, or 0 / 1. <span class="mf-tag fight">fights</span>

```lua
resetPuppet("both", beats(1))
```

### resetFx

<p class="mf-sig"><code>resetFx([duration[, ease]])</code></p>

Switches the [effects](../guides/effects.md) and [shaders](../guides/shaders.md) off: at once, or fading out.

```lua
resetFx(beats(2))
```

### resetWindow

<p class="mf-sig"><code>resetWindow([duration[, ease]])</code></p>

Puts the [game window](../guides/windows.md) back and closes every pop-out: at once, or gliding home first.

```lua
resetWindow(beats(1))
```

---

## The song

### scrollTo

<p class="mf-sig"><code>scrollTo(speed[, duration])</code><br><code>scrollBy(factor[, duration])</code></p>

`scrollTo` sets the scroll speed (1 = the player's own); `scrollBy` multiplies the current one. In the
`"modern"` [scroll style](strums.md) notes are placed on the planned curve, so the changes are
worked out when the song starts.

```lua
scrollTo(1.5, beats(2))     -- 1.5x, eased in over two beats
scrollBy(0.5)               -- half of what it is now, at once
```

<p class="mf-like">Psych: the built-in "Change Scroll Speed" event · Kade: <code>scrollspeed</code></p>

### countdown

<p class="mf-sig"><code>countdown()</code></p>

Shows the 3-2-1-GO countdown over the running song - for a song that "starts again" after a break.

### scatterStrums

<p class="mf-sig"><code>scatterStrums([rate])</code></p>

Throws your four lanes to random spots that never overlap or leave the screen, easing there at `rate`
(default 0.7). [resetLanes](shortcuts.md#resetlanes) brings them home. Players find it hard to read - use it
sparingly, if at all.

---

## Sound

Sound files are `.ogg` files in the song's folder or its `events/` folder. More in
[Sounds and music](../guides/sound.md).

### playSound

<p class="mf-sig"><code>playSound(file[, volume[, "name"]])</code></p>

Plays a sound once. `volume` 0-1 (default 1), on top of MineFunkin's own volume. With a name
it can be [faded](shortcuts.md#soundvolume) and
[stopped](shortcuts.md#stopsound) later; a new sound under the same name replaces the one still playing.

```lua
playSound("cymbal.ogg", 0.7)
playSound("thunder.ogg", 1, "thunder")
```

<p class="mf-like">Psych: <code>playSound(file, volume, tag)</code></p>

### loopSound

<p class="mf-sig"><code>loopSound(file, volume, "name")</code></p>

Plays a sound over and over until `stopSound("name")` or the song's end. A loop always needs a name.

```lua
loopSound("rain.ogg", 0.6, "rain")
```

<p class="mf-like">Psych: <code>playSound</code> + <code>onSoundFinished</code> to start it again</p>

---

## Debugging

### log

<p class="mf-sig"><code>log(...)</code><br><code>print(...)</code></p>

Writes the values, joined with spaces, to the [event log](../help/troubleshooting.md#the-event-log)
(`logs/minefunkin-events.log`). The quickest way to find out what a script does. At most 200 lines per
event per run.

```lua
log("combo is", player.combo, "at", time)
```

<p class="mf-like">Psych: <code>debugPrint</code></p>

---

## Easing curves

| Family | In | Out | In and out |
|---|---|---|---|
| sine (gentle) | `sineIn` | `sineOut` | `sineInOut` |
| quad | `quadIn` | `quadOut` | `quadInOut` |
| cubic | `cubicIn` | `cubicOut` | `cubicInOut` |
| quart | `quartIn` | `quartOut` | `quartInOut` |
| expo (sharp) | `expoIn` | `expoOut` | |
| circ | `circIn` | `circOut` | |
| back (overshoots) | `backIn` | `backOut` | `backInOut` |
| elastic (springs) | | `elasticOut` | |
| bounce | | `bounceOut` | |

*In* starts slow and ends fast, *out* starts fast and settles - the usual pick for something that arrives.
`backOut`, `elasticOut` and `bounceOut` overshoot and settle: great for pops, squashes and landings.
`linear` keeps the same speed all the way.
