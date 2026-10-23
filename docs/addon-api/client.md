---
icon: material/monitor
---

# Client side

The client side knows the **local player's own runs**, live and note by note - practice at the Retro
TV included, which never reaches a server. Your class implements `MineFunkinClientAddon` and gets
a `MineFunkinClientApi` handle (see [Set up your mod](setup.md)):

```java
public final class MyMineFunkinClientAddon implements MineFunkinClientAddon {
	@Override
	public void onMineFunkinClientApi(MineFunkinClientApi api) {
		api.events().onNoteJudged((session, note) -> {
			if (note.judgment() == Judgment.SICK) {
				Minecraft.getInstance().getSoundManager().play(SimpleSoundInstance.forUI(SoundEvents.NOTE_BLOCK_BELL, 2.0f));
			}
		});

		api.events().onSongEnded((session, end) -> {
			// session.mode(): PRACTICE, DUMMY_FIGHT or PLAYER_FIGHT
			// end.outcome(): COMPLETED, FAILED or ABORTED
		});
	}
}
```

Everything runs on the render thread. The client is the player's own game: fine for HUDs, sounds and
statistics, **not** for rewards - for those, use the [server side](server.md), which can check results.

## A run

A **run** is one play of a song: it starts when the countdown ends (`onSongStarted`) and ends exactly
once (`onSongEnded`). Every event in between carries the same [`SongSession`](types.md#songsession):

| `SongSession` | |
|---|---|
| `runId()` | counts up per run in this game session - tells two runs of the same song apart |
| `mode()` | `PRACTICE` (at a Retro TV), `DUMMY_FIGHT` or `PLAYER_FIGHT` |
| `song()` | the chart: song, character, difficulty, and its `key()` |
| `chart()` | the played side of the chart: notes, holds, length, tempo |
| `opponent()` | the other player in a player fight, `null` otherwise |

A restart is a new run (the old one ends as `ABORTED`). Replays are never reported - watching a run
isn't playing one.

## Events

| Event | When | Your listener gets |
|---|---|---|
| `onSongStarted` | The countdown ended | the session |
| `onNoteJudged` | Every judged note - hits and misses, including a press with nothing to hit | the session, a [`NoteJudgment`](types.md#notejudgment): `lane`, `judgment`, `songTimeMs`, `offsetMs`, `combo`, `ghostTap` |
| `onHoldNote` | A hold note was hit, held to its end, or let go too early | the session, a [`HoldNote`](types.md#holdnote): `lane`, `phase` (`STARTED` / `COMPLETED` / `DROPPED`), `lengthMs`, `songTimeMs` |
| `onBeat` | Every beat of the song, from 0 | the session, the beat number, the tempo there (charts can change tempo) |
| `onChartEvent` | The song reaches a chart event ("Hey!", "Add Camera Zoom", your own `.event`s ...) | the session, a [`ChartCue`](types.md#chartcue): `name`, `value1`, `value2`, `timeMs` |
| `onPauseChanged` | Paused or resumed (in a fight: once both fighters agreed) | the session, `boolean` |
| `onSongEnded` | The run ended - see below | the session, a [`SongEnd`](types.md#songend) |

Lanes are numbered 0 left, 1 down, 2 up, 3 right. `offsetMs` is negative for an early press, positive
for a late one, and `NaN` when there was no timed press (a note that scrolled past, a dropped hold).

### How a run ends

| `SongEnd.Outcome` | |
|---|---|
| `COMPLETED` | Played to the end without failing. |
| `FAILED` | The health ran out (fights only - practice can't fail). |
| `ABORTED` | Left before the end: quit, restarted, gave up, or the fight ended early because the opponent gave up or left. |

`SongEnd` also has the `score`, `accuracyPercent`, the `rank` (`FAILED` for a failed run, `null` for an
aborted one - it isn't a result), the `hits` per judgment and the song file's `audioLengthMs`.

## Queries

| Call | Gives |
|---|---|
| `api.currentRun()` | the run being played right now, as a [`LiveRun`](types.md#liverun): song time, score, accuracy, combo, hits, notes left, health, paused - `Optional.empty()` outside a run |
| `api.localBest(songKey)` | the local player's saved best on a chart (`LocalBest`: score, accuracy, rank, when) - fights only, practice saves nothing |
| `api.serverHasMineFunkin()` | whether the server this client is on runs MineFunkin (false in the menus and on vanilla servers) |

```java
// Your own combo counter: read it every frame from your HUD code.
api.currentRun().ifPresent(run -> drawMyCombo(run.combo(), run.accuracyPercent()));
```
