---
icon: material/book-open-page-variant-outline
---

# Event API

Every single name a `.event` script can use, all in one place. This is the part of the wiki you look things *up*
in - you don't have to read it front to back. The search up top is your friend here.

The sidebar has it in three parts: the **basics** (the most used names, the language, the fixed words), the **calls**
(what the game calls, and what your script can call), and one page per **property** group.

| How many | What they are |
|---|---|
| **18** [callbacks](callbacks.md) | the functions the game calls: `onBeat`, `onHit`, `onFrame`, ... |
| **20** [actions](actions.md) | statements that do something: `tween`, `after`, `every`, `playSound`, `reset`, ... |
| **43** [shortcuts](shortcuts.md) | one call for a common effect: `flash`, `zoom`, `flipScroll`, `setPose`, `ease`, ... |
| **46** [functions](functions.md) | give a value back: `sin`, `lerp`, `hsv`, `beats`, `sub`, `mod`, ... |
| **5** [built-in values](functions.md#built-in-values) | `time`, `beat`, `step`, `bpm`, `pi` |
| **246** [properties](#properties) on 20 pages | the values the game reads every frame: `camera.zoom`, `strum[2].x`, `player.pose`, ... |
| **78** [modifiers](modifiers.md) | Numbers planned on the beats that bend the playfield: `sway`, `downscroll`, `turnZ`, `cam.z`, ... |
| **9** [choice lists](choices.md) | the fixed words some of them take: easings, layers, blend modes, poses, ... |

**New here?** This page will make more sense after [Your first event](../guides/tutorial.md) - it's ten minutes,
promise. After that, the names you'll use most are on [Frequently used](frequently-used.md), and the language itself
(variables, `if`, `for`, operators) is on [Files and code](language.md).

## How to read an entry

Every entry looks the same, so once you can read one, you can read them all:

<p class="mf-sig"><span class="mf-type">number</span> <code>camera.zoom</code> <span class="mf-eq">= <code>1</code></span></p>
<p class="mf-tags"><span class="mf-tag">0 – 5</span><span class="mf-tag fight">fights only</span><span class="mf-tag">kept at the song's end</span></p>

- the **name** as you write it, as the entry's heading,
- the **signature**: its kind (`number`, `colour`, `switch` = true / false, `choice` = one of a few words, `text`),
  every way to write it, and its default. For a call: its arguments, the `[optional]` ones in brackets,
- **tags**: its range, its unit, *read only*, *fights only*, *Windows only*, *kept at the song's end*,
- then what it does, notes, an example, and the matching name in Psych Engine / Kade Engine.

(The tags above are only a sample.)

## Properties

One page per group. Each starts with how to use it and an example, then lists every property with its kind,
default and range. The kinds and how properties combine: [Properties](properties.md).

| Page | What | Count |
|---|---|---|
| [camera](camera.md) | zoom, beat bump, shake; the fight camera | 13 |
| [hud](hud.md) | score line, title, hearts, bars, the playfield's angle and offset | 19 |
| [judgments](judgments.md) | the rating popups | 4 |
| [screen, flash, vignette](screen.md) | colours over the picture, the playfield's size | 8 |
| [strums](strums.md) | the whole strumline, scroll, input | 10 |
| [strum[lane]](strum.md) | one lane | 17 |
| [underlay](underlay.md) | the strum background | 4 |
| [note[i]](notes.md) | every note on its way, one by one | 15 |
| [text[n]](text.md) | eight texts | 13 |
| [image[n]](image.md) | 32 pictures, sprite sheets, Psych sprites, videos | 22 |
| [Fighters](fighters.md) | `player`, `opponent`, `boyfriend`, `dad`, `puppet[i]` | 32 |
| [Body parts](parts.md) | `player.head`, `.leftArm`, ... | 8 |
| [fx](fx.md) | built-in effects | 17 |
| [shader[n]](shader.md) | the song's own shaders | 8 |
| [volume](volume.md) | the song's audio tracks | 3 |
| [window](window.md) | the game window, desktop mode | 19 |
| [popout[n]](popout.md) | pop-out windows | 15 |
| [monitor](monitor.md) | the monitor's place and size | 4 |
| [song](song.md) | the kind of run, progress, who sings | 9 |
| [player (your run)](player.md) | score, combo, misses, accuracy, health | 6 |
