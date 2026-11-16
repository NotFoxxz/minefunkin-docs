---
icon: material/history
---

# Versions and loaders

## How versions work

The API has a version of two numbers, `major.minor` - now **3.0**. A new minor version only adds things,
so an addon written for 3.0 works with a later 3.x. A new major version may change or remove things.

Your mod names the version it was written against (`"minefunkin:api": "3.0"`, see
[Set up your mod](setup.md#3-ask-for-the-api)). MineFunkin serves it when the major number matches and
the minor isn't higher than its own. Otherwise your mod gets no handle, and the log says why.

## Detecting the version

- **Before loading any MineFunkin class:** MineFunkin's own mod metadata carries the same key. It holds
  the string `"3.0"` (`"2.0"` and `"1.1"` before; it's missing before 1.1).

    === "Fabric"

        ```java
        FabricLoader.getInstance().getModContainer("minefunkin")
                .map(c -> c.getMetadata().getCustomValue("minefunkin:api"))
        ```

    === "NeoForge"

        ```java
        ModList.get().getModContainerById("minefunkin")
                .map(c -> c.getModInfo().getModProperties().get("minefunkin:api"))
        ```

- **With the handle:** `api.version()` returns `"3.0"` at runtime. Prefer it over the constant
  `MineFunkinApi.VERSION`, which the Java compiler copies into your class (it would still say what you
  compiled against).
- **The log** states it on every start: `MineFunkin API 3.0 (server): offline - no mod asked for it`, or
  `online for [yourmod]` with the mods that asked.

## Changes from 2.0

3.0 lets addons **start and control fights** ([Starting fights](starting-fights.md),
[Controlling fights](controlling-fights.md)) with [rights](rights.md) - also against a mob as the boss, with its own
animations ([Boss opponents](boss-opponents.md)). On the way, a few things changed - to move to
3.0:

- ask for `"minefunkin:api": "3.0"` (and list the rights you need in `"minefunkin:permissions"`);
- `api.fights().cancel(id)` is gone: an addon stops only its own fights (`fight.stop(...)`); calling any fight off is
  for the server's admin (`/minefunkin fights cancel <id>`);
- `FightInfo` is now [`Fight`](types.md#fight) (a live object), `FightEnd` is now [`FightResult`](types.md#fightresult)
  (reasons: `COMPLETED` -> `SONG_END`, `DISCONNECT` -> `PLAYER_OFFLINE`, `CANCELLED` -> the precise one);
  `challenger()` / `challenged()` are `first()` / `second()`;
- `allowFight` gets one [`FightProposal`](types.md#fightproposal) (also for addons' fights - then `second()` is
  `null` against the dummy); `onFightStarted` gets the `Fight`; `onFightEnded` gets the `FightResult`;
- the API names none of MineFunkin's internal types any more: `Rank` is [`RunRank`](types.md#runrank), `Judgment` is
  [`Rating`](types.md#rating) (same values); `HitStats.of(...)` and `ChartInfo.of(...)` are gone;
- `onFightStarted` / `onFightEnded` also come for every fight an addon starts.

## Changes from 1.1

The ranks are the full-combo ranks now (MineFunkin ALPHA-0.1.0f): `Rank` (now [`RunRank`](types.md#runrank)) has `SFC`,
`GFC`, `FC`, `SDCB`, `CLEAR` and `FAILED` instead of `PERFECT_GOLD`, `PERFECT`, `EXCELLENT`, `GREAT`, `GOOD`
and `SHIT`. A rank comes from the misses and judgments now, not from the accuracy. To move to 2.0:

- ask for `"minefunkin:api": "2.0"`;
- compare with the new values (`result.rank() == Rank.SFC` where you had `Rank.PERFECT_GOLD`);
- expect `null` for a best saved before (`LeaderboardEntry.rank()`, `LocalBest.rank()`, `api.players().bestRank`):
  only a run with every note a "Sick!" became an `SFC`, the old ranks didn't keep the misses.

## Changes from 1.0

1.0 was the static `MineFunkinEvents` (`SONG_COMPLETED` / `SONG_RANK_ACHIEVED` with `SongCompletion`).
It is gone: anyone could register on it without asking, which kept the API always on. To move to 1.1 (and then 2.0):

- declare the `minefunkin` entrypoint (Fabric) or `@MineFunkinPlugin` (NeoForge);
- register through `api.events().onSongCompleted` and `onRankImproved`;
- read `SongResult`, which carries everything `SongCompletion` had, plus `mode`, `validation`, `hits`,
  `chart` and `opponent`.

One behaviour change: a fight that ended early (giving up, a disconnect) no longer reports a completed
song.

## Loaders

| Build | How a mod asks | Where the version is |
|---|---|---|
| Fabric 1.21.11 | the `minefunkin` / `minefunkin-client` entrypoints | `"minefunkin:api"` under `custom` in `fabric.mod.json` |
| NeoForge 1.21.1 | `@MineFunkinPlugin` on the class, found in NeoForge's mod scan data | `"minefunkin:api"` under `[modproperties.<modid>]` in `neoforge.mods.toml` |

Only one class inside MineFunkin (`api.internal.ApiHost`) knows the loader: it finds the mods that ask
for the API and reads the version and the rights they want. Everything else - the types, the events, the queries - is
plain Java and Minecraft and the same on every build. A port to another loader swaps that one class for
its loader's way of finding addons.
