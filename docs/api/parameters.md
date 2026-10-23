---
icon: material/tune-variant
---

# Parameters

A chart event carries two text values, **value1** and **value2** (the Psych Engine / `.mfkn` way). Typing settings
into raw text fields is no fun, though - so **parameters** describe what's in them. The editor builds proper controls
from them (sliders, switches, colour pickers, dropdowns), and when you edit an event it writes your settings back
into value1 and value2 for you.

```lua
params {
    speed = number { from = "value1", default = 1, min = 0.1, max = 5, step = 0.05, label = "Speed" },
    style = choice { from = "value2.1", options = { "classic", "modern" } },
    fast  = flag   { from = "value2", word = "FAST" },
}
```

| Kind | Value | Editor control |
|---|---|---|
| `number` | a number | slider (with `min` and `max`) + field |
| `switch` | on when the text isn't empty (the Psych convention: any value1 = on) | toggle |
| `bool` | `on/true/yes/1` or `off/false/no/0` | toggle |
| `text` | the text as it is | text field |
| `color` | `#RRGGBB`, `RRGGBB`, `0xRRGGBB` or 8 digits with alpha | swatch + field |
| `lane` | `0`-`3` or `L/D/U/R` | four arrow buttons |
| `choice` | one of `options` (a unique start like `d` for `down` is enough) | segmented buttons |
| `flag` | whether `word` appears anywhere in the value | toggle |

Options: `from`, `default`, `min`, `max`, `step`, `label`, plus `options` for a choice and `word` / `group` for
a flag. Flags with the same `group` are one pick in the editor - at most one of them is on:

```lua
params {
    classic = flag { word = "classic", group = "Style" },
    modern  = flag { word = "modern",  group = "Style" },
}
```

 Writing just the kind (`fast = switch`) is fine too.

- `from = "value2"` reads the whole value. `from = "value2.1"` reads the part before the first comma,
  `"value2.2"` the second part, and so on (up to 8). A value is used either whole or in parts, not
  both. Flags look at the whole value and are left out of the parts.
- Without `from`, parameters take value1, then value2, in the order they are listed.
- A blank or unreadable value gives the default. Without a default it gives `nil`, so a script can
  keep what was set before: `speed = p.speed ?? speed`.
- `min` and `max` clamp numbers and give the editor's slider its ends. `step` is the slider's step.
- `onEvent(p)` gets them as `p.speed`, `p.style` and so on, plus the raw `p.value1` and `p.value2`.
