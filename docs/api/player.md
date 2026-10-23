---
icon: material/scoreboard-outline
---

# player (your run)

How your run is going: score, combo, misses, accuracy, health. Read only - scores stay honest - but perfect for a combo
counter, or for making things wilder the better you play.

!!! info "How to use it"
    Read only. `player` is also your [fighter](fighters.md) - `player.x`, `player.pose`, ... are there.
    
    <p class="mf-like">Psych: <code>score</code>, <code>combo</code>, <code>misses</code>, <code>rating</code>, <code>health</code>, <code>downscroll</code> · Kade: —</p>

## Example code

```lua
-- The screen goes a little redder the lower your health is.
function onFrame(dt)
    screen.color = #FF0000
    screen.alpha = (1 - player.health) * 0.25
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [player.downscroll](#player-downscroll) | switch, read | `false` | The player's own scroll setting (true = downscroll). |
| [player.score](#player-score) | number, read | `0` | Your score. |
| [player.combo](#player-combo) | number, read | `0` | Notes hit in a row. |
| [player.misses](#player-misses) | number, read | `0` | Notes missed. |
| [player.accuracy](#player-accuracy) | number, read | `0` | 0-100. |
| [player.health](#player-health) | number, read | `1` | 0-1 - always 1 in practice, which has no health. Change it with [setHealth / … |

---

### player.downscroll { #player-downscroll }

<p class="mf-sig"><span class="mf-type">switch</span> <code>player.downscroll</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

The player's own scroll setting (true = downscroll).

### player.score { #player-score }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.score</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Your score.

### player.combo { #player-combo }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.combo</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Notes hit in a row.

### player.misses { #player-misses }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.misses</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Notes missed.

### player.accuracy { #player-accuracy }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.accuracy</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

0-100.

### player.health { #player-health }

<p class="mf-sig"><span class="mf-type">number</span> <code>player.health</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

0-1 - always 1 in practice, which has no health. Change it with [setHealth / addHealth](shortcuts.md#sethealth).
