---
icon: material/monitor
---

# monitor

Where the monitor the game is on sits, and how big it is. Read only - for placing windows and pop-outs exactly.

!!! info "How to use it"
    Read only, in desktop pixels. Use it to place the [window](window.md) or a [pop-out](popout.md) somewhere on the
    screen, whatever its size.

## Example code

```lua
-- Pop-out 0 into the monitor's top left corner, 150 pixels in.
popout[0].show = "opponent"
popout[0].x = monitor.x + 150 - popout[0].homeX
popout[0].y = monitor.y + 150 - popout[0].homeY
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [monitor.x](#monitor-x) | number, read | `0` | Its left edge on the desktop, in pixels. |
| [monitor.y](#monitor-y) | number, read | `0` | Its top edge on the desktop, in pixels. |
| [monitor.width](#monitor-width) | number, read | `0` | Its width in pixels. |
| [monitor.height](#monitor-height) | number, read | `0` | Its height in pixels. |

---

### monitor.x { #monitor-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>monitor.x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Its left edge on the desktop, in pixels.

### monitor.y { #monitor-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>monitor.y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Its top edge on the desktop, in pixels.

### monitor.width { #monitor-width }

<p class="mf-sig"><span class="mf-type">number</span> <code>monitor.width</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Its width in pixels.

### monitor.height { #monitor-height }

<p class="mf-sig"><span class="mf-type">number</span> <code>monitor.height</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Its height in pixels.
