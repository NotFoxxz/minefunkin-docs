---
icon: material/shield-key-outline
---

# Rights

Reading and listening are free: every addon can hear every event and read every fight. **Changing things needs a
right** - starting a fight, pausing it, putting results on a leaderboard. Your mod lists the rights it wants, and the
server's admin can take any of them away.

## Ask for rights

List them in your `fabric.mod.json`, next to the API version:

```json
{
  "custom": {
    "minefunkin:api": "3.0",
    "minefunkin:permissions": ["fights.start", "fights.control", "results.write"]
  }
}
```

On NeoForge the list goes into your `neoforge.mods.toml`:

```toml
[modproperties.mymod]
"minefunkin:api" = "3.0"
"minefunkin:permissions" = ["fights.start", "fights.control", "results.write"]
```

Ask only for what you use - the admin sees the list (`/minefunkin addons`).

| Right | Lets your mod |
|---|---|
| `fights.start` | start fights ([Starting fights](starting-fights.md)) and get a song ready ahead of one (`prepare`) |
| `fights.control` | pause, resume and stop **its own** fights, change a fighter's health ([Controlling fights](controlling-fights.md)) |
| `results.write` | let its fights count for a leaderboard: its own board, or the song's normal one |
| `players.teleport` | put the players at places it chooses, before and after its own fights |
| `songs.register` | register its own songs (coming later) |
| `scripts.run` | run its own event scripts in its own fights (coming later) |
| `camera.take` | take the camera during a pause of its own fight (coming later) |
| `world.particles` | real particles in the world (coming later) |
| `world.blocks` | change real blocks (coming later) |
| `world.entities` | spawn or move real entities (coming later) |
| `client.hud` | its own layer in the song's HUD (coming later) |

The rights marked "coming later" can already be listed and checked - the features that use them follow in later
versions. A name MineFunkin doesn't know (a typo) is named in the log when the game starts and never granted:

```
[main/WARN] (MineFunkin/API) MineFunkin API: mymod asks for the right "fight.start" - there is no such right (known: [fights.start, ...]); it is ignored
```

## When a right is missing

The method throws a `PermissionDeniedException` (an unchecked exception) with a clear message. Nothing else happens -
MineFunkin keeps running, and so does your mod if you catch it:

| Message | Why |
|---|---|
| `mymod: fights.start is not declared in fabric.mod.json ("minefunkin:permissions")` | the right isn't in your list |
| `mymod: fights.start is denied by the server` | the admin took it away |
| `mymod: switched off by the server (server.json "addons")` | the admin switched your mod off |
| `mymod: fight 12 was started by othermod - an addon controls only its own fights` | you tried to control another addon's fight (or a Speaker fight) |

```java
try {
	api.fights().start(request);
} catch (PermissionDeniedException e) {
	LOGGER.warn("No boss fights on this server: {}", e.getMessage());
}
```

Ask before you try with `api.has(...)` - it's `true` while the right is declared and not taken away:

```java
if (api.has(Permission.FIGHTS_START)) {
	api.fights().start(request);
}
```

`api.permissions()` gives every right your mod has right now.

## What the server's admin decides

Every right your mod lists holds - until the admin takes it away in the server's `server.json` (singleplayer: the
same file of the world's game). `/minefunkin reload` reads it again, no restart needed:

```json
{
  "addons": {
    "bossmod": { "enabled": true, "deny": ["players.teleport"] },
    "othermod": { "enabled": false }
  },
  "addonFightsAlwaysAsk": false,
  "addonSongBoards": true
}
```

| Setting | |
|---|---|
| `addons.<mod id>.enabled` | `false` switches the mod's use of MineFunkin off: its listeners aren't called, every change it tries throws |
| `addons.<mod id>.deny` | rights taken away from that mod |
| `addonFightsAlwaysAsk` | `true` = every fight a mod starts asks its players first (see [Starting fights](starting-fights.md#asking-the-players-first)) |
| `addonSongBoards` | `false` = no mod may put results on the songs' normal leaderboard (their own boards still work) |

`/minefunkin addons` (admins) shows every addon: what it wants, what it may, the fights it runs right now, and its
errors.

## Mistakes stay with your mod

- A listener or callback of yours that throws is caught and logged under your mod id - the fight goes on (or ends
  cleanly, with both players back where they stood).
- A mod whose code fails **10 times** in one session is switched off for the rest of it: its listeners aren't called
  any more, its changes are refused.
- A listener that takes longer than a server tick (50 ms) is named in the log. Listeners run on the server thread -
  hand slow work to your own thread.
