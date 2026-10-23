---
icon: material/shape-outline
---

# Types

Everything the events hand you and the queries give back. They are Java records (read a field with
`result.score()`, `result.hits().sick()`) and enums. Server-side types are in
`com.notfoxxz.minefunkin.api`, client-side ones in `com.notfoxxz.minefunkin.api.client`; `Rank` and
`Judgment` are in `com.notfoxxz.minefunkin.game`.

## Shared

### PlayerRef

A player by UUID and name - in events that can come after the player left.

| Field | |
|---|---|
| `id()` | the player's UUID |
| `name()` | their name |

### SongRef

One chart: song + character + difficulty, played on one side. Each side keeps its own bests - the player side and the
opponent side have different keys.

| Field | |
|---|---|
| `key()` | the text MineFunkin stores everything per chart and side under (local bests, the leaderboard, replays, ranks) - use it for your own per-chart data too |
| `songId()` | the song's folder name |
| `characterLabel()` | the playable character, `""` for a song without characters |
| `difficultyLabel()` | the difficulty, as the song list shows it |

`SongRef.of(songId, character, difficulty)` makes the player side's, `SongRef.of(songId, character, difficulty, true)` the
opponent side's. `opponentSide()` says which one you have. Results (`SongResult.song()`, `onRankImproved`) carry the side
the run was played on.

### PlayMode

| Value | |
|---|---|
| `PRACTICE` | at a Retro TV (or its editor): no health, no ranks, nothing saved or sent - client events only |
| `DUMMY_FIGHT` | at a Speaker against the dummy (or `/minefunkin battle` on a server without MineFunkin) |
| `PLAYER_FIGHT` | at a Speaker against another player (one waits on a pad, the other steps onto the free one) |

### ChartInfo

The side of the chart that was played.

| Field | |
|---|---|
| `noteCount()` | notes to hit (a hold counts once; "never press" notes don't count) |
| `holdCount()` | how many of them are holds |
| `lengthMs()` | from the song's start to the end of its last note (the audio runs on a little longer) |
| `startBpm()` | the tempo at the start (charts can change it) |
| `scrollSpeed()` | the chart's own scroll speed |

### HitStats

How a run's notes were judged.

| Field | |
|---|---|
| `sick()`, `good()`, `bad()`, `shit()` | hits per judgment |
| `miss()` | misses, including dropped holds and presses with nothing to hit |
| `maxCombo()` | the longest streak without a miss |
| `hits()` | every hit (all but misses) |
| `judged()` | hits + misses |

### Rank

The end-of-song rank, from the run's accuracy:

| Value | |
|---|---|
| `PERFECT_GOLD` | every note a "Sick!" |
| `PERFECT` | 100 % accuracy |
| `EXCELLENT` | 90 % and up |
| `GREAT` | 80 % and up |
| `GOOD` | 60 % and up |
| `SHIT` | below 60 % |
| `FAILED` | the health ran out (client side only - a server result is never `FAILED`) |

Better ranks come first: `rank.ordinal()` is smaller for a better rank. `rank.label` is the name the game
shows.

### Judgment

One note's judgment: `SICK`, `GOOD`, `BAD`, `SHIT`, `MISS`.

## Server side

### SongResult

A song played to its end without failing, as the server knows it.

| Field | |
|---|---|
| `player()` | `PlayerRef` |
| `song()` | `SongRef` |
| `mode()` | `DUMMY_FIGHT` or `PLAYER_FIGHT` |
| `validation()` | who vouches for the numbers - see [Can I trust a result?](server.md#can-i-trust-a-result) |
| `verified()` | shorthand: `true` unless `UNVERIFIED` |
| `score()`, `accuracyPercent()` | |
| `rank()` | `Rank`, never `FAILED` |
| `hits()` | `HitStats` (the server's own count for a player fight) |
| `chart()` | `ChartInfo` |
| `opponent()` | the other fighter in a player fight, `null` against the dummy |

### Validation

| Value | |
|---|---|
| `SERVER_SCORED` | a player fight - the server scored it itself |
| `REPLAY_VERIFIED` | a dummy fight whose replay confirmed it |
| `UNVERIFIED` | the player's game's own report, unchecked |

### FightInfo

A fight between two players.

| Field | |
|---|---|
| `fightId()` | its number (for `api.fights().cancel(...)`) |
| `challenger()`, `challenged()` | `PlayerRef`s - who opened the Speaker and waited, who stepped onto the free pad |
| `song()` | `SongRef` |
| `challengerPlaysOpponentSide()` | whether the challenger plays the chart's opponent side |
| `involves(uuid)` | whether that player is one of the two |
| `opponentOf(uuid)` | the other one of the two |

### FightEnd

How a fight ended.

| Field | |
|---|---|
| `fight()` | `FightInfo` |
| `reason()` | `COMPLETED`, `FORFEIT`, `DISCONNECT`, `NOT_STARTED`, `CANCELLED` - see [Fights](server.md#fights) |
| `winner()` | `PlayerRef`, `null` for a draw (equal scores, both failed) |
| `isDraw()` | `winner() == null` |
| `challenger()`, `challenged()` | each side's `FightEnd.Line` |

`FightEnd.Line` is one fighter's last known state - for a fight cut short, the score so far. For a `COMPLETED` fight the
server has scored both runs itself (it replays their key presses on its own chart), and the lines and the winner come from
that, not from what the games reported:

| Field | |
|---|---|
| `player()` | `PlayerRef` |
| `score()`, `accuracyPercent()`, `misses()` | |
| `finished()` | their game reported the end of their run (played to the end, or failed) |
| `failed()` | their health ran out |

### LeaderboardEntry

One place on a chart's leaderboard.

| Field | |
|---|---|
| `position()` | 1 = best |
| `player()` | `PlayerRef` |
| `score()`, `accuracyPercent()`, `rank()` | |

## Client side

### SongSession

One run of a song by the local player.

| Field | |
|---|---|
| `runId()` | counts up per run in this game session |
| `mode()` | `PlayMode` |
| `song()` | `SongRef` |
| `chart()` | `ChartInfo` |
| `opponent()` | the other player in a player fight, `null` otherwise |

### NoteJudgment

One judged note.

| Field | |
|---|---|
| `lane()` | 0 left, 1 down, 2 up, 3 right |
| `judgment()` | `Judgment` |
| `isMiss()` | `judgment() == MISS` |
| `songTimeMs()` | when it was judged |
| `offsetMs()` | how early (negative) or late (positive) the press was; `NaN` without a timed press |
| `combo()` | the combo after it (0 after a miss) |
| `ghostTap()` | a press with nothing to hit (always a miss) |

### HoldNote

| Field | |
|---|---|
| `lane()` | 0-3 |
| `phase()` | `STARTED` (its head was hit), `COMPLETED` (held to its end), `DROPPED` (let go too early - a miss) |
| `lengthMs()` | the hold's length |
| `songTimeMs()` | when this happened |

### ChartCue

A chart event as the song reaches it.

| Field | |
|---|---|
| `name()` | the event's name ("Add Camera Zoom", your own `.event`'s name, ...) |
| `value1()`, `value2()` | its two values, as written in the chart |
| `timeMs()` | its time in the chart |

### SongEnd

How a run ended.

| Field | |
|---|---|
| `outcome()` | `COMPLETED`, `FAILED` or `ABORTED` - see [How a run ends](client.md#how-a-run-ends) |
| `score()`, `accuracyPercent()` | |
| `rank()` | `Rank`: `FAILED` for a failed run, `null` for an aborted one |
| `hits()` | `HitStats` |
| `audioLengthMs()` | the song file's length, -1 if it never finished loading |

### LiveRun

A run as of right now (`api.currentRun()`).

| Field | |
|---|---|
| `session()` | `SongSession` |
| `songTimeMs()` | the position in the song (negative in the short lead-in after the countdown) |
| `audioLengthMs()` | the song file's length, -1 while it's still loading |
| `score()`, `accuracyPercent()`, `combo()` | |
| `hits()` | `HitStats` so far |
| `notesLeft()` | notes not judged yet |
| `health()` | 0 to 1 (practice has health too, it just can't fail) |
| `paused()` | |

### LocalBest

The local player's best on a chart, as saved on this computer (`api.localBest(songKey)`).

| Field | |
|---|---|
| `score()`, `accuracyPercent()`, `rank()` | |
| `achievedAtMillis()` | when (milliseconds since 1970, like `System.currentTimeMillis()`) |
