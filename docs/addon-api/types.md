---
icon: material/shape-outline
---

# Types

Everything the events hand you and the queries give back. They are Java records (read a field with
`result.score()`, `result.hits().sick()`), enums and a few small classes. Server-side and shared types are in
`com.notfoxxz.minefunkin.api`, client-side ones in `com.notfoxxz.minefunkin.api.client` - the API never hands you
one of MineFunkin's internal classes.

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

### RunRank

The run's full-combo rank, from its judgments (the game shows it right after the accuracy: "96.4% · GFC"):

| Value | |
|---|---|
| `SFC` | no miss, every note a "Sick!" |
| `GFC` | no miss, only "Sick!" and "Good" |
| `FC` | no miss ("Bad" and "Shit" count as hits) |
| `SDCB` | 1 to 9 misses |
| `CLEAR` | 10 misses or more |
| `FAILED` | the health ran out (client side only - a server result is never `FAILED`) |

Better ranks come first: `rank.betterThan(other)` compares two. `rank.label()` is the name the game shows,
`rank.fullCombo()` is `true` for `SFC`, `GFC` and `FC`. A best saved before the full-combo ranks can have no rank
(`null`): back then the misses weren't kept, only a run with every note a "Sick!" became an `SFC`.

### Rating

One note's judgment: `SICK`, `GOOD`, `BAD`, `SHIT`, `MISS` (`isMiss()`).

### ChartSide

`PLAYER` or `OPPONENT` - the two parts of a chart (`other()` gives the other one).

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
| `rank()` | `RunRank`, never `FAILED` |
| `hits()` | `HitStats` (the server's own count for a player fight) |
| `chart()` | `ChartInfo` |
| `opponent()` | the other fighter in a player fight, `null` against the dummy |

### Validation

| Value | |
|---|---|
| `SERVER_SCORED` | a player fight - the server scored it itself |
| `REPLAY_VERIFIED` | a dummy fight whose replay confirmed it |
| `UNVERIFIED` | the player's game's own report, unchecked |

### Fight

A running fight as an object - see [Controlling fights](controlling-fights.md). Not a record: its state changes while
you hold it.

| | |
|---|---|
| `id()` | its number |
| `startedBy()` | the addon's mod id, empty for a Speaker fight |
| `isMine()` | your addon started it |
| `fighters()`, `first()`, `second()`, `fighter(uuid)` | [`Fighter`](#fighter)s, a snapshot each time you ask |
| `song()` | `SongRef` - the chart the first fighter plays |
| `rules()` | [`FightRules`](#fightrules) |
| `state()` | [`FightState`](#fightstate) |
| `songTimeMs()` | the server's song time, `NaN` before the countdown |
| `pausedBy()` | an addon's name or `""` (the players) while paused, else empty |
| `result()` | the [`FightResult`](#fightresult) once it's over |
| `opponentEntity()` | against a mob: the real mob while it's in the world, else empty |
| `onCountdownOver`, `onNote`, `onHealthChanged`, `onPause`, `onResume`, `onFighterOut`, `onEnd`, `onEntityGone` | listeners on this fight |
| `pause()`, `resume()`, `stop(outcome)`, `setHealth(id, hp)`, `addHealth(id, amount)` | control - your own fights only |

### FightState

`LOADING` (the games load the song), `COUNTDOWN`, `RUNNING`, `PAUSED`, `SCORING` (over, the server scores the runs),
`OVER`.

### Fighter

One fighter, as a snapshot.

| Field | |
|---|---|
| `ref()` | [`FighterRef`](#fighterref) (also `id()`, `name()`, `kind()`) |
| `side()` | `ChartSide` - which part of the chart it plays |
| `live()` | [`LiveStats`](#livestats) - unverified |

### FighterRef

| Field | |
|---|---|
| `id()` | the player's UUID - the dummy and a mob's figure have one made for the fight |
| `name()` | the player's name, "Dummy" for the dummy, the mob's name |
| `kind()` | `PLAYER`, `DUMMY` or `ENTITY` (`FighterKind` - more kinds can come, keep a `default` in a `switch`) |
| `isPlayer()` | `kind() == PLAYER` |

### LiveStats

A fighter's numbers so far, as its game reports them - not checked by the server.

| Field | |
|---|---|
| `score()`, `accuracyPercent()`, `combo()` | |
| `hits()` | `HitStats` so far |
| `health()` | 0-20 (20 = full, 10 hearts); the dummy stays at 20, a mob's goes down with the player's hits |
| `out()` | its health ran out |

### NoteHit

One judged note of a fighter (`onNote`).

| Field | |
|---|---|
| `fighter()` | `FighterRef` |
| `lane()` | 0 left, 1 down, 2 up, 3 right |
| `rating()` | `Rating`; `isMiss()` |
| `songTimeMs()`, `combo()` | |

### FightResult

How a fight ended - once per fight.

| Field | |
|---|---|
| `fight()` | the `Fight` |
| `reason()` | `EndReason` - see [Fights](server.md#fights) |
| `winner()` | `FighterRef`, `null` = nobody won |
| `fighters()`, `first()`, `second()`, `of(uuid)` | each [`FighterResult`](#fighterresult) |
| `message()` | the reason text the players saw ("" when none) |
| `countsForBoard()` | the results went on a leaderboard |
| `isDraw()`, `cancelled()` | played to the end with equal results / ended without a winner otherwise |

### FighterResult

| Field | |
|---|---|
| `fighter()` | `FighterRef` |
| `outcome()` | `WON`, `LOST`, `DRAW`, `FORFEITED` (this fighter gave up), `CANCELLED`; `won()` |
| `score()`, `accuracyPercent()`, `hits()` | |
| `rank()` | `RunRank` (`FAILED` when its health ran out, `null` when nothing was judged) |
| `finished()`, `failed()` | its game reported the end of its run / its health ran out |
| `verified()` | the server resimulated this run itself (the dummy: played it) |

### FightProposal

A fight about to start (`allowFight`).

| Field | |
|---|---|
| `first()` | the player who opened it (a Speaker's host, an addon request's player) |
| `second()` | the opponent player, `null` against the dummy (`againstDummy()`) or a mob |
| `entity()` | the opponent mob, `null` otherwise (`againstEntity()`) |
| `song()` | `SongRef` |
| `startedBy()` | the addon's mod id, `null` at a Speaker |

### FightRequest

A fight to start - built with `FightRequest.builder(player, opponent, songId)`, see [the kit](starting-fights.md#the-kit).

### Opponent

`Opponent.dummy()`, `Opponent.entity(mob)` or `Opponent.player(serverPlayer)` - see [Boss opponents](boss-opponents.md).

### BossBar

`BossBar(name, colour)` - a fight's boss bar, made with `.bossBar(name, colour)` on the request (`name` `null` = the
mob's name). See [Boss bar](boss-opponents.md#boss-bar).

### EntityGone

Why the real mob disappeared (`onEntityGone`): `KILLED`, `REMOVED`, `UNLOADED`, `CHANGED_WORLD` - see
[When the mob disappears anyway](boss-opponents.md#when-the-mob-disappears-anyway).

### FightPlace

`FightPlace.inPlace()`, `FightPlace.at(firstFeet, secondFeet)`, `FightPlace.speaker(blockPos)` - see
[Where](starting-fights.md#where).

### FightRules

| Field | Default | |
|---|---|---|
| `health()` | `true` | health and losing |
| `pause()` | `true` | the fighters may pause |
| `forfeit()` | `true` | the fighters may give up |

`FightRules.DEFAULT.withHealth(false)`, `.withPause(...)`, `.withForfeit(...)` give changed copies.

### Board

`Board.none()`, `Board.song()`, `Board.own("name")` (1-32 characters of a-z, 0-9, `_`, `-`, `.`) - see
[Leaderboards](starting-fights.md#leaderboards).

### FightStart

The answer to `start`: `state()` (`PENDING`, `STARTED`, `REFUSED`), `fight()`, `refusal()`, `onStarted(...)`,
`onRefused(...)`, `withdraw()`.

### Refusal

| Field | |
|---|---|
| `reason()` | `Refusal.Reason` - see [the answer](starting-fights.md#the-answer-started-or-refused) |
| `player()` | the player it's about, `null` when it's about the whole fight |
| `message()` | a short English text for logs |

### StopOutcome

`StopOutcome.cancelled(reason)` or `StopOutcome.winner(fighterId, reason)` - see [Stop](controlling-fights.md#stop).

### Permission

The [rights](rights.md): `FIGHTS_START` ("fights.start"), `FIGHTS_CONTROL`, `SONGS_REGISTER`, `SCRIPTS_RUN`,
`CAMERA_TAKE`, `RESULTS_WRITE`, `PLAYERS_TELEPORT`, `WORLD_PARTICLES`, `WORLD_BLOCKS`, `WORLD_ENTITIES`, `CLIENT_HUD`.
`key()` is the name in the metadata file.

### PermissionDeniedException

Thrown when a right is missing - `getMessage()` says which and why, `modId()` and `permission()` too.

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
| `judgment()` | `Rating` |
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
| `rank()` | `RunRank`: `FAILED` for a failed run, `null` for an aborted one |
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
