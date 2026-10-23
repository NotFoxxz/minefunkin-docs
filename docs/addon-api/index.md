---
icon: material/puzzle-outline
---

# Addon API 1.1

![Addon API](../assets/api-logo.png){ .mf-page-logo }

Making a mod and want it to know when someone just cleared a song? The Addon API lets **other mods react to what
happens in MineFunkin**: a song was played to the end, a fight between two players is over, a player hit a note. A
progression mod could hand out XP for a cleared song, a server mod could forbid fights in the Nether, a HUD mod could
show your combo, a stats mod could count your "Sick!"s.

This part is for mod developers (Java). If you want to change what happens *inside* a song - flashes, lanes, the
camera - you're looking for [event scripts](../guides/index.md), no Java needed.

## What you can build

| Idea | Side | With |
|---|---|---|
| XP, money or items for a cleared song | server | [`onSongCompleted`](server.md#events) |
| An achievement for the first "Perfect" on a song | server | [`onRankImproved`](server.md#events) |
| No fights in the Nether, at spawn, during a minigame | server | [`allowFight`](server.md#fights) |
| A prize for the winner of a fight | server | [`onFightEnded`](server.md#fights) |
| A chat message when two players start a fight | server | [`onFightStarted`](server.md#events) |
| A list of the best players on a song | server | [`songs().leaderboard`](server.md#queries) |
| A sound or a particle on every "Sick!" | client | [`onNoteJudged`](client.md#events) |
| Your own combo or accuracy display | client | [`currentRun()`](client.md#queries) |
| "Playing Bopeebo (Hard)" in a status or presence mod | client | [`onSongStarted`](client.md#events) |

Complete code for these is on [Recipes](recipes.md).

## How it works

1. **Your mod asks for the API.** One line in your mod's metadata file and one small class (see
   [Set up your mod](setup.md)).
2. **MineFunkin hands your class a handle** while the game starts: an object called `api` that belongs
   to your mod.
3. **You tell the handle what you want to hear about:** `api.events().onSongCompleted(...)`. From
   then on MineFunkin calls your code every time that happens.

The API is **opt-in**: if no installed mod asks for it, it stays completely off - no events fire, nothing is
recorded for it, it costs the game nothing. And your mod doesn't *need* MineFunkin either: without it, your addon class
is simply never loaded, and the rest of your mod works as usual.

It's the same API on both builds of MineFunkin - **Fabric 1.21.11** and **NeoForge 1.21.1**: the same
types, the same events, the same queries. Only the way your mod asks for it differs.

## Server side or client side?

| | [Server side](server.md) | [Client side](client.md) |
|---|---|---|
| Runs on | the server (in singleplayer: the built-in one) | each player's own game |
| Knows about | results that count, fights between players, who practices, the leaderboard | the local player's own runs, live and note by note - practice included |
| Can it be trusted? | yes - results say whether the server checked them | no - it's the player's own game |
| Use it for | rewards, rules, ranks, announcements | HUDs, sounds, statistics, presence |

A mod can use both: one class for each side.

## Words used here

| Word | Meaning |
|---|---|
| **handle** | The `api` object your class gets. Everything goes through it. |
| **listener** | A piece of your code that MineFunkin calls when something happens (a Java lambda). |
| **event** | The something: a song completed, a note judged, a fight ended. |
| **run** | One play of a song, from the end of the countdown to its end. A restart is a new run. |
| **chart**, **song key** | One song + character + difficulty, played on one side. `SongRef.key()` is the text MineFunkin stores scores, leaderboards and replays under (each side its own) - use it for your own per-chart data too. |
| **practice**, **dummy fight**, **player fight** | The three ways to play: at the Retro TV (counts for nothing), at a Speaker against the dummy, at a Speaker against another player. |
| **verified** | The server checked the numbers itself (see [Can I trust a result?](server.md#can-i-trust-a-result)). |
| **server thread**, **render thread** | Where your listener runs: the game's main threads. Keep listeners quick. |

## Where to next

| | |
|---|---|
| [Set up your mod](setup.md) | step by step: compile against MineFunkin, ask for the API, see it work |
| [Recipes](recipes.md) | complete, small addons to copy |
| [Server side](server.md), [Client side](client.md) | every event and query |
| [Types](types.md) | every record and enum, field by field |
| [Versions and loaders](versions.md) | detecting the version, what changed since 1.0, Fabric and NeoForge |
