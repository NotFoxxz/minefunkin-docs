---
icon: material/application-outline
---

# window

The game window itself: move it, size it, shake it, take its frame away - or make it see-through, so the whole song plays
right on the desktop.

!!! info "How to use it"
    `window` is always there - while a song plays. Positions and sizes count from where the window was when the song
    started, so a script works on every screen. When the song ends (or on pause) the window goes back home by itself;
    [`resetWindow([duration])`](actions.md#resetwindow) does it earlier.
    
    - **Not everywhere:** moving and placing need a system that lets programs place windows (not Wayland);
      `transparent` (desktop mode) is Windows only. The player can switch all of it off (Options › MineFunkin › Window &
      desktop › "Let songs use windows"). Read `canPlace`, `canSeeThrough`, `status` to know what really happens.
    - **Pop-out windows** (parts of the game in windows of their own): [popout](popout.md). The monitor's size:
      [monitor](monitor.md).
    
    The whole picture: [Game window and pop-outs](../guides/windows.md).

## Example code

```lua
-- The window shrinks to half its size and wanders to the right, then comes back.
function onEvent(p)
    tween(window.width, 0.5, beats(2), "cubicInOut")
    tween(window.height, 0.5, beats(2), "cubicInOut")
    tween(window.x, 300, beats(4), "sineInOut")
    after(beats(8), function() resetWindow(beats(2)) end)
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [window.x](#window-x) | number | `0` | Moved to the right from where it was when the song started, in pixels. |
| [window.y](#window-y) | number | `0` | Moved down from where it was when the song started, in pixels. |
| [window.width](#window-width) | number | `1` | Its width as a share of the width it had (0.5 = half), around its middle. |
| [window.height](#window-height) | number | `1` | Its height as a share of the height it had, around its middle. |
| [window.fullscreen](#window-fullscreen) | choice | `"auto"` | `"auto"` = as the player has it, `"on"`, `"off"`. |
| [window.border](#window-border) | switch | `true` | Its title bar and frame; false = borderless. |
| [window.alpha](#window-alpha) | number | `1` | The whole window's opacity - never below 0.2, the game stays visible. |
| [window.title](#window-title) | text | `""` | Its title; `""` = the game's own. |
| [window.transparent](#window-transparent) | switch | `false` | Desktop mode: the world disappears and the desktop shows through - the fighters, lanes … |
| [window.fill](#window-fill) | choice | `"none"` | `"desktop"` = borderless over the whole desktop above the taskbar, `"screen"` = over the … |
| [window.homeX](#window-homex) | number, read | `0` | Where its top left corner was when the song started, from the left of the desktop, in … |
| [window.homeY](#window-homey) | number, read | `0` | Where its top left corner was when the song started, from the top, in pixels. |
| [window.homeWidth](#window-homewidth) | number, read | `0` | Its width when the song started, in pixels. |
| [window.homeHeight](#window-homeheight) | number, read | `0` | Its height when the song started, in pixels. |
| [window.status](#window-status) | text, read | `"home"` | What the window really does: `"home"` (as the player has it), `"applied"` (a script's … |
| [window.seeThrough](#window-seethrough) | switch, read | `false` | Whether it IS see-through right now (`transparent` only asks for it - it takes a few … |
| [window.canSeeThrough](#window-canseethrough) | switch, read | `false` | Whether desktop mode can work here (Windows, and the player allows it). |
| [window.canPlace](#window-canplace) | switch, read | `false` | Whether the window can be moved and sized here (not on Wayland, and the player allows it). |
| [window.canPopOut](#window-canpopout) | switch, read | `false` | Whether pop-out windows can be opened here. |

---

### window.x { #window-x }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.x</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">pixels</span></p>

Moved to the right from where it was when the song started, in pixels.

### window.y { #window-y }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.y</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">pixels</span></p>

Moved down from where it was when the song started, in pixels.

### window.width { #window-width }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.width</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0.1 – 10</span></p>

Its width as a share of the width it had (0.5 = half), around its middle.

### window.height { #window-height }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.height</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0.1 – 10</span></p>

Its height as a share of the height it had, around its middle.

### window.fullscreen { #window-fullscreen }

<p class="mf-sig"><span class="mf-type">choice</span> <code>window.fullscreen</code> <span class="mf-eq">= <code>"auto"</code></span></p>

`"auto"` = as the player has it, `"on"`, `"off"`.

One of: `"auto"`, `"on"`, `"off"`.

### window.border { #window-border }

<p class="mf-sig"><span class="mf-type">switch</span> <code>window.border</code> <span class="mf-eq">= <code>true</code></span></p>

Its title bar and frame; false = borderless.

### window.alpha { #window-alpha }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.alpha</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 1</span><span class="mf-tag">share of the screen</span></p>

The whole window's opacity - never below 0.2, the game stays visible.

### window.title { #window-title }

<p class="mf-sig"><span class="mf-type">text</span> <code>window.title</code> <span class="mf-eq">= <code>""</code></span></p>

Its title; `""` = the game's own.

### window.transparent { #window-transparent }

<p class="mf-sig"><span class="mf-type">switch</span> <code>window.transparent</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag win">Windows only</span></p>

Desktop mode: the world disappears and the desktop shows through - the fighters, lanes and HUD stay, on the
player's wallpaper. Pictures with `blend = "key"` can cut more holes.

### window.fill { #window-fill }

<p class="mf-sig"><span class="mf-type">choice</span> <code>window.fill</code> <span class="mf-eq">= <code>"none"</code></span></p>

`"desktop"` = borderless over the whole desktop above the taskbar, `"screen"` = over the whole monitor (the
full-screen size without real full screen), `"none"`. `x` / `y` / `width` / `height` wait meanwhile.

One of: `"none"`, `"desktop"`, `"screen"`.

### window.homeX { #window-homex }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.homeX</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Where its top left corner was when the song started, from the left of the desktop, in pixels.

### window.homeY { #window-homey }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.homeY</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Where its top left corner was when the song started, from the top, in pixels.

### window.homeWidth { #window-homewidth }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.homeWidth</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Its width when the song started, in pixels.

### window.homeHeight { #window-homeheight }

<p class="mf-sig"><span class="mf-type">number</span> <code>window.homeHeight</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span><span class="mf-tag">pixels</span></p>

Its height when the song started, in pixels.

### window.status { #window-status }

<p class="mf-sig"><span class="mf-type">text</span> <code>window.status</code> <span class="mf-eq">= <code>"home"</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

What the window really does: `"home"` (as the player has it), `"applied"` (a script's shape), `"seethru"`
(desktop mode on), `"restoring"` (on its way home), `"off"` (the player switched song windows off).

### window.seeThrough { #window-seethrough }

<p class="mf-sig"><span class="mf-type">switch</span> <code>window.seeThrough</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether it IS see-through right now (`transparent` only asks for it - it takes a few frames, or never happens on
a system that can't).

### window.canSeeThrough { #window-canseethrough }

<p class="mf-sig"><span class="mf-type">switch</span> <code>window.canSeeThrough</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether desktop mode can work here (Windows, and the player allows it).

### window.canPlace { #window-canplace }

<p class="mf-sig"><span class="mf-type">switch</span> <code>window.canPlace</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether the window can be moved and sized here (not on Wayland, and the player allows it).

### window.canPopOut { #window-canpopout }

<p class="mf-sig"><span class="mf-type">switch</span> <code>window.canPopOut</code> <span class="mf-eq">= <code>false</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

Whether pop-out windows can be opened here.
