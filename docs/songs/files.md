---
icon: material/file-document-outline
---

# Song files (format 1.1)

You'll rarely need to open these - the chart editor writes them for you. But when you do, they're friendly: both
are plain JSON, kept small on purpose, with one note or event per line. Spotted a wrong note? Fix it in any text
editor, no tools needed.

MineFunkin only plays format 1.1. Format 1 was used by MineFunkin's development builds before the first release - a
song from back then needs one click to convert (see [below](#format-1-older-songs)).

## The song file (`.mfknsong`)

```json
{
  "format": "1.1",
  "title": "Bopeebo",
  "artist": "Kawai Sprite",
  "charter": "NotFoxxz",
  "speed": 1.0,
  "character": "Boyfriend",
  "audio": {
    "inst": "Inst.ogg",
    "player": "Voices-Player.ogg",
    "opponent": "Voices-Opponent.ogg"
  },
  "difficulties": {
    "Normal": "my-song-normal.mfkn",
    "Hard": "my-song-hard.mfkn"
  }
}
```

| Key | | |
|---|---|---|
| `format` | required | `"1.1"` |
| `title` | | The name in the song list. Default: the file's name. |
| `artist`, `charter` | optional | Who made the music, who made the chart. |
| `speed` | optional | The chart's scroll speed (1 = the player's own). Default 1. |
| `character` | | The playable character of every difficulty, unless a difficulty names its own. Default `"Boyfriend"`. |
| `audio` | | The song's audio files, see below. |
| `difficulties` | required | Label to chart file, in the order the song list shows them. |

### Audio

| Key | |
|---|---|
| `inst` | The instrumental. |
| `player` | Your vocals: one file or a list of files. A miss mutes them. |
| `opponent` | The opponent's vocals: one file or a list. |
| `voices` | A vocal track with both singers in it. When it's the only one, a miss mutes it. |

Every file is a name in the song's folder. A song without vocals just leaves `player`, `opponent` and
`voices` out.

### A difficulty that's different

Most difficulties are just the name of their chart file. One that has its own character or its own audio becomes an
object instead:

```json
"difficulties": {
  "Normal": "my-song-normal.mfkn",
  "Erect": {
    "chart": "my-song-erect.mfkn",
    "audio": { "inst": "Inst-erect.ogg", "player": "Voices-Player-erect.ogg" }
  },
  "Normal (Pico)": {
    "label": "Normal",
    "chart": "my-song-pico.mfkn",
    "character": "Pico",
    "audio": { "inst": "Inst-pico.ogg", "player": "Voices-Pico.ogg" }
  }
}
```

| Key | |
|---|---|
| `chart` | The `.mfkn` file. |
| `label` | The name shown in the song list, when it isn't the key. Two characters can each have a "Normal": the keys have to differ, the labels don't. |
| `character` | This difficulty's playable character. |
| `audio` | Only the audio keys that differ from the song's `audio` - the rest is taken from there. |
| `start` | Practice starts the song here (ms, like the chart's times). Everything before it runs through silently first - chart events, scripts, shaders and texts stand where they would - then the music starts at that point. Notes before it aren't played or counted. Fights and replays always play the whole song. |

Want a practice version of just the hard last part of a long song? Make a second difficulty with the same chart and
a `start`:

```json
"difficulties": {
  "Hard": "hard.mfkn",
  "Hard (last part)": { "chart": "hard.mfkn", "start": 367414.6 }
}
```

Scores and replays belong to song + character + difficulty label. So renaming a file is safe - but renaming a label
starts its scores over.

## The chart file (`.mfkn`)

```json
{
  "format": "1.1",
  "bpm": 140,
  "player": [
    [3428.6, 0, 797],
    [10285.7, 2],
    [10500, 2],
    [12857.1, 3, 0, "miss"]
  ],
  "opponent": [
    [1714.3, 0, 369]
  ],
  "events": [
    [0, "Power On", "EVENT SHOWCASE", "every effect is a .event file in this song's folder"],
    [3428.6, "Cam Sway", "on", "6"]
  ]
}
```

All times are milliseconds from the start of the song.

| Key | |
|---|---|
| `format` | `"1.1"` |
| `bpm` | The tempo: one number, or a list of changes `[[0, 140], [32000, 170]]` (time, BPM). |
| `player` | Your notes. |
| `opponent` | The opponent's notes. |
| `events` | The chart events. |

**A note** is `[time, lane, hold, type]`:

| | |
|---|---|
| `time` | When it's hit. |
| `lane` | 0 = left, 1 = down, 2 = up, 3 = right. |
| `hold` | How long it's held, in ms. Leave it out (or 0) for a tap. |
| `type` | Optional. `"miss"` = a Forced-Miss Note: hitting it counts as a miss, letting it pass costs nothing. A type this version doesn't know skips the note. |

**An event** is `[time, name, value1, value2]`. The name is the event's name (a built-in one or a
`.event` file's); the two values are what its [parameters](../api/parameters.md) read. Leave out
values that are empty.

The order of the lines doesn't matter - notes and events are sorted when the chart loads, and an exact duplicate note
(same lane, same time) is dropped. Times are written with up to three decimals.

## Format 1 (older songs)

Format 1 is the song format of MineFunkin's development builds before the first release. It wrote every note as an
object (`{"time": 3428.6, "lane": 0, "hold": 797.0, "forcedMiss":
false}`), the BPM as `bpmChanges` and the audio once per difficulty with `voices` + `playerVocalIds` /
`opponentVocalIds`. MineFunkin doesn't play it anymore, but converting is one click: Song Select lists such a song with
a yellow ⚠, and its **Update all old songs** button converts every old song at once - its charts, its song file and its
event files (see [old songs](../help/limits.md#old-songs-and-the-update-button)). Nothing is lost: the
notes, events, BPM changes and audio stay as they were, and the originals are copied into the song's
`backup/` folder first. On a server, the admin runs `/minefunkin convert` for `server_songs/`.

A file with a newer format than this MineFunkin knows (1.2, 2.0, ...) isn't read at all - the song is
left out of the list and the log says which version it needs.
