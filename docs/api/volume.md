---
icon: material/volume-high
---

# volume

The song's own audio: the instrumental and the two vocal tracks. Duck the music for a quiet moment, cut the opponent's
voice for a dramatic pause.

!!! info "How to use it"
    `volume` is always there. 0-1, on top of the player's own volume. Sounds a script plays have their own volume
    ([playSound](actions.md#playsound), [soundVolume](shortcuts.md#soundvolume)). More: [Sounds and music](../guides/sound.md).
    
    <p class="mf-like">Psych: <code>setProperty('vocals.volume', ...)</code>, <code>FlxG.sound.music.volume</code> · Kade: —</p>

## Example code

```lua
-- The music drops away for a bar, only the vocals stay.
function onEvent(p)
    tween(volume.inst, 0, beats(0.5))
    after(beats(4), function() tween(volume.inst, 1, beats(0.5)) end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [volume.inst](#volume-inst) | number | `1` | The instrumental. |
| [volume.player](#volume-player) | number | `1` | Your vocals - the track a miss mutes. |
| [volume.opponent](#volume-opponent) | number | `1` | The opponent's vocals. A single vocal track with both singers in it follows the louder of … |

---

### volume.inst { #volume-inst }

<p class="mf-sig"><span class="mf-type">number</span> <code>volume.inst</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The instrumental.

### volume.player { #volume-player }

<p class="mf-sig"><span class="mf-type">number</span> <code>volume.player</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Your vocals - the track a miss mutes.

### volume.opponent { #volume-opponent }

<p class="mf-sig"><span class="mf-type">number</span> <code>volume.opponent</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The opponent's vocals. A single vocal track with both singers in it follows the louder of the two.
