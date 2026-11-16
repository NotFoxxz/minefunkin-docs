---
icon: material/tune-variant
---

# Controlling fights

A running fight is an object: a `Fight`. You get one when your start goes through (`onStarted`), and for any running
fight from `api.fights()`:

```java
api.fights().fightOf(player.getUUID()).ifPresent(fight -> LOGGER.info("{} plays {}", player.getName().getString(), fight.song().songId()));
api.fights().running();          // every running fight
api.fights().fight(12);          // one by its id
```

**Every addon can read and listen to every fight. Only the addon that started a fight can control it** (needs
`fights.control`). Speaker fights and other addons' fights are read-only - controlling one throws
`PermissionDeniedException`. `fight.isMine()` says whether it's yours.

## Reading a fight

| | |
|---|---|
| `id()` | the fight's number |
| `startedBy()` | the mod id of the addon that started it, empty for a Speaker fight |
| `fighters()`, `first()`, `second()` | each [`Fighter`](types.md#fighter): who (`ref()`, `name()`, `kind()` - `PLAYER` or `DUMMY`), which side, and `live()` |
| `fighter(uuid)` | one of them |
| `song()` | the chart the first fighter plays |
| `rules()` | its [`FightRules`](types.md#fightrules) |
| `state()` | `LOADING`, `COUNTDOWN`, `RUNNING`, `PAUSED`, `SCORING`, `OVER` |
| `songTimeMs()` | the song time on the server's clock (stands still while paused; `NaN` before the countdown) |
| `pausedBy()` | who paused it: your mod's name, `""` for the players - empty while it runs |
| `result()` | the [`FightResult`](types.md#fightresult), once it's over |

`fighter.live()` is a [`LiveStats`](types.md#livestats): score, accuracy, hits per judgment, combo, health (0-20), out.

!!! warning "Live values are unverified"
    The live values are what the fighters' games report while they play - a modified game could send anything. Use
    them for a scoreboard or a boss bar. For rewards, use the result at the end: the server resimulates every run
    itself.

```java
Fighter me = fight.first();
LOGGER.info("{}: {} points, {} hearts, combo {}", me.name(), me.live().score(), me.live().health() / 2, me.live().combo());
```

## Listening to one fight

Instead of listening to every fight, listen to just this one:

| Listener | When |
|---|---|
| `onCountdownOver(fight -> ...)` | the countdown is over, the song starts |
| `onNote((fight, note) -> ...)` | a fighter's note was judged - a hit or a miss ([`NoteHit`](types.md#notehit)) |
| `onHealthChanged((fight, who, before, after, byAddon) -> ...)` | a fighter's health changed (`byAddon`: through `setHealth` / `addHealth`) |
| `onPause((fight, by) -> ...)` | paused (`by` = the addon's name, `""` for the players) |
| `onResume(fight -> ...)` | going on again |
| `onFighterOut((fight, who) -> ...)` | a fighter's health ran out - it's out of the song |
| `onEnd(result -> ...)` | over (once) - the same result as `onResult` |

```java
fight.onNote((f, note) -> {
	if (note.isMiss() && note.fighter().isPlayer()) {
		bossBar.setName(Component.literal("The boss grins"));
	}
});
```

Like the global events, these are what the games report (unverified) and run on the server thread.

## Pause and resume

```java
fight.pause();
// ... later
fight.resume();
```

The players see **"Paused by &lt;your mod's name&gt;"** - without a resume button (giving up still works when the rules
allow it). Only your mod resumes; the song goes on after the usual short countdown. **5 minutes** without a resume end
the fight as cancelled (`PAUSE_TIMEOUT`). `pause()` is `false` when it can't pause now (still loading, or over).

## Stop

```java
fight.stop(StopOutcome.cancelled("The boss fled"));               // nobody wins
fight.stop(StopOutcome.winner(fight.second().id(), "The boss wins")); // the dummy wins
```

The fight ends at once, both players get their place and look back, the players see your reason (up to 64 characters).
The result's `reason()` is `STOPPED_BY_ADDON`. A stopped fight **never counts for a leaderboard** - the song wasn't played
to its end.

## Health

```java
fight.addHealth(player.getUUID(), -4);  // two hearts of damage
fight.setHealth(player.getUUID(), 20);  // full again
```

A fighter has 0-20 health (10 hearts); 0 = out of the song. The change takes effect a moment later, at a song time the
server writes down - and its resimulation at the end applies the same change at the same time. So **a run with your
health changes can still be verified and count** for a leaderboard.

`setHealth` / `addHealth` are `false` when it isn't possible now: before the countdown, after that fighter finished, when
the fight is over, or when its rules have no health. The dummy has no health - asking for it throws
`IllegalArgumentException`.

## Threads

Control methods can be called from any thread - they run on the server thread (from another thread they're queued and
return `true`). Listeners always run on the server thread.
