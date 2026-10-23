---
icon: material/dock-window
---

# popout[n]

Extra windows that show pieces of the game - your lanes, a fighter, the score - anywhere on the screen. Borderless,
see-through, always on top.

!!! info "How to use it"
    `popout[0]` to `popout[7]` - set `show` to a list of [parts](choices.md#popout-parts) and the window opens,
    `""` closes it. A part shown in a pop-out leaves the game window (unless `keep`). Pop-outs need a system that lets
    programs place windows (not Wayland) and the player's OK (Options › MineFunkin › Window & desktop).
    
    The whole picture: [Game window and pop-outs](../guides/windows.md).

## Example code

```lua
-- Your fighter jumps out of the game, onto the desktop next to it.
function onEvent(p)
    popout[0].show = "player"
    tween(popout[0].x, -400, beats(2), "backOut")
    after(beats(8), function() reset(popout[0], beats(1)) end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [popout[n].show](#popout-show) | text | `""` | What it shows: one or more [parts](choices.md#popout-parts), separated by commas - … |
| [popout[n].x](#popout-x) | number | `0` | Moved to the right from its home (where its parts are in the game window), in screen … |
| [popout[n].y](#popout-y) | number | `0` | Moved down from its home, in screen pixels. |
| [popout[n].width](#popout-width) | number | `0` | Its width in pixels; 0 = just big enough for its parts. |
| [popout[n].height](#popout-height) | number | `0` | Its height in pixels; 0 = just big enough for its parts. |
| [popout[n].zoom](#popout-zoom) | number | `1` | How big its parts are drawn (1 = as big as in the game window). |
| [popout[n].cropX](#popout-cropx) | number | `0` | What it looks at, moved from its parts' middle to the right, in the pop-out's own pixels … |
| [popout[n].cropY](#popout-cropy) | number | `0` | The same downwards. |
| [popout[n].alpha](#popout-alpha) | number | `1` | Its opacity (0 = hidden). |
| [popout[n].keep](#popout-keep) | switch | `false` | true = its parts stay in the game window too (a copy instead of a move). |
| [popout[n].view](#popout-view) | choice | `"full"` | For a fighter in a fight: `"full"` = the whole fighter, big, framed to fit; `"camera"` = … |
| [popout[n].homeX](#popout-homex) | number, read | `0` | Where its middle is on the desktop while `x` is 0, in pixels. |
| [popout[n].homeY](#popout-homey) | number, read | `0` | Where its middle is on the desktop while `y` is 0, in pixels. |
| [popout[n].open](#popout-open) | switch, read | `false` | Whether the window is really there (false: closed, switched off, or this computer can't). |
| [popout[n].status](#popout-status) | text, read | `"closed"` | What it does: `"closed"`, `"opening"`, `"open"`, `"off"` (switched off), `"unsupported"` … |

---

### popout[n].show { #popout-show }

<p class="mf-sig"><span class="mf-type">text</span> <code>popout[n].show</code> <span class="mf-eq">= <code>""</code></span></p>

What it shows: one or more [parts](choices.md#popout-parts), separated by commas - `"player"`, `"strums"`,
`"left, right"`, `"score, health"`. `""` = closed.

### popout[n].x { #popout-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">pixels</span></p>

Moved to the right from its home (where its parts are in the game window), in screen pixels.

### popout[n].y { #popout-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">pixels</span></p>

Moved down from its home, in screen pixels.

### popout[n].width { #popout-width }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].width</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 8192</span><span class="mf-tag">pixels</span></p>

Its width in pixels; 0 = just big enough for its parts.

### popout[n].height { #popout-height }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].height</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 8192</span><span class="mf-tag">pixels</span></p>

Its height in pixels; 0 = just big enough for its parts.

### popout[n].zoom { #popout-zoom }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].zoom</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0.05 – 20</span></p>

How big its parts are drawn (1 = as big as in the game window).

### popout[n].cropX { #popout-cropx }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].cropX</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">pixels</span></p>

What it looks at, moved from its parts' middle to the right, in the pop-out's own pixels (after the zoom). With a
small width this picks the cut-out - a facecam.

### popout[n].cropY { #popout-cropy }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].cropY</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">pixels</span></p>

The same downwards.

### popout[n].alpha { #popout-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

Its opacity (0 = hidden).

### popout[n].keep { #popout-keep }

<p class="mf-sig"><span class="mf-type">switch</span> <code>popout[n].keep</code> <span class="mf-eq">= <code>false</code></span></p>

true = its parts stay in the game window too (a copy instead of a move).

### popout[n].view { #popout-view }

<p class="mf-sig"><span class="mf-type">choice</span> <code>popout[n].view</code> <span class="mf-eq">= <code>"full"</code></span></p>

For a fighter in a fight: `"full"` = the whole fighter, big, framed to fit; `"camera"` = as the fight camera sees
it, the window as big as the game's picture.

One of: `"full"`, `"camera"`.

### popout[n].homeX { #popout-homex }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].homeX</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Where its middle is on the desktop while `x` is 0, in pixels.

### popout[n].homeY { #popout-homey }

<p class="mf-sig"><span class="mf-type">number</span> <code>popout[n].homeY</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Where its middle is on the desktop while `y` is 0, in pixels.

### popout[n].open { #popout-open }

<p class="mf-sig"><span class="mf-type">switch</span> <code>popout[n].open</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether the window is really there (false: closed, switched off, or this computer can't).

### popout[n].status { #popout-status }

<p class="mf-sig"><span class="mf-type">text</span> <code>popout[n].status</code> <span class="mf-eq">= <code>"closed"</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

What it does: `"closed"`, `"opening"`, `"open"`, `"off"` (switched off), `"unsupported"` (this system can't place
windows), `"over budget"` (too many big pop-outs: its parts stay in the game window for a moment), `"retrying"`
(couldn't be opened, tried again soon), `"failed"` (given up for this song).
