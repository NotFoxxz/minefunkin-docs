---
icon: material/music-box-multiple-outline
---

# Songs

A MineFunkin song is simply a **folder**. Inside: the audio, one `.mfknsong` file that describes the song, one
`.mfkn` chart per difficulty, and - if it has any - its own [event scripts](../guides/index.md). That's the whole
song. Zip the folder, send it to a friend, and they have everything they need.

```
my-song/
  my-song.mfknsong          the song: title, artist, audio, difficulties
  my-song-normal.mfkn       a chart: the notes and the chart events of one difficulty
  my-song-hard.mfkn
  Inst.ogg                  the instrumental
  Voices-Player.ogg         your vocals (a miss mutes them)
  Voices-Opponent.ogg       the opponent's vocals
  events/                   the song's own .event scripts (optional)
```

## Where songs go

| Where | |
|---|---|
| `.minecraft/MineFunkin/client/songs/` | Your own songs: practice at the Retro TV, the chart editor, fights against the dummy. |
| `<server>/MineFunkin/server/server_songs/` | A server's songs. Players get them automatically when they join; fights between players, the leaderboard and the replays use them. |

## Getting a song in

Three ways, from easiest to most hands-on:

- **Import:** in the song list, open the **⋯** menu at the top, pick **Import songs…** and choose the song's folder -
  or just drag the folder onto the game window. This works at the Retro TV, and at a Speaker wherever your own songs
  play (in your own world). MineFunkin reads it and shows you what it found: the difficulties, the
  music, and a line for any difficulty that's missing its music. Title, artist and charter come from the song's own
  files. **Change files…** lets you pick other audio files; Enter imports. This works for MineFunkin songs and for
  Psych Engine and V-Slice songs (a `.json` chart and the `.ogg` files) - those get converted to `.mfkn` and
  `.mfknsong` on the way in. Psych chart events are kept; V-Slice's are left out (they'd look broken here).
- **By hand:** a MineFunkin song (a folder with a `.mfknsong`) can simply go into the songs folder. A song from another
  engine that you put there by hand shows up with a ⚠ and a **Convert…** button.
- **Your own song, from scratch:** the editor's song list → **+ New Chart**, give it a name, drop the audio into the
  new folder, and the [chart editor](../guides/editor.md) opens. Time to chart!

On Linux the folder picker needs `zenity` or `kdialog` (most desktops have one). Without either, just drag the folder
in instead.

## On this tab

<div class="grid cards" markdown>

-   :material-file-document-outline:{ .lg .middle } **Song files**

    ---

    What's in a `.mfknsong` and a `.mfkn` - small JSON files you can fix by hand in any text editor.

    [:octicons-arrow-right-24: Song files](files.md)

</div>
