---
icon: material/shield-check-outline
---

# Limits, the event log and versions

## Limits and safety

Why limits at all? Because you'll download songs from people you don't know, and a song should never be able to
freeze your game - by accident or on purpose. The limits are generous; a normal song never gets near them. If yours
does, the [event log](#the-event-log) tells you which one.

- One call into the scripts (an event, a frame, a hit) may run at most 50,000 statements.
- A `for` loop may run at most 10,000 rounds. Functions may call each other at most 64 deep.
- At most 512 `after`s and `every`s may wait at once. An `every` runs at most once a frame.
- `trigger`: events may trigger each other at most 8 deep.
- A script that fails while running is switched off for the rest of the run, and the failure is
  logged with its line. Examples: a lane that doesn't exist, text where a number is needed, a choice
  property set to a word it doesn't take.
- Writing a non-number (a division by zero) to a number property is ignored.
- Opacities and volumes go from 0 to 1 (`hud.bars` 0-3, `camera.nudge` 0-5). A constant outside that is
  an error when the file loads; a value worked out while the song runs is kept inside, and the log says
  so once.
- `log`: at most 200 lines per event per run.
- Texts: at most 16,384 characters. Making a longer one - joining with `..` / `+` / `+=`, `upper`, `lower`,
  `replace` - switches that script off (it isn't cut short).
- Top-level `local`s get their starting values when the song starts, so they can read the game (`local w =
  screen.width`). One that fails there switches its script off.
- Pictures: `.png`, at most 8192 pixels a side and 16 MB as a file, at most 128 different pictures and 512 MB
  of video memory per song. They are freed when the song closes. A sprite's `.xml`: at most 2 MB and 4096 frames.
  A video folder: at most 20,000 frames (`.jpg` / `.png`), 2048 pixels a side, 8 MB a frame.
- Shaders: `.fsh` or `.frag`, at most 32 KB a file, at most four at once. Which run is the player's choice (the
  [shader check](../guides/shaders.md#which-shaders-run-the-check)); one that takes over 25 ms a frame is switched off.
- Skins (`setSkin`, `player.skin`): 64x64 `.png`, at most 1 MB each and 8 per song.
- Windows: at most eight pop-outs, each at most 4096 pixels a side. The game window keeps 64 pixels on
  its monitor, at least 0.2 opacity, one full-screen flip a second. All of it only while the song plays,
  and only if the player allows it (Options › MineFunkin › Window & desktop › "Let songs use windows").
- Sounds: `.ogg`, at most 5 minutes each (longer ones aren't played - the log says so), at most 32 of a song's own
  sounds playing at once (one more is left out, said once). Each is decoded once per song and let go when it closes.
- [Modifiers](../guides/modifiers.md): at most 200,000 planned changes per song (one per field each `ease` / `set` /
  `add` touches; past that they're left out, said once), 8 playfields (yours, the opponent's, 6 from `copyField`),
  256 modifiers of your own (`customMod`). A value is kept within ±10,000,000; one `ease` lasts at most 100,000 beats.
- Sounds, pictures and shaders are only found inside the song's own folder (and its `events/` folder,
  or `shaders/` for shaders). A path that leads out of it is refused.

Error messages and what to do about them: [Errors and fixes](troubleshooting.md).

## The event log

`logs/minefunkin-events.log`, next to `latest.log`, collects everything that happens with events. It starts fresh
every time the game starts; the one before is kept as `minefunkin-events.prev.log`. It writes down:

- the built-in events, and per song the event files it brings (and which built-in each replaces);
- every file that can't be used, with the reason (also listed in the chart editor);
- every song start (mode, chart event count), chart events no file defines, and events switched off
  in the options;
- every chart event as it fires, with its values;
- script errors, missing sounds, pictures or shaders, shaders that don't compile (with the driver's
  message), and the scripts' own `log` lines.

Warnings and errors also go to `latest.log`. Past 8 MB the file only takes warnings and errors.

## Versions

The first line of every file says which version of the language it's written in. MineFunkin runs **only
`format 1.1`** - one version, so you never have to wonder which features you can use:

| Version | |
|---|---|
| `format 1.1` | The one that runs - write every file like this. |
| `format 1.0` | The version of MineFunkin's development builds before the first release. It doesn't run anymore: Song Select's update button turns a song's 1.0 files into 1.1 in one go - see [old songs](#old-songs-and-the-update-button). |
| anything else | A version newer than this MineFunkin. Not run; it's listed as a problem: "written for event format 1.2, this MineFunkin runs 1.1 - a newer MineFunkin is needed". |

That's why the first release already starts at 1.1: version 1.0 was only used while MineFunkin was still in
development. You'll only meet it in songs made with those early builds.

Some names came to 1.1 after its first files were written: `note`, `notes`, `every`, `cancel`, `stopTween`,
`loopSound`, `trigger`, `call`, `callIn`, `preload`, `setHealth`, `addHealth`, `stopSound`, `soundVolume`, `randomInt`,
`sub`, `find`, `replace`, `trim`, `startsWith`, `endsWith`, `noteSlot`, `boyfriend`, `dad`, `bind`, `unbind`,
`inspect`, `atPlace`. They stay yours if a file already uses them for its own
things: a variable or parameter of that name (`function onHit(note)`) hides the built-in one inside it, and a
function of the file's own (`local function preload(...)`) is called instead of the built-in.

### Old songs and the update button

!!! info "Just so you know"
    You most likely won't need this. Every released MineFunkin uses format 1.1, and only songs made with the
    development builds before the first release are in an older format. This section is here so you know how it
    works if a later MineFunkin ever moves on from 1.1 - old songs will then be updated the same way.

A song with any file in an old format - an event file in `format 1.0`, or a chart or song file in the old song
format 1 - shows up in Song Select with a yellow ⚠, and can't be played yet. Don't worry, fixing it is one click:
select it and press **Update all old songs** (or ⋯ › Update old songs), and every such song is converted at once:

- Charts and song files are written in format 1.1. The notes, events, BPM changes and audio links stay exactly
  as they were.
- Event files get `format 1.1` as their first line, and nothing else changes - with one exception: a name the
  file used for its own things that 1.1 uses itself (a variable called `volume`, a function called `zoom`, a
  helper called `onPause`, which 1.1 would start calling by itself) is renamed to `myVolume`, `myZoom`,
  `myOnPause`, and a comment under the format line lists what was renamed.
- Every original is copied into the song's `backup/` folder first, just in case.

On a server, the admin converts the songs in `server_songs/` with `/minefunkin convert`. The server log says at
start when there are old songs.
