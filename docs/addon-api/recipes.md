---
icon: material/chef-hat
---

# Recipes

Small, complete addons to copy - each one is a few lines and does one useful thing. Paste it into your addon class's
`onMineFunkinApi` (server) or `onMineFunkinClientApi` (client); [Set up your mod](setup.md) shows the class around
it.

## Server side

### XP for a cleared song

```java
api.events().onSongCompleted((player, result) -> {
	if (!result.verified()) {
		return; // only results the server checked
	}
	HitStats hits = result.hits();
	player.giveExperiencePoints(hits.sick() * 2 + hits.good());
});
```

### A diamond for the first full combo on a chart

```java
api.events().onRankImproved((player, result, previousBest) -> {
	boolean hadOne = previousBest != null && previousBest.fullCombo();
	if (result.rank().fullCombo() && !hadOne && result.verified()) {
		player.addItem(new ItemStack(Items.DIAMOND));
		player.sendSystemMessage(Component.literal("Full combo on " + result.song().songId() + "!"));
	}
});
```

`onRankImproved` fires only when the rank beats every earlier one of this player on this chart, so the
diamond comes once per chart.

### No fights in the Nether

```java
api.events().allowFight(fight -> {
	if (fight.first().level().dimension() == Level.NETHER) {
		return Component.literal("No fights in the Nether.");
	}
	return null; // allowed
});
```

### A prize for the winner

```java
api.events().onFightEnded((server, result) -> {
	if (result.reason() != FightResult.EndReason.SONG_END || result.winner() == null || !result.winner().isPlayer()) {
		return;
	}
	ServerPlayer winner = server.getPlayerList().getPlayer(result.winner().id());
	if (winner != null) { // they may have left already
		winner.addItem(new ItemStack(Items.MUSIC_DISC_CAT));
	}
	server.getPlayerList().broadcastSystemMessage(
			Component.literal(result.winner().name() + " won on " + result.fight().song().songId() + "!"), false);
});
```

### Announce fights in the chat

```java
api.events().onFightStarted(fight ->
		myServer.getPlayerList().broadcastSystemMessage(Component.literal(
				fight.first().name() + " vs " + fight.second().name() + " on " + fight.song().songId() + " - fight!"), false));
```

### Log suspicious results

```java
api.events().onResultRejected((server, claimed) ->
		LOGGER.warn("{} claimed {} points on {}, but the replay disagrees",
				claimed.player().name(), claimed.score(), claimed.song().key()));
```

## Your own fights

These need [rights](rights.md) in your mod's metadata - each recipe names them.

### A boss fight: hit the boss, beat the song, get the loot

Rights: `fights.start`. The player who hits your boss mob fights it on your song - your mob's model sings the other side,
a boss bar shows its health to everyone around. Win and the boss drops its loot.

```java
// In your mob's code, when a player hits it (only on the server):
api.fights().start(FightRequest.builder(player, Opponent.entity(this), "boss-theme")
				.difficulty("Hard")
				.ask(true) // "Fight" or "Not now" - nobody is pulled in by a stray hit
				.bossBar(null, BossEvent.BossBarColor.RED) // null = the mob's name
				.onResult(result -> {
					if (result.first().won() && result.first().verified()) {
						this.kill((ServerLevel) this.level()); // your mob's own end: loot, sounds, ...
					} else if (result.first().outcome() == FighterResult.Outcome.LOST) {
						player.sendSystemMessage(Component.literal("The boss laughs at you."));
					}
				})
				.build())
		.onRefused(no -> player.displayClientMessage(Component.literal("Not now (" + no.reason() + ")"), true));
```

The fight starts right where the player stands (or within about 16 blocks when there's no room), and afterwards the
player is back where they were. While it runs, your real mob is invisible, silent and still; afterwards it's back as it
was. A result is `verified` when the server resimulated the run - only then hand out the loot. Its moves: an animation
file, see [Boss opponents](boss-opponents.md#animations).

### A Minecraft mob as the boss

Rights: `fights.start`. Any mob works - here the zombie the player hits. MineFunkin brings no moves for Minecraft's
mobs; your mod's resources do. In `assets/<your mod id>/minefunkin/animations/zombie.json`:

```json
{
  "format": 1,
  "entity": "minecraft:zombie",
  "animations": {
    "left": { "parts": { "right_arm": { "rotation": { "0": [0, 0, 100], "180": { "value": [30, 0, 75], "ease": "cubicOut" } } } } },
    "right": { "parts": { "left_arm": { "rotation": { "0": [0, 0, -100], "180": { "value": [30, 0, -75], "ease": "cubicOut" } } } } },
    "up": { "parts": { "root": { "position": { "0": [0, 3, 0], "180": { "value": [0, 1, 0], "ease": "cubicOut" } } } } },
    "down": { "parts": { "head": { "rotation": { "0": [30, 0, 0], "180": { "value": [20, 0, 0], "ease": "cubicOut" } } } } }
  }
}
```

```java
// A player hits a zombie (your own attack listener, on the server):
if (target instanceof Zombie zombie && !api.fights().isFighting(player.getUUID())) {
	api.fights().start(FightRequest.builder(player, Opponent.entity(zombie), "bopeebo").ask(true).build())
			.onStarted(fight -> fight.onEntityGone((f, why) -> LOGGER.info("The zombie left the fight: {}", why)));
}
```

Without the file the zombie still fights - every note a small hop.

### The boss strikes back

Rights: `fights.start`, `fights.control`. Every 20 seconds of song the boss takes two hearts; a full combo so far heals
the player instead.

```java
api.fights().start(request).onStarted(fight -> {
	int[] nextHit = { 20_000 };
	fight.onNote((f, note) -> {
		if (f.songTimeMs() >= nextHit[0] && note.fighter().isPlayer()) {
			nextHit[0] += 20_000;
			boolean clean = f.first().live().hits().miss() == 0;
			f.addHealth(f.first().id(), clean ? 4 : -4);
		}
	});
});
```

The server writes each change down with its song time and applies it again when it checks the run - such a run can still
be verified and count.

### A short break in the middle

Rights: `fights.start`, `fights.control`. At 60 seconds the boss pauses the fight for a moment (your own effect, a
message), then goes on.

```java
boolean[] breakDone = { false };
fight.onNote((f, note) -> {
	if (!breakDone[0] && f.songTimeMs() > 60_000) {
		breakDone[0] = true;
		f.pause();                            // the players see "Paused by <your mod>"
		myScheduler.runLater(100, f::resume); // your own timer: 100 ticks = 5 seconds
	}
});
```

Only your mod can resume it. After 5 minutes without a resume the fight ends as cancelled.

### The boss flees

Rights: `fights.control`. Stop your fight early - with no winner, or with the one you name:

```java
fight.stop(StopOutcome.cancelled("The boss fled into the dark"));
fight.stop(StopOutcome.winner(fight.second().id(), "The boss was too strong"));
```

A stopped fight never counts for a leaderboard.

### Fastest boss kills: your own leaderboard

Rights: `fights.start`, `results.write`.

```java
FightRequest request = FightRequest.builder(player, Opponent.dummy(), "boss-theme")
		.board(Board.own("boss"))
		.build();
// later, e.g. for a sign or a command:
for (LeaderboardEntry entry : api.boards().top("boss", SongRef.of("boss-theme", "", "Hard"), 5)) {
	LOGGER.info("{}. {} - {}", entry.position(), entry.player().name(), entry.score());
}
```

### A cutscene first

Rights: `fights.start`. Let the players' games fetch the song while your cutscene runs - the fight then starts without a
loading pause:

```java
api.fights().prepare(List.of(player), "boss-theme");
playMyCutscene(player, () -> api.fights().start(request));
```

### A duel between two players, anywhere

Rights: `fights.start`. Both are asked first; the result decides who gets the prize.

```java
api.fights().start(FightRequest.builder(a, Opponent.player(b), "bopeebo")
		.ask(true)
		.onResult(result -> result.winnerRef().ifPresent(w -> LOGGER.info("{} won the duel", w.name())))
		.build());
```

## Client side

### A sound on every "Sick!"

```java
api.events().onNoteJudged((session, note) -> {
	if (note.judgment() == Rating.SICK) {
		Minecraft.getInstance().getSoundManager().play(SimpleSoundInstance.forUI(SoundEvents.NOTE_BLOCK_BELL, 2.0f));
	}
});
```

### Practice time

```java
private long startedAt;
private long practiceMs;

// in onMineFunkinClientApi:
api.events().onSongStarted(session -> startedAt = System.currentTimeMillis());
api.events().onSongEnded((session, end) -> {
	if (session.mode() == PlayMode.PRACTICE) {
		practiceMs += System.currentTimeMillis() - startedAt;
	}
});
```

### Accuracy per lane

```java
private final int[] hits = new int[4];
private final int[] notes = new int[4];

// in onMineFunkinClientApi:
api.events().onNoteJudged((session, note) -> {
	if (note.ghostTap()) {
		return; // a press with nothing to hit isn't a note
	}
	notes[note.lane()]++;
	if (!note.isMiss()) {
		hits[note.lane()]++;
	}
});
```

### What's playing (for a status or presence mod)

```java
api.events().onSongStarted(session -> {
	SongRef song = session.song();
	String status = "Playing " + song.songId() + " (" + song.difficultyLabel() + ")"
			+ (session.mode() == PlayMode.PLAYER_FIGHT ? " vs " + session.opponent().name() : "");
	myPresence.set(status);
});
api.events().onSongEnded((session, end) -> myPresence.clear());
```
