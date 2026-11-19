---
icon: material/sword-cross
---

# Starting fights

Your mod can start a MineFunkin fight: a player against the dummy (your training dummy), against a mob (your boss - see
[Boss opponents](boss-opponents.md)) or two players against each other - anywhere, not only at a Speaker. You build the fight like a kit and send it off; what you leave out
gets the same default as a Speaker fight. Needs the right `fights.start` (see [Rights](rights.md)).

```java
FightRequest request = FightRequest.builder(player, Opponent.dummy(), "bopeebo")
		.difficulty("Hard")
		.onResult(result -> LOGGER.info("{} - {}", result.first().outcome(), result.first().score()))
		.build();

api.fights().start(request);
```

That's a whole fight: the player stays where they stand, the dummy appears in front of them, the countdown runs, and
when it's over your `onResult` gets the result.

## The kit

`FightRequest.builder(player, opponent, songId)` - the three things every fight needs:

| | |
|---|---|
| `player` | the first fighter (a `ServerPlayer`) |
| `opponent` | `Opponent.dummy()`, `Opponent.entity(mob)` ([Boss opponents](boss-opponents.md)) or `Opponent.player(otherPlayer)` |
| `songId` | a server song (its folder name, see `api.songs().serverSongIds()`) |

Then, all optional:

| Method | Default | |
|---|---|---|
| `.difficulty("Hard")` | like the song select: Hard, else Normal, else the first | the difficulty by its name |
| `.character("Pico")` | the first | for a song with characters |
| `.side(ChartSide.OPPONENT)` | `ChartSide.PLAYER` | which part of the chart the first player plays (the opponent plays the other) |
| `.place(...)` | `FightPlace.inPlace()` | where the fight takes place - [below](#where) |
| `.rules(...)` | `FightRules.DEFAULT` | health, pausing, giving up - [below](#rules) |
| `.modifiers(Modifier.DOUBLE_TIME, ...)` | none | the modifiers both fighters play with - [below](#modifiers) |
| `.ask(true)` | `false` | ask the players first - [below](#asking-the-players-first) |
| `.board(...)` | `Board.none()` | which leaderboard the results go on - [below](#leaderboards) |
| `.returnTo(posA, posB)` | back where they stood | where the players go after the fight (needs `players.teleport`) |
| `.hideEntity(false)` | `true` | against a mob: leave the real mob alone - [Boss opponents](boss-opponents.md#the-real-mob-during-the-fight) |
| `.bossBar(name, colour)` | none | against a mob: a boss bar for the players around - [Boss opponents](boss-opponents.md#boss-bar) |
| `.onResult(result -> ...)` | none | your result, [exactly once](#the-result) |

## The answer: started or refused

`start` gives back a `FightStart`. Most starts are decided within a moment; one that asks the players waits for their
answer. Say what should happen in both cases:

```java
api.fights().start(request)
		.onStarted(fight -> player.sendSystemMessage(Component.literal("Fight!")))
		.onRefused(no -> player.sendSystemMessage(Component.literal("Not now: " + no.reason())));
```

Both run on the server thread - right away when it's decided already. `start.state()` is `PENDING`, `STARTED` or
`REFUSED`; `start.fight()` and `start.refusal()` hold the outcome. `start.withdraw()` takes back a start that still waits
for an answer.

A start is **refused at once, with the reason** - nothing is interrupted, nothing waits in a queue. Try again later if
you like:

| `Refusal.Reason` | |
|---|---|
| `FIGHTING` | the player is in a fight already |
| `AT_SPEAKER` | the player hosts or waits at a Speaker |
| `AT_RETRO_TV` | the player is at a Retro TV, in practice or in the chart editor |
| `WATCHING` | the player watches a fight from inside |
| `ASKED_ELSEWHERE` | the player was asked about another fight and hasn't answered |
| `NO_MINEFUNKIN` | the player's game has no MineFunkin |
| `PLAYER_OFFLINE`, `NOT_AVAILABLE` | the player left, is dead or a spectator |
| `OTHER_WORLD` | the two players (or the player and the mob) are in different worlds |
| `ENTITY_GONE` | the opponent mob is gone (died, removed, unloaded) before the fight could start |
| `NO_ROOM` | no spot for the fight - [below](#where) |
| `UNKNOWN_SONG`, `UNKNOWN_CHART`, `SONGS_NOT_READY` | no such song / difficulty, or the server is still reading its songs |
| `NOT_PLAYABLE_VS_PLAYER` | a side of the song has no notes - against the dummy only |
| `SPEAKER_BUSY` | no free Speaker at that place |
| `DECLINED`, `NO_ANSWER` | a player said no, or didn't answer in 30 seconds |
| `VETOED` | an `allowFight` rule said no (`message()` has its reason) |
| `WITHDRAWN`, `SERVER_STOPPING` | you took it back, or the server stops |

`allowFight` rules of every mod are asked for your fights too - also against the dummy (then `proposal.second()` is
`null`).

## Where

Every place follows the arena rules of a Speaker fight: flat ground at the same height, a clear view between the
fighters, room for the cameras.

=== "In place"

    ```java
    .place(FightPlace.inPlace())   // the default
    ```

    The players stay where they are and are turned toward each other. Against the dummy, the dummy appears in front of
    the player. Against a mob, its figure stands where the mob stands when that spot fits, else like the dummy. Against a player, both stay when they stand a few blocks apart with a clear view; else the second one
    is put in front of the first. **No room there?** MineFunkin looks for a fitting spot up to about 16 blocks away and
    moves both there - no right needed, they come back afterwards. Nothing found: refused with `NO_ROOM`.

=== "Your positions"

    ```java
    .place(FightPlace.at(new Vec3(100.5, 64, 200.5), new Vec3(100.5, 64, 208.5)))
    ```

    Two spots (feet) in the first player's world - your boss arena. The second is the opponent's (the dummy's). Needs
    `players.teleport`. Spots that break the arena rules: refused with `NO_ROOM`.

=== "At a Speaker"

    ```java
    .place(FightPlace.speaker(speakerPos))
    ```

    On the two pads of the Speaker block there, like a Speaker fight (the player side on the right pad). The Speaker
    must be free; nobody can open it while your fight runs, and players can right-click it to watch.

After the fight both players get their place and their look back - unless you give your own with
`.returnTo(firstPos, secondPos)` (needs `players.teleport`; `null` for one of them = back where they stood).

## Rules

```java
.rules(FightRules.DEFAULT.withPause(false).withForfeit(false))
```

| | Default | |
|---|---|---|
| `health` | on | health and losing: missing too much makes a fighter lose. Off = no hearts, nobody runs out (like practice) |
| `pause` | on | the fighters may pause (against a player: one asks, the other accepts) |
| `forfeit` | on | the fighters may give up once the song runs |

## Modifiers

```java
.modifiers(Modifier.DOUBLE_TIME, Modifier.ONE_SHOT)
```

Both fighters play with exactly these. The players' own picks in the song select never apply to your fight - leave
`.modifiers` out and it's played without any. `EASY` beats `HARD` and `ONE_SHOT` beats `SICK_ONLY` when you name both,
`DOUBLE_TIME` beats `SLOW`. `AUTOPLAY` and `ADAPTIVE_SPEED` are left out - a fight always counts.
`SHUFFLE` takes a seed the server makes, the same for both fighters and everyone watching. The points carry the
modifiers' factor like everywhere ([`Modifier`](types.md#modifier)); `fight.modifiers()` and every result's
`modifiers()` say what was played.

## Asking the players first

```java
.ask(true)
```

Every player in the fight gets a question: your mod's name, the opponent, the song - **Fight** or **Not now**, 30
seconds to answer. The start waits (`PENDING`) until all said yes. A "Not now" or no answer refuses it (`DECLINED`,
`NO_ANSWER`). The server's admin can make every addon fight ask (`addonFightsAlwaysAsk`) - whatever your mod says.

## Leaderboards

```java
.board(Board.own("finale"))
```

| | Needs | |
|---|---|---|
| `Board.none()` | - | the default: no leaderboard, no ranks |
| `Board.own("finale")` | `results.write` | your mod's own board, kept apart from the normal ones - read it with `api.boards()` |
| `Board.song()` | `results.write` | the song's normal leaderboard, like a Speaker fight (the server's admin can close it to mods) |

Only runs the server resimulated itself and that were played to the end ever count - a stopped or cancelled fight never
does.

```java
List<LeaderboardEntry> best = api.boards().top("finale", fight.song(), 10);
```

| `api.boards()` | |
|---|---|
| `top(board, chart, limit)` | the best of your board on that chart, best first (up to 100) |
| `best(board, chart, playerUuid)` | one player's entry |
| `names()` | your boards that have entries |

## The result

`onResult` is called **exactly once** per fight that started - however it ends: played to the end, given up, stopped by
you, cancelled by an admin, a player left, the server stops. It gets a [`FightResult`](types.md#fightresult):

```java
.onResult(result -> {
	FighterResult me = result.first();
	switch (me.outcome()) {
		case WON -> giveLoot(player);
		case LOST, FORFEITED -> player.sendSystemMessage(Component.literal("The boss laughs."));
		case DRAW, CANCELLED -> { }
	}
})
```

| `FightResult` | |
|---|---|
| `reason()` | why it ended - `SONG_END`, `FORFEIT`, `PLAYER_OFFLINE`, `STOPPED_BY_ADDON`, `PAUSE_TIMEOUT`, `ADMIN`, `RESTARTED`, `SERVER_STOPPING`, `NOT_STARTED`, `TIMED_OUT`, `NOT_SCORED` |
| `winner()` | the winner's `FighterRef`, `null` for a draw or when nobody won |
| `first()`, `second()` | each fighter's [`FighterResult`](types.md#fighterresult): outcome, score, accuracy, hits, rank, `verified` |
| `cancelled()`, `isDraw()` | ended without a winner and not as a draw / played to the end with equal results |
| `message()` | the reason the players saw (your stop's text) |
| `countsForBoard()` | the results went on a leaderboard |

`verified()` on a fighter's line says the server resimulated that run itself (the dummy: the server played it) - check it
before you hand out anything valuable. A fight cut short (given up, stopped) has the numbers its games reported,
`verified` = false.

Against a player, one who **leaves** loses (`PLAYER_OFFLINE`, the other one wins); against the dummy a player who leaves
ends the fight without a winner.

## Get the song ready first

Showing a cutscene before the fight? Let the players' games fetch the song meanwhile, so the fight starts without a
loading pause:

```java
api.fights().prepare(List.of(player), "finale");
// ... your cutscene ...
api.fights().start(request);
```

The files a player's game doesn't have yet come in the background (players without MineFunkin are skipped). Needs
`fights.start`.
