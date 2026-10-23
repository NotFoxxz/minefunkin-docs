---
icon: material/monitor-dashboard
---

# hud

Everything that isn't the notes: the score line, the song's title and time, the hearts of a fight, the cinematic bars - plus
the angle and offset of the whole playfield. Fade it out for a quiet moment, tilt it for a drop, move single pieces
out of the way of your stage art.

!!! info "How to use it"
    `hud` is always there. The whole HUD: `alpha`, `angle`, `x`, `y`. One piece: `scoreX` ... `healthScale`, each moved
    and sized around its own middle.
    
    Shortcuts: [hideHud / showHud](shortcuts.md#hidehud). The rating popups are [judgments](judgments.md), the strip
    behind the lanes is the [underlay](underlay.md).
    
    <p class="mf-like">Psych: <code>camHUD.alpha</code>, <code>camHUD.angle</code>, <code>scoreTxt.visible</code>, <code>skipCountdown</code> · Kade: <code>camHudAngle</code>, <code>showOnlyStrums</code></p>

## Example code

```lua
-- A tilted HUD for a section, the score line moved to the top left and bigger.
tween(hud.angle, 8, beats(2), "backOut")
hud.scoreX = -260
hud.scoreY = -200
hud.scoreScale = 1.4
after(beats(16), function() reset(hud, beats(1), "sineInOut") end)
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [hud.angle](#hud-angle) | number | `0` | The whole playfield turned, in degrees (clockwise). In fights the world camera rolls with … |
| [hud.alpha](#hud-alpha) | number | `1` | The whole HUD's opacity: score line, title, hearts. |
| [hud.extras](#hud-extras) | switch | `true` | Whether the puppets, the opponent's receptors and the judgments turn along with … |
| [hud.countdown](#hud-countdown) | switch | `true` | Whether the song's start shows the 3-2-1-GO and plays its sounds. false = the music … |
| [hud.x](#hud-x) | number | `0` | The whole playfield moved to the right, in pixels. |
| [hud.y](#hud-y) | number | `0` | The whole playfield moved down, in pixels. |
| [hud.scoreAlpha](#hud-scorealpha) | number | `1` | Only the score line's opacity. |
| [hud.titleAlpha](#hud-titlealpha) | number | `1` | Only the song title's and the time's opacity. |
| [hud.healthAlpha](#hud-healthalpha) | number | `1` | Only the hearts' opacity (fights). |
| [hud.scoreX](#hud-scorex) | number | `0` | The score line moved to the right, in pixels - on top of `hud.x`. |
| [hud.scoreY](#hud-scorey) | number | `0` | The score line moved down, in pixels. |
| [hud.scoreScale](#hud-scorescale) | number | `1` | The score line's size, around its own middle. 0 = gone. |
| [hud.titleX](#hud-titlex) | number | `0` | The title line moved to the right, in pixels. |
| [hud.titleY](#hud-titley) | number | `0` | The title line moved down, in pixels. |
| [hud.titleScale](#hud-titlescale) | number | `1` | The title line's size, around its own middle. |
| [hud.healthX](#hud-healthx) | number | `0` | The hearts moved to the right, in pixels. |
| [hud.healthY](#hud-healthy) | number | `0` | The hearts moved down, in pixels. |
| [hud.healthScale](#hud-healthscale) | number | `1` | The hearts' size, around their own middle. |
| [hud.bars](#hud-bars) | number | `1` | The black cinematic bars of a fight: 0 = gone, 1 = as usual, 2 = twice as high. Practice … |

---

### hud.angle { #hud-angle }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.angle</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">degrees</span></p>

The whole playfield turned, in degrees (clockwise). In fights the world camera rolls with it.

### hud.alpha { #hud-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The whole HUD's opacity: score line, title, hearts.

### hud.extras { #hud-extras }

<p class="mf-sig"><span class="mf-type">switch</span> <code>hud.extras</code> <span class="mf-eq">= <code>true</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

Whether the puppets, the opponent's receptors and the judgments turn along with `hud.angle`. false = only your
lanes turn.

### hud.countdown { #hud-countdown }

<p class="mf-sig"><span class="mf-type">switch</span> <code>hud.countdown</code> <span class="mf-eq">= <code>true</code></span></p>

Whether the song's start shows the 3-2-1-GO and plays its sounds. false = the music starts without it -
[onCountdown](callbacks.md#oncountdown) is still called, so a script can show its own.

!!! info "Note"
    Set it in `onStart` - the countdown starts right after.

```lua
function onStart()
    hud.countdown = false
end
```

### hud.x { #hud-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.x</code> <span class="mf-eq">= <code>0</code></span></p>

The whole playfield moved to the right, in pixels.

### hud.y { #hud-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.y</code> <span class="mf-eq">= <code>0</code></span></p>

The whole playfield moved down, in pixels.

### hud.scoreAlpha { #hud-scorealpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.scoreAlpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Only the score line's opacity.

### hud.titleAlpha { #hud-titlealpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.titleAlpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Only the song title's and the time's opacity.

### hud.healthAlpha { #hud-healthalpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.healthAlpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Only the hearts' opacity (fights).

### hud.scoreX { #hud-scorex }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.scoreX</code> <span class="mf-eq">= <code>0</code></span></p>

The score line moved to the right, in pixels - on top of `hud.x`.

### hud.scoreY { #hud-scorey }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.scoreY</code> <span class="mf-eq">= <code>0</code></span></p>

The score line moved down, in pixels.

### hud.scoreScale { #hud-scorescale }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.scoreScale</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 10</span></p>

The score line's size, around its own middle. 0 = gone.

### hud.titleX { #hud-titlex }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.titleX</code> <span class="mf-eq">= <code>0</code></span></p>

The title line moved to the right, in pixels.

### hud.titleY { #hud-titley }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.titleY</code> <span class="mf-eq">= <code>0</code></span></p>

The title line moved down, in pixels.

### hud.titleScale { #hud-titlescale }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.titleScale</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 10</span></p>

The title line's size, around its own middle.

### hud.healthX { #hud-healthx }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.healthX</code> <span class="mf-eq">= <code>0</code></span></p>

The hearts moved to the right, in pixels.

### hud.healthY { #hud-healthy }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.healthY</code> <span class="mf-eq">= <code>0</code></span></p>

The hearts moved down, in pixels.

### hud.healthScale { #hud-healthscale }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.healthScale</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 10</span></p>

The hearts' size, around their own middle.

### hud.bars { #hud-bars }

<p class="mf-sig"><span class="mf-type">number</span> <code>hud.bars</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 3</span><span class="mf-tag fight">fights only</span></p>

The black cinematic bars of a fight: 0 = gone, 1 = as usual, 2 = twice as high. Practice has none.
