---
icon: material/history
---

# Versions and loaders

## How versions work

The API has a version of two numbers, `major.minor` - now **1.1**. A new minor version only adds things,
so an addon written for 1.0 works with 1.1. A new major version may change or remove things.

Your mod names the version it was written against (`"minefunkin:api": "1.1"`, see
[Set up your mod](setup.md#3-ask-for-the-api)). MineFunkin serves it when the major number matches and
the minor isn't higher than its own. Otherwise your mod gets no handle, and the log says why.

## Detecting the version

- **Before loading any MineFunkin class:** MineFunkin's own mod metadata carries the same key. It holds
  the string `"1.1"`; it's missing before 1.1.

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

- **With the handle:** `api.version()` returns `"1.1"` at runtime. Prefer it over the constant
  `MineFunkinApi.VERSION`, which the Java compiler copies into your class (it would still say what you
  compiled against).
- **The log** states it on every start: `MineFunkin API 1.1 (server): offline - no mod asked for it`, or
  `online for [yourmod]` with the mods that asked.

## Changes from 1.0

1.0 was the static `MineFunkinEvents` (`SONG_COMPLETED` / `SONG_RANK_ACHIEVED` with `SongCompletion`).
It is gone: anyone could register on it without asking, which kept the API always on. To move to 1.1:

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
for the API and reads the version they want. Everything else - the types, the events, the queries - is
plain Java and Minecraft and the same on every build. A port to another loader swaps that one class for
its loader's way of finding addons.
