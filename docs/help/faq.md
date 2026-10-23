---
icon: material/frequently-asked-questions
---

# FAQ

The questions people actually ask. If yours isn't here, [errors and fixes](troubleshooting.md) probably has it.

## Getting started

??? question "Where do my event files go?"
    In the song's folder (next to its `.mfkn` chart), or in an `events/` folder inside it. Songs live in
    `.minecraft/MineFunkin/client/songs/<song>/`. Nothing else is read - an event file in another song's folder
    isn't offered for this one. See [where event files live](../guides/index.md#where-your-files-go).

??? question "Do I need to know how to code?"
    Nope. Lots of great events are three lines long. Start with the [shortcuts](../api/shortcuts.md): `flash()`,
    `zoom(1.2)`, `hideHud()`, `flipScroll()` - one line each. [Your first event](../guides/tutorial.md) takes you from
    an empty file to a real event, one small step at a time, and the [templates](../guides/templates.md) are working
    files you can just copy.

??? question "I have older songs or event files (format 1.0) - what now?"
    Format 1.0 is from MineFunkin's development builds before the first release. MineFunkin only plays format 1.1,
    but updating is one click. Old songs have a yellow ⚠ in the song list: select
    one and press **Update all old songs** (or ⋯ › Update old songs), and every one of them is converted at once.
    Nothing gets lost - the originals go into each song's `backup/` folder. New files always start with
    `format 1.1`. More on [old songs](limits.md#old-songs-and-the-update-button).

??? question "How do I test an event quickly?"
    Open the song in the chart editor (Retro TV → Editor), place the event, press Space. When you change the file,
    press **Reload** at the bottom of the inspector - no restarting needed. For anything to do with the world (the
    fight camera, the fighters, the stage behind them), start a fight against the dummy at a Speaker. The dummy never
    gets tired of testing with you.

## When it doesn't work

??? question "My event isn't in the editor's list."
    Look at the editor's footer: **⚠ N** opens the list of files that **can't be used**, each with its line and why.
    Nine times out of ten it's a typo (the message says "did you mean ...?"), a missing `format 1.1` line, or code
    outside a function. Fix it, press **Reload**, done. [Errors and fixes](troubleshooting.md) explains every
    message.

??? question "My event is in the chart but nothing happens."
    - Is the event's name in the chart the same as `name = ...` in the file (case doesn't matter)?
    - Does it need a fight? The fight camera, `focus`, `swapFighters`, the `"stage"` layer, outlines and health
      only exist in a fight at a Speaker - in practice at the Retro TV they do nothing.
    - Does its header say `only = "fight"` or `only = "practice"`? Then it runs only there.
    - Put a `log("here")` into `onEvent` and look at `logs/minefunkin-events.log`: every chart event is written
      there as it fires, with its values, and so are script errors.

??? question "Two effects cancel each other out."
    A property holds just one value, so two scripts setting the same one every frame overwrite each other (the event
    log names both). Give each effect its own property - `x` for one, `wobbleX` for the other - and they'll get along.
    See [channels](../api/strum.md).

??? question "My picture shows up a moment too late."
    Pictures load the first time they're drawn, which can take a few frames. [preload](../api/shortcuts.md#preload)
    them in `onStart`, and they load during the countdown instead.

??? question "A script stopped working halfway through the song."
    A script that crashes while running (a lane that doesn't exist, text where a number is needed) is switched off
    for the rest of the run, so the song can go on. The event log tells you which line. Fix it and restart the
    song.

## Fights and other players

??? question "Do other players see my effects?"
    Every player runs the song's scripts in their own game, so in a player fight **both fighters see the effects on
    their own screen** - a server's songs bring their event files along. Players standing around the fight see none
    of it from outside. But they can **watch from inside** (right-click the Speaker), and then they see everything,
    three seconds behind. The one thing that's sent along is the song's own poses
    ([setPose](../api/shortcuts.md#setpose)): the players around see the fighters strike them.

??? question "Can a modchart make the song harder to score?"
    Harder to *read*, yes - harder to *score*, no. Judging goes by time, not by where a note is drawn. A note that a
    script moved, turned or faded is hit and judged exactly like any other.

??? question "Do scripts run in replays?"
    Yes - a replay plays the song's events just like the run did. Only the see-through game window is left out,
    since a replay plays in its own little arena.

## Coming from Psych or Kade

??? question "Can I use my Psych Engine Lua files?"
    Not as they are - `.event` is MineFunkin's own language. But most lines translate one to one, and
    [Coming from Psych Engine](../guides/psych.md) goes through Psych's whole API with you. A Psych chart's events
    keep their values when the chart is converted, so you only rewrite the scripts, not the chart.

??? question "And Kade Engine modcharts?"
    Same idea: [Coming from Kade Engine](../guides/kade.md) maps every hook, function and variable, and translates Kade's
    example modcharts.

??? question "Can I use my Psych shaders (.frag)?"
    Yes, as they are: put the `.frag` in the song folder, set `shader[0].file = "name.frag"` and its values with
    [setShaderFloat](../api/shortcuts.md#setshaderfloat). See [shaders from Psych](../guides/shaders.md#shaders-from-psych-engine-frag).

??? question "My shader runs in my own song, but not on a server."
    By default, songs from a server have to pass MineFunkin's
    [shader check](../guides/shaders.md#which-shaders-run-the-check) - your own songs don't. `shader[n].status` says
    `"refused"`, and the event log says why. Usually it's a `while` loop, or a loop without a fixed number of rounds.

??? question "Can I use Psych sprites (a .png with an .xml)?"
    Yes: put both in the song folder and set `image[n].anim` to the animation's name. See
    [Psych sprites](../guides/stages.md#psych-sprites-sparrow-atlases).

## Safety

??? question "Can a downloaded song harm my game or computer?"
    No - and that was a big deal when the language was designed. A script can only use what this wiki lists: it
    can't read or write files, reach the internet, change your settings or other songs, or run other code. It gets
    the pictures, sounds and shaders of its own song folder and nothing else, and hard [limits](limits.md) stop it
    from doing too much work. Shaders from a server are checked before they run (Options › MineFunkin › Song
    effects).

??? question "Some players have flashing or motion turned down."
    Options › MineFunkin › Accessibility has **Fewer flashes** (flashes kept faint, `fx.invert` / `fx.glitch` at 0.3
    and `fx.brightness` at 1.3 at most) and **Less motion** (no camera bump, shake or hit nudge). Your song still
    plays for them, just a bit calmer. So don't build a moment that *only* works with a full-screen flash.

??? question "Can I switch events off?"
    The built-in ones, yes: Options › MineFunkin › Song effects › Built-in events. A song's own files belong to the
    song, though, so those always run.
