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

### A diamond for the first "Perfect" on a chart

```java
api.events().onRankImproved((player, result, previousBest) -> {
	boolean perfect = result.rank() == Rank.PERFECT || result.rank() == Rank.PERFECT_GOLD;
	if (perfect && result.verified()) {
		player.addItem(new ItemStack(Items.DIAMOND));
		player.sendSystemMessage(Component.literal("Perfect on " + result.song().songId() + "!"));
	}
});
```

`onRankImproved` fires only when the rank beats every earlier one of this player on this chart, so the
diamond comes once per chart.

### No fights in the Nether

```java
api.events().allowFight((challenger, challenged, song) -> {
	if (challenger.level().dimension() == Level.NETHER || challenged.level().dimension() == Level.NETHER) {
		return Component.literal("No fights in the Nether.");
	}
	return null; // allowed
});
```

### A prize for the winner

```java
api.events().onFightEnded((server, end) -> {
	if (end.reason() != FightEnd.Reason.COMPLETED || end.isDraw()) {
		return;
	}
	ServerPlayer winner = server.getPlayerList().getPlayer(end.winner().id());
	if (winner != null) { // they may have left already
		winner.addItem(new ItemStack(Items.MUSIC_DISC_CAT));
	}
	server.getPlayerList().broadcastSystemMessage(
			Component.literal(end.winner().name() + " won on " + end.fight().song().songId() + "!"), false);
});
```

### Announce fights in the chat

```java
api.events().onFightStarted((challenger, challenged, fight) ->
		challenger.level().getServer().getPlayerList().broadcastSystemMessage(Component.literal(
				challenger.getName().getString() + " vs " + challenged.getName().getString()
						+ " on " + fight.song().songId() + " - fight!"), false));
```

### Log suspicious results

```java
api.events().onResultRejected((server, claimed) ->
		LOGGER.warn("{} claimed {} points on {}, but the replay disagrees",
				claimed.player().name(), claimed.score(), claimed.song().key()));
```

## Client side

### A sound on every "Sick!"

```java
api.events().onNoteJudged((session, note) -> {
	if (note.judgment() == Judgment.SICK) {
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
