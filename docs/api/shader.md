---
icon: material/shimmer
---

# shader[n]

Your song's own shaders, four slots of them. Write a `.fsh`, or bring a `.frag` from a Psych mod as it is.

!!! info "How to use it"
    `shader[0]` to `shader[3]` - set `file` and it runs, `""` stops it. The file is a `.fsh` (MineFunkin's form:
    `vec4 effect(vec2 uv)`) or a Psych / Flixel `.frag` (taken as it is) in the song folder, its `events/` or `shaders/`
    folder. A `.frag`'s own uniforms are set with [`setShaderFloat`](shortcuts.md#setshaderfloat).
    
    Whether shaders from a song run at all is the player's choice (Options › MineFunkin › Song effects): by default a
    server's song must pass MineFunkin's shader check, the player's own songs run freely. `status` says what became of
    a file.
    
    How to write one: [Your own shaders](../guides/shaders.md).

## Example code

```lua
-- A shader from the song folder, faded in, its first number pulsing on the beat.
function onStart()
    shader[0].file = "shaders/ripple.fsh"
    shader[0].amount = 0
    tween(shader[0].amount, 1, beats(2))
end

function onBeat(b)
    shader[0].a = 1
    tween(shader[0].a, 0, beats(1), "quadOut")
end
```

## Properties

| Property | Kind | Default | |
|---|---|---|---|
| [shader[n].file](#shader-file) | text | `""` | The shader file: `.fsh` or `.frag`, up to 32 KB. `""` = off. |
| [shader[n].target](#shader-target) | choice | `"screen"` | What it covers: `"screen"` (everything), `"world"` (only the world) or `"terrain"` (the … |
| [shader[n].amount](#shader-amount) | number | `1` | How much of it shows: 0 = none, 1 = all (it's blended over the picture). |
| [shader[n].a](#shader-a) | number | `0` | A number for the shader: `params.x` in a `.fsh`. |
| [shader[n].b](#shader-b) | number | `0` | A number for the shader: `params.y`. |
| [shader[n].c](#shader-c) | number | `0` | A number for the shader: `params.z`. |
| [shader[n].d](#shader-d) | number | `0` | A number for the shader: `params.w`. |
| [shader[n].status](#shader-status) | text, read | `"off"` | What became of the file: `"off"` (no file), `"loading"`, `"active"`, `"fight only"` … |

---

### shader[n].file { #shader-file }

<p class="mf-sig"><span class="mf-type">text</span> <code>shader[n].file</code> <span class="mf-eq">= <code>""</code></span></p>

The shader file: `.fsh` or `.frag`, up to 32 KB. `""` = off.

### shader[n].target { #shader-target }

<p class="mf-sig"><span class="mf-type">choice</span> <code>shader[n].target</code> <span class="mf-eq">= <code>"screen"</code></span></p>

What it covers: `"screen"` (everything), `"world"` (only the world) or `"terrain"` (the world without the
fighters) - like [`fx.target`](fx.md#fx-target). The last two in fights only.

One of: `"screen"`, `"world"`, `"terrain"` ([what they do](choices.md#effect-targets)).

### shader[n].amount { #shader-amount }

<p class="mf-sig"><span class="mf-type">number</span> <code>shader[n].amount</code> <span class="mf-eq">= <code>1</code></span></p>

How much of it shows: 0 = none, 1 = all (it's blended over the picture).

### shader[n].a { #shader-a }

<p class="mf-sig"><span class="mf-type">number</span> <code>shader[n].a</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

A number for the shader: `params.x` in a `.fsh`.

### shader[n].b { #shader-b }

<p class="mf-sig"><span class="mf-type">number</span> <code>shader[n].b</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

A number for the shader: `params.y`.

### shader[n].c { #shader-c }

<p class="mf-sig"><span class="mf-type">number</span> <code>shader[n].c</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

A number for the shader: `params.z`.

### shader[n].d { #shader-d }

<p class="mf-sig"><span class="mf-type">number</span> <code>shader[n].d</code> <span class="mf-eq">= <code>0</code></span></p>
<p class="mf-tags"><span class="mf-tag">kept at the song's end</span></p>

A number for the shader: `params.w`.

### shader[n].status { #shader-status }

<p class="mf-sig"><span class="mf-type">text</span> <code>shader[n].status</code> <span class="mf-eq">= <code>"off"</code></span></p>
<p class="mf-tags"><span class="mf-tag ro">read only</span></p>

What became of the file: `"off"` (no file), `"loading"`, `"active"`, `"fight only"` (target world / terrain
outside a fight), `"disabled"` (the player switched song shaders off), `"missing"`, `"unreadable"`, `"refused"`
(the shader check said no - the [event log](../help/limits.md#the-event-log) says why), `"broken"` (doesn't compile -
the log has the driver's message), `"too heavy"` (switched off for this song: it took over 25 ms a frame).
