---
icon: material/server-outline
---

# Server side

The server side knows the results that count, the fights between players, who is practicing, and the
server's songs and leaderboard. Your class implements `MineFunkinAddon` and gets a `MineFunkinApi`
handle (see [Set up your mod](setup.md)):

```java
public final class MyMineFunkinAddon implements MineFunkinAddon {
	@Override
	public void onMineFunkinApi(MineFunkinApi api) {
		api.events().onSongCompleted((player, result) -> {
			if (!result.verified()) {
				return; // the client's own word - no rewards for that
			}
			player.giveExperiencePoints(result.hits().sick() * 2 + result.hits().good());
		});

		api.events().allowFight((challenger, challenged, song) ->
				challenger.level().dimension() == Level.NETHER ? Component.literal("No fights in the Nether.") : null);
	}
}
```

The handle has four parts: `api.events()` (listen), `api.fights()`, `api.players()` and `api.songs()`
(ask). Everything runs on the server thread - in singleplayer that's the built-in server.

## Events

| Event | When | Your listener gets |
|---|---|---|
| `onSongCompleted` | A song was played to its end without failing - a dummy fight (when the player's game reports it) or a player fight (once the server scored both runs, a moment after the fight ended) | the `ServerPlayer`, the [`SongResult`](types.md#songresult) |
| `onRankImproved` | Right after `onSongCompleted`, when a CHECKED run's rank beats every earlier rank of this player on this chart | the `ServerPlayer`, the `SongResult`, the previous best [`Rank`](types.md#rank) (`null` the first time) |
| `onResultRejected` | A dummy-fight result that its own replay proved wrong. No `onSongCompleted` fires for it - for anti-cheat logs | the `MinecraftServer`, the claimed `SongResult` |
| `allowFight` | A fight between two players is about to happen - see [Fights](#fights) | challenger, challenged, the [`SongRef`](types.md#songref) |
| `onFightStarted` | Both fighters stand in place. The song starts a second or two later, once both games are ready | challenger, challenged, the [`FightInfo`](types.md#fightinfo) |
| `onFightEnded` | Every fight that started, exactly once, however it ended | the `MinecraftServer`, the [`FightEnd`](types.md#fightend) |
| `onPracticeChanged` | A player opened (`true`) or left (`false`) practice at a Retro TV, as their game reports it. Also `false` when they disconnect | the `ServerPlayer`, `boolean` |

Events about a player who is online right now give you their `ServerPlayer`. Events that can come
after a player left (a fight that ended by a disconnect, a result proven fake) give you the server and
[`PlayerRef`](types.md#playerref)s (UUID + name) instead.

**Never fired** for practice runs (practice stays on the player's game by design - use the
[client side](client.md)), for failed runs, for fights that ended early (giving up, a disconnect, a
timeout), and for replays.

### What fires when

=== "Dummy fight"

    1. The player plays a song at a Speaker against the dummy.
    2. Their game reports the result (and, with online play, uploads the replay).
    3. A few seconds later, once the replay is checked: `onSongCompleted` (+ `onRankImproved` on a new
       best rank) - or `onResultRejected` if the replay disproves it.

=== "Player fight"

    1. A opens a Speaker for a fight against a player and waits on one pad; B steps onto the free pad:
       `allowFight` (A is the challenger, B the challenged).
    2. Both stand on their pads: `onFightStarted`.
    3. The song ends, someone gives up or leaves: `onFightEnded` (always, exactly once).
    4. If it was played to its end: the server scores both runs itself, then `onSongCompleted` (+
       `onRankImproved`) for each fighter who finished without failing.

=== "Practice"

    `onPracticeChanged(player, true)` when they open a Retro TV's menus or songs,
    `onPracticeChanged(player, false)` when they leave or disconnect. Nothing else - practice results
    never reach the server.

## Can I trust a result?

`result.validation()` says who vouches for the numbers. It's final when the event fires.

| `Validation` | |
|---|---|
| `SERVER_SCORED` | A player fight. The server replayed both fighters' key presses on its own copy of the chart - every number is the server's. |
| `REPLAY_VERIFIED` | A dummy fight whose uploaded replay replayed to exactly the reported result. |
| `UNVERIFIED` | The player's game's own report, unchecked: online play or replay validation is off on this server, the player's game sent no replay, or the server doesn't host the song so it can't check it. |

`result.verified()` is `true` for the first two. **Check it before you hand out anything valuable** - an
unverified result is only as honest as the player's game.

By default your mod never even sees an unverified result: `onSongCompleted` gets only checked ones. A server admin can
let unverified results through as well (`apiUnverifiedResults: true` in `server.json`) - for mods that look at
`validation()` themselves. `onRankImproved` and the stored ranks always count checked results only.

## Fights

**`allowFight`** is a veto. It's asked when the second player steps onto a Speaker's free pad - the
challenger is the player who opened the Speaker and waited, the challenged the one who stepped on. Return
`null` to allow the fight, or a `Component` with the reason to refuse it - both players see the reason
(above the hotbar, while the second player stays on the pad). If several mods have rules, the first one
that refuses wins.

```java
api.events().allowFight((challenger, challenged, song) -> {
	if (challenger.isCreative() || challenged.isCreative()) {
		return Component.literal("No fights in creative mode.");
	}
	return null;
});
```

**`onFightEnded`** gets a [`FightEnd`](types.md#fightend): the fight, why it ended, the winner (`null`
for a draw) and each fighter's score so far.

| `FightEnd.Reason` | |
|---|---|
| `COMPLETED` | The song was played to its end (or ran out of time after one side finished). |
| `FORFEIT` | A fighter gave up or left the fight screen - the other one wins. |
| `DISCONNECT` | A fighter disconnected - the other one wins. |
| `NOT_STARTED` | The song never started: a player's game wasn't ready in time. No winner. |
| `CANCELLED` | A mod ended it with `api.fights().cancel(...)`. No winner. |

## Queries

| Call | Gives |
|---|---|
| `api.fights().isFighting(uuid)` | whether that player is in a fight right now |
| `api.fights().fightOf(uuid)` | their fight (`Optional<FightInfo>`) |
| `api.fights().running()` | every running fight |
| `api.fights().cancel(fightId)` | ends a fight at once: no winner, nothing recorded, both fighters go back to where they stood (`CANCELLED`). `false` if no such fight runs |
| `api.players().isPracticing(uuid)` | whether that player is practicing at a Retro TV |
| `api.players().isProtected(player)` | MineFunkin's protection: fighters and practicing players take no damage, aren't targeted by mobs and aren't pushed |
| `api.players().bestRank(uuid, songKey)` | the best rank that player reached on that chart (since the API went online) |
| `api.songs().serverSongIds()` | the server's songs (folder names) - it reads the folder, so not every tick |
| `api.songs().charts(songId)` | every playable chart of a song (character + difficulty), as [`SongRef`](types.md#songref)s |
| `api.songs().chart(songId, character, difficulty)` | one chart's `SongRef`, with its `key()` |
| `api.songs().onlinePlay()` | whether the server runs its online features (leaderboard, replays) |
| `api.songs().leaderboard(songKey, limit)` | the top of a chart's leaderboard, best first, as [`LeaderboardEntry`](types.md#leaderboardentry)s - empty without online play |

Every field of every type: [Types](types.md).
