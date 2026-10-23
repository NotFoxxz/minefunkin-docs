---
icon: material/wrench-outline
---

# Set up your mod

Four steps, from an empty mod to a line in your log every time someone clears a song. It takes about as long as
making a coffee. The examples are for a server-side addon; a client-side one works the same way with the client
interface (shown in the tabs).

## 1. Compile against MineFunkin

Your mod needs MineFunkin's classes to compile, but it shouldn't ship them or require them. Put
MineFunkin's jar into a `libs/` folder in your project and add it as a *compile-only* dependency:

=== "Fabric (Loom)"

    ```groovy
    dependencies {
        modCompileOnly files("libs/minefunkin-0.3.0.jar")
    }
    ```

=== "NeoForge (ModDevGradle)"

    ```groovy
    dependencies {
        compileOnly files("libs/minefunkin-0.3.0.jar")   // the jar of MineFunkin's NeoForge build
    }
    ```

To try your mod together with MineFunkin, drop the same jar into your development run's `mods` folder
(`run/mods`).

## 2. Write the addon class

One class per side. MineFunkin creates it once while the game starts and hands it the handle:

=== "Server side"

    ```java
    package com.example.mymod;

    import com.notfoxxz.minefunkin.api.MineFunkinAddon;
    import com.notfoxxz.minefunkin.api.MineFunkinApi;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;

    public final class MyMineFunkinAddon implements MineFunkinAddon {
        private static final Logger LOGGER = LoggerFactory.getLogger("mymod");

        @Override
        public void onMineFunkinApi(MineFunkinApi api) {
            api.events().onSongCompleted((player, result) ->
                    LOGGER.info("{} cleared {} with {} points", player.getName().getString(),
                            result.song().songId(), result.score()));
        }
    }
    ```

=== "Client side"

    ```java
    package com.example.mymod.client;

    import com.notfoxxz.minefunkin.api.client.MineFunkinClientAddon;
    import com.notfoxxz.minefunkin.api.client.MineFunkinClientApi;
    import org.slf4j.Logger;
    import org.slf4j.LoggerFactory;

    public final class MyMineFunkinClientAddon implements MineFunkinClientAddon {
        private static final Logger LOGGER = LoggerFactory.getLogger("mymod");

        @Override
        public void onMineFunkinClientApi(MineFunkinClientApi api) {
            api.events().onSongEnded((session, end) ->
                    LOGGER.info("Run {} of {} ended: {}", session.runId(), session.song().songId(), end.outcome()));
        }
    }
    ```

    The client class only ever runs on the client - keep it with your other client-only code.

!!! warning "Keep MineFunkin's classes inside your addon classes"
    Your addon classes are only loaded when MineFunkin is installed. Use MineFunkin's types only in them
    (or in classes only they use) - a MineFunkin type in your main mod class would crash your mod for
    players without MineFunkin.

## 3. Ask for the API

=== "Fabric"

    In your `fabric.mod.json`, register the classes as entrypoints - `minefunkin` for the server side,
    `minefunkin-client` for the client side - and name the API version you wrote against:

    ```json
    {
      "entrypoints": {
        "minefunkin": [ "com.example.mymod.MyMineFunkinAddon" ],
        "minefunkin-client": [ "com.example.mymod.client.MyMineFunkinClientAddon" ]
      },
      "custom": {
        "minefunkin:api": "1.1"
      },
      "suggests": { "minefunkin": "*" }
    }
    ```

    Without MineFunkin installed, Fabric never calls these entrypoints, so your mod needs no hard
    dependency.

=== "NeoForge"

    NeoForge has no entrypoints. Put `@MineFunkinPlugin` on each addon class instead (a public class
    with a no-argument constructor):

    ```java
    @MineFunkinPlugin
    public final class MyMineFunkinAddon implements MineFunkinAddon { ... }

    @MineFunkinPlugin
    public final class MyMineFunkinClientAddon implements MineFunkinClientAddon { ... }
    ```

    and name the API version in your `neoforge.mods.toml`, with MineFunkin as an optional dependency:

    ```toml
    [modproperties.mymod]
    "minefunkin:api" = "1.1"

    [[dependencies.mymod]]
    modId = "minefunkin"
    type = "optional"
    versionRange = "[0.3.0,)"
    ordering = "NONE"
    side = "BOTH"
    ```

    MineFunkin finds the annotated classes in NeoForge's mod scan data (like JEI's `@JeiPlugin`) and only
    loads one once it knows the class implements the interface for the running side - so a
    `MineFunkinClientAddon` is never touched on a dedicated server.

`"minefunkin:api": "1.1"` is the API version you wrote against. MineFunkin serves it if the first number
matches and the second isn't higher than its own (`1.0` and `1.1` both get 1.1). A mod asking for a
version MineFunkin doesn't serve gets no handle, and the log says why.

## 4. See it work

Start the game and look in `logs/latest.log`:

```
[Render thread/INFO] (MineFunkin/API) MineFunkin API 1.1 (client): online for [mymod]
[Render thread/INFO] (MineFunkin/API) MineFunkin API 1.1 (server): online for [mymod]
```

One line per side; a mod with only a server-side class gets `online` on the `(server)` line only. A
dedicated server writes the `(server)` line.

If it says `offline - no mod asked for it`, MineFunkin didn't find your request: check the entrypoint
names (Fabric) or the annotation and the `modproperties` block (NeoForge), and the version string.

Now play a song at a Speaker against the dummy (right-click it, "Gegen den Dummy") until the end: your line
shows up in the log.

## Rules for listeners

- **Keep them quick.** Server listeners run on the server thread, client listeners on the render thread
  - the game waits for them. Don't read files or wait for the network inside one; hand slow work to
  your own thread.
- **A listener that throws** is logged under your mod id and skipped. It never breaks MineFunkin or
  another mod's listener.
- **Register any time.** Most mods register everything in `onMineFunkinApi`, but you can keep the
  handle and register later.
- **Check `result.verified()`** before handing out anything valuable on the server - see
  [Can I trust a result?](server.md#can-i-trust-a-result).

Next: [Recipes](recipes.md) for complete small addons, or [Server side](server.md) /
[Client side](client.md) for everything the API offers.
