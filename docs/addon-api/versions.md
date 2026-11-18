---
icon: material/history
---

# Versions and loaders

## How versions work

The API has a version of two numbers, `major.minor` - now **2.0**. A new minor version only adds things,
so an addon written for 2.0 works with a later 2.x. A new major version may change or remove things.

!!! note "2.0 is the beginning"
    Versions before 2.0 were prototypes - 2.0 is the true beginning of the Addon API.

Your mod names the version it was written against (`"minefunkin:api": "2.0"`, see
[Set up your mod](setup.md#3-ask-for-the-api)). MineFunkin serves it when the major number matches and
the minor isn't higher than its own. Otherwise your mod gets no handle, and the log says why.

## Detecting the version

- **Before loading any MineFunkin class:** MineFunkin's own mod metadata carries the same key. It holds
  the string `"2.0"`.

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

- **With the handle:** `api.version()` returns `"2.0"` at runtime. Prefer it over the constant
  `MineFunkinApi.VERSION`, which the Java compiler copies into your class (it would still say what you
  compiled against).
- **The log** states it on every start: `MineFunkin API 2.0 (server): offline - no mod asked for it`, or
  `online for [yourmod]` with the mods that asked.

## Loaders

| Build | How a mod asks | Where the version is |
|---|---|---|
| Fabric 1.21.11 | the `minefunkin` / `minefunkin-client` entrypoints | `"minefunkin:api"` under `custom` in `fabric.mod.json` |
| NeoForge 1.21.1 | `@MineFunkinPlugin` on the class, found in NeoForge's mod scan data | `"minefunkin:api"` under `[modproperties.<modid>]` in `neoforge.mods.toml` |

Only one class inside MineFunkin (`api.internal.ApiHost`) knows the loader: it finds the mods that ask
for the API and reads the version and the rights they want. Everything else - the types, the events, the queries - is
plain Java and Minecraft and the same on every build. A port to another loader swaps that one class for
its loader's way of finding addons.
