---
icon: material/swap-horizontal
---

# Coming from Psych Engine

Welcome over! If you've written Psych Engine Lua before, you already know most of this - the ideas are the same,
only some names are different. This page walks through [Psych's Lua API](https://shadowmario.github.io/psychengine.lua/)
in the order it's sorted there - script types, callbacks, then the function pages one by one - and tells you what each
thing is called in a `.event` file.

Keep it open in a tab while you port your first song. After that, you probably won't need it much.

## The big differences

A handful of things work differently on purpose. Once these click, the rest is mostly renaming:

- **One file per event.** Psych splits a custom event into `Name.lua` + `Name.txt`; here it's one `.event`
  file with an `event { }` header, a `params { }` block for the editor's controls, and the code.
- **No `setProperty` strings.** Everything you can change has its own name (`camera.zoom`, `strum[2].x`,
  `player.pose`). The upside: a typo is an error the moment the file loads, with a "did you mean ...?" - instead of
  silently doing nothing while you wonder why.
- **No tags.** Psych names every sprite, tween and timer with a tag. Here texts and pictures are slots
  (`text[0]` ... `text[7]`, `image[0]` ... `image[31]`), a tween belongs to the property it moves, and timers
  only need a name if you want to [cancel](../api/actions.md#cancel) them.
- **Durations are milliseconds,** written `beats(2)`, `steps(4)` or `seconds(1)` - they follow the song's
  tempo by themselves.
- **No globals.** Declare every variable with `local` (or `shared`, to share it between files).
- **The characters are Minecraft players.** `boyfriend` and `dad` are the two fighters in the world (`player`,
  `opponent`) during a fight. In practice at the Retro TV there's no world, so they're the two puppets next to the
  lanes.

## Script types

| Psych | MineFunkin |
|---|---|
| Event (`custom_events/Name.lua` + `.txt`) | a `.event` file in the song folder with `onEvent` - see [Your first event](tutorial.md) |
| Song script (`data/song-name/script.lua`) | a `.event` file without `onEvent` - every callback runs for the whole song: [Song scripts](song-scripts.md) |
| Stage script (`stages/name.lua`) | a song script that sets up pictures in `onStart`: [Stages and sprites](stages.md) |
| Note type (`custom_notetypes/`) | not available - the one special note is the Forced-Miss Note (`note[i].trap`) |
| Character script | not available - the characters are the fighters; [the fighters](fighters.md) page shows what scripts can do with them |
| Global script (`scripts/`) | not available - scripts belong to a song, so a downloaded song can't change other songs |

## Callbacks

| Psych | MineFunkin |
|---|---|
| `onCreate` / `onCreatePost` | [onStart](../api/callbacks.md#onstart) |
| `onSongStart` | [onSongStart](../api/callbacks.md#onsongstart) |
| `onCountdownTick(counter)` | [onCountdown(n)](../api/callbacks.md#oncountdown) - 3, 2, 1, then 0 for "go" |
| `onUpdate(elapsed)` / `onUpdatePost` | [onFrame(dt)](../api/callbacks.md#onframe) - `dt` in ms |
| `onBeatHit` / `onStepHit` / `onSectionHit` | [onBeat(b)](../api/callbacks.md#onbeat) / [onStep(n)](../api/callbacks.md#onstep) / [onSection(n)](../api/callbacks.md#onsection) |
| `onEvent(name, value1, value2)` | [onEvent(p)](../api/callbacks.md#onevent) - typed `p.name` values, raw `p.value1`, `p.value2` |
| `goodNoteHit` / `opponentNoteHit` | [onHit(note)](../api/callbacks.md#onhit) / [onOpponentHit(note)](../api/callbacks.md#onopponenthit) |
| `noteMiss` / `noteMissPress` | [onMiss(note)](../api/callbacks.md#onmiss) (both) |
| `onGhostTap` / `onKeyPress` / `onKeyRelease` | [onGhostTap](../api/callbacks.md#onghosttap) / [onKeyPress](../api/callbacks.md#onkeypress) / [onKeyRelease](../api/callbacks.md#onkeyrelease) - the lane 0-3 |
| `onPause` / `onResume` | [onPause](../api/callbacks.md#onpause) / [onResume](../api/callbacks.md#onresume) - a pause can't be refused |
| `onGameOver` | [onFail](../api/callbacks.md#onfail) |
| `onEndSong` | [onEnd](../api/callbacks.md#onend) |
| `onTweenCompleted(tag)` / `onTimerCompleted(tag)` | put the code in an [after](../api/actions.md#after) with the tween's duration, or in the timer's function |
| `onSpawnNote`, `onMoveCamera`, `onRecalculateRating`, `onNextDialogue`, `onSkipDialogue` | not available |

## Functions, page by page

### PlayState and Reflection

| Psych | MineFunkin |
|---|---|
| `setProperty("camGame.zoom", z)`, `defaultCamZoom` | [`camera.zoom`](../api/camera.md#camera-zoom), the fight camera's lens [`camera.fov`](../api/camera.md#camera-fov) ([the fight camera](camera.md)) |
| `setProperty("camHUD.alpha", a)`, `camHUD.angle` | `hud.alpha`, `hud.angle` |
| `setProperty("scoreTxt.visible", false)`, `healthBar.alpha` | `hud.scoreAlpha`, `hud.healthAlpha` |
| `setProperty("scoreTxt.x", x)`, `scoreTxt.scale` | `hud.scoreX`, `hud.scoreScale` (also `title*`, `health*`) - [hud](../api/hud.md) |
| `setProperty("skipCountdown", true)` | `hud.countdown = false` in `onStart` |
| `setProperty("boyfriend.stunned", true)`, cutscene input locks | `strums.input = false` |
| `setProperty("boyfriend.x", x)` | `player.x` - [the fighters](fighters.md) |
| `getProperty("health")` / `setHealth` / `addHealth` | `player.health` / [setHealth / addHealth](../api/shortcuts.md#sethealth) |
| `getPropertyFromGroup("notes", i, "x")`, `setPropertyFromGroup(...)` | `note[i].x` and friends - [notes one by one](../api/notes.md) |
| `setPropertyFromGroup("strumLineNotes", i, "x" / "angle" / "alpha" / "direction")` | `strum[lane].x`, `.angle`, `.alpha`, `.direction` ([strum[lane]](../api/strum.md)) - Psych counts a straight way in as 90, MineFunkin as 0 |
| `setPropertyFromClass("ClientPrefs", "downScroll", ...)` | [flipScroll](../api/shortcuts.md#flipscroll) / [setScroll](../api/shortcuts.md#setscroll) |
| `setPropertyFromClass("openfl.Lib", "application.window.x", ...)` | `window.x` - an offset from where it was ([game window](windows.md)) |
| `setProperty` / `getProperty` on anything else, `runHaxeCode` | not available - see [left out on purpose](#left-out-on-purpose) |

### Spritesheet and FlxAnimate

| Psych | MineFunkin |
|---|---|
| `makeLuaSprite(tag, image, x, y)` + `addLuaSprite` | `image[n].file`, `.x`, `.y` (shares of the screen) - [image[n]](../api/image.md) |
| `makeAnimatedLuaSprite` + `addAnimationByPrefix` + `playAnim` | `image[n].file` (+ the `.xml`), `image[n].anim = "prefix"`, `image[n].frame = 0` - [Psych sprites](stages.md#psych-sprites-sparrow-atlases) |
| `addAnimationByIndices` | a prefix that matches only those frames, or a grid sheet with `frames` |
| `makeGraphic(tag, w, h, color)` | `image[n].file = "solid"` + `.color`, `.width`, `.height` |
| `scaleObject`, `setGraphicSize` | `image[n].width`, `.height` |
| `setScrollFactor(tag, x, y)` | `image[n].follow` - [moving with the camera](stages.md#moving-with-the-camera) |
| `setObjectOrder`, `addLuaSprite(tag, true / false)` | `image[n].order`, `image[n].layer` |
| `setProperty(tag .. ".flipX", true)` | `image[n].flipX = true` |
| `setBlendMode(tag, "add")` | `image[n].blend = "add"` - [blend modes](../api/choices.md#blend-modes) |
| `setProperty(tag .. ".antialiasing", false)` | `image[n].smooth = false` (the default: sharp pixels) |
| a video sprite / `startVideo` | `image[n].file = "videos/name/"` - a folder of frames ([videos](stages.md#videos)) |
| `objectsOverlap`, `getMouseX` | not available |
| FlxAnimate (texture atlases from Animate) | not available - convert them to a sheet |

### Text

| Psych | MineFunkin |
|---|---|
| `makeLuaText(tag, text, width, x, y)` + `addLuaText` | `text[n].value`, `.x`, `.y`, `.wrap` |
| `setTextString`, `setTextColor`, `setTextSize` | `text[n].value`, `.color`, `.size` |
| `setTextFont` | `text[n].font` - Minecraft's fonts: `"default"`, `"uniform"`, `"alt"`, `"illager"` |
| `setTextBorder(tag, size, color)` | `text[n].outline` (the colour; one pixel wide) |
| `setTextAlignment` | `text[n].align` |
| `setTextWidth`, `setTextAutoSize` | `text[n].wrap` |

### Sound

| Psych | MineFunkin |
|---|---|
| `playSound(file, volume, tag)` | [playSound](../api/actions.md#playsound)`("file.ogg", volume, "tag")` |
| `playMusic(file, volume, loop)` | [loopSound](../api/actions.md#loopsound) - the song's own music is the song's audio |
| `stopSound(tag)` | [stopSound](../api/shortcuts.md#stopsound) |
| `soundFadeIn` / `soundFadeOut` / `setSoundVolume` | [soundVolume](../api/shortcuts.md#soundvolume)`("tag", volume, duration)` |
| `setProperty("vocals.volume", v)`, `inst.volume` | `volume.player`, `volume.opponent`, `volume.inst` - [sounds and music](sound.md) |
| `getSoundTime`, `setSoundTime`, `setSoundPitch`, `pauseSound` | not available |

### Shaders

| Psych | MineFunkin |
|---|---|
| `initLuaShader` + `setSpriteShader(tag, shader)` | `shader[0].file = "my.frag"` - the Psych `.frag` file as it is, on the whole picture, the world, or the world behind the fighters ([your own shaders](shaders.md#shaders-from-psych-engine-frag)) |
| `setShaderFloat(tag, name, value)` | [setShaderFloat](../api/shortcuts.md#setshaderfloat)`(slot, name, value)` - `int` / `bool` uniforms too |
| `setShaderFloatArray` | not available - use single values |
| ready-made shader effects | the built-in [`fx.*`](effects.md): chromatic, bloom, blur, glitch, wave, ... |

### Camera

| Psych | MineFunkin |
|---|---|
| `cameraFlash`, `cameraFade`, `cameraShake` | [flash](../api/shortcuts.md#flash), [fadeOut](../api/shortcuts.md#fadeout), [shake](../api/shortcuts.md#shake) |
| `cameraSetTarget("dad")`, `camFollow` | [focus](../api/shortcuts.md#focus)`("opponent")`, or `camera.x`, `camera.yaw`, ... + [resetCamera](../api/actions.md#resetcamera) |
| `doTweenZoom` | `tween(camera.zoom, ...)` or [zoom](../api/shortcuts.md#zoom) |
| `setCameraScroll`, `getCameraFollowX` | `camera.x`, `camera.y`, `camera.z` |

### Input

| Psych | MineFunkin |
|---|---|
| `keyJustPressed("left")`, `keyPressed("left")`, `keyReleased` | [onKeyPress(lane)](../api/callbacks.md#onkeypress), `strum[lane].pressed`, [onKeyRelease](../api/callbacks.md#onkeyrelease) |
| `keyboardJustPressed("SPACE")`, mouse functions | not available - only the lane keys reach scripts |

### Tween and Timer

| Psych | MineFunkin |
|---|---|
| `doTweenX`, `doTweenAlpha`, `doTweenAngle`, `doTweenColor`, `startTween` | [tween](../api/actions.md#tween)`(prop, to, duration, ease)` on any number or colour property |
| `noteTweenX`, `noteTweenAlpha`, `noteTweenAngle`, `noteTweenDirection` | `tween(strum[lane].x, ...)`, `.alpha`, `.angle`, `.direction` |
| `cancelTween(tag)` | [stopTween](../api/actions.md#stoptween)`(prop)` |
| `runTimer(tag, 1)` | [after](../api/actions.md#after)`(seconds(1), function() ... end, "tag")` |
| `runTimer(tag, 0.5, 8)` | [every](../api/actions.md#every)`(seconds(0.5), function() ... end, 8, "tag")` |
| `cancelTimer(tag)` | [cancel](../api/actions.md#cancel)`("tag")` |

### Character

| Psych | MineFunkin |
|---|---|
| `characterPlayAnim("boyfriend", "singUP")`, `playAnim` | [pose](../api/shortcuts.md#pose)`("boyfriend", "up")` or `boyfriend.pose = "up"` |
| a character's own animations (its JSON) | [setPose](../api/shortcuts.md#setpose)`("dad", "left", "rightArm", ...)` - the song's own poses, played by the notes |
| `boyfriend` / `dad` | `boyfriend` / `dad` - the fighters by the chart's sides ([fighter names](../api/choices.md#fighter-names)) |
| `triggerEvent("Change Character", ...)` | [setSkin](../api/shortcuts.md#setskin)`("opponent", "skins/rival.png")` |
| `setProperty("dad.alpha", a)`, `.angle`, `.scale` | `dad.alpha`, `.turn`, `.scale` - [the fighters](fighters.md) |
| `getCharacterX` / `setCharacterX` | `dad.x` (blocks, in the fight's frame), or pinned to the screen: [bind](../api/shortcuts.md#bind)`("dad", x, y)` |

### Precache, Score and Script

| Psych | MineFunkin |
|---|---|
| `precacheImage`, `precacheSound` | [preload](../api/shortcuts.md#preload)`("picture.png")`; sounds are read the first time they play |
| `getScore`, `getMisses`, `rating`, `combo` | `player.score`, `player.misses`, `player.accuracy`, `player.combo` - read only |
| `setScore`, `setMisses`, `setRatingPercent` | not available - scores stay honest for the leaderboards |
| `triggerEvent(name, v1, v2)` | [trigger](../api/shortcuts.md#trigger)`("Name", v1, v2)` |
| `callOnLuas(func, args)` / `callOnScripts` | [call](../api/shortcuts.md#call)`("func", ...)` |
| `setOnLuas(var, value)` / `setVar` | `shared` variables - [song scripts](song-scripts.md#talking-to-each-other-shared) |
| `addLuaScript`, `removeLuaScript`, `isRunning` | not available |
| `close()` | an `active` variable the callbacks check |

### Uncategorized

| Psych | MineFunkin |
|---|---|
| `debugPrint` | [log](../api/actions.md#log)`(...)` - it goes to the [event log](../help/troubleshooting.md#the-event-log) |
| `getRandomInt` / `getRandomFloat` / `getRandomBool` | `randomInt(a, b)` / `random(a, b)` / `chance(p)` |
| `stringStartsWith`, `stringEndsWith`, `stringSplit`, `stringTrim` | `startsWith`, `endsWith`, `sub` + `find`, `trim` - [functions](../api/functions.md#text) |
| `getSongPosition()`, `curBeat`, `curStep`, `curSection`, `bpm`, `crochet` | `time`, `beat`, `step`, `floor(beat / 4)`, `bpm`, `beats(1)` |
| `getColorFromHex("FF0000")` | `#FF0000` |
| `cond and a or b` | `cond ? a : b` (`and` / `or` work too, but `0` counts as false here) |
| File I/O, Save Data, Achievements, Discord, Language, Substate, dialogue | not available |

## A whole event, side by side

Here's a Psych event that flashes the screen and zooms in, with the colour in value1 - and the same thing here:

=== "Psych (Flash Zoom.lua + .txt)"

    ```text
    function onEvent(name, value1, value2)
        if name == "Flash Zoom" then
            cameraFlash("camGame", value1 ~= "" and value1 or "FFFFFF", 0.5)
            doTweenZoom("fz", "camGame", 1.2, 0.5, "sineOut")
            runTimer("fzBack", 2)
        end
    end

    function onTimerCompleted(tag)
        if tag == "fzBack" then
            doTweenZoom("fz", "camGame", 1, 0.5, "sineInOut")
        end
    end
    ```

=== "MineFunkin (flash_zoom.event)"

    ```lua
    format 1.1

    event {
        name = "Flash Zoom",
        description = "Flashes and zooms in, back after two seconds.",
    }

    params {
        tint = color { from = "value1", default = #FFFFFF, label = "Colour" },
    }

    function onEvent(p)
        flash(p.tint, seconds(0.5))
        zoom(1.2, seconds(0.5))
        after(seconds(2), function() zoom(1, seconds(0.5)) end)
    end
    ```

Notice how much shorter it got? No name check, no timer tag, no `onTimerCompleted`. And the `params` block gives the
event a real colour picker in the chart editor - while the chart file still stores value1 as text, just like Psych.
So a Psych chart's events keep their values when you bring it over.

## Left out on purpose

Some of Psych's Lua can reach into the whole game - and into your computer. MineFunkin's scripts can't, and that's
a feature: a song you download can't do anything to your game or your files. So these are gone for good:

- `runHaxeCode` / HScript, and reaching any object by name (`setProperty` on whatever exists,
  `getPropertyFromClass`) - a script gets the properties of this wiki, nothing else;
- reading and writing files, save data (`initSaveData`, `flushSaveData`), the clipboard, the internet;
- loading more scripts while the song runs (`addLuaScript`), changing the chart or the stage files;
- setting the score or misses.

Everything else a Psych chart usually does - tweens, timers, sprites and animations, texts, the camera, the
characters, the notes one by one, sounds, health, shaders, even the game window - has a counterpart above. If you get
stuck on something that isn't listed, the [FAQ](../help/faq.md) is a good next stop.
