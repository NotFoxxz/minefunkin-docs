---
icon: material/sword-cross
---

# Example addon

**Boss Fight Demo** is a complete small addon you can copy. Name a zombie "Gatekeeper" with a name tag and hit it:
MineFunkin asks the player, then the zombie's stage figure sings the song against them, with a purple boss bar for
everyone around. The first time the Gatekeeper's bar falls to half, it catches its breath and heals a little. Win the
song and the zombie dies and drops its loot.

It shows the pieces most boss addons need: [starting a fight](starting-fights.md) against
[a mob](boss-opponents.md), asking first, the boss bar, a listener on the running fight,
[changing the boss's health](controlling-fights.md), the result and an [animation file](boss-opponents.md#animations).

## Try it

1. Make a folder `bossdemo` with the files below (the same folders as their names say).
2. Put MineFunkin's jar into `bossdemo/libs/`.
3. Build it: `gradlew build` (copy the Gradle wrapper from any Fabric mod, or use your own Gradle). The mod is
   `build/libs/bossdemo-1.0.0.jar`.
4. Put it into the `mods` folder of the server **and** of the players' games, next to MineFunkin. The players need it for
   the animations; the server starts the fights.
5. Put a song into the server's `MineFunkin/server/server_songs/boss-theme/` - or change `SONG` in the addon to a
   song the server has.
6. In the game: name a zombie "Gatekeeper" with a name tag, hit it, say yes.

The log says `Boss Fight Demo ready` when MineFunkin served the API, and one line per fight.

## The files

### settings.gradle

`settings.gradle`

```groovy
pluginManagement {
	repositories {
		maven {
			name = 'Fabric'
			url = 'https://maven.fabricmc.net/'
		}
		mavenCentral()
		gradlePluginPortal()
	}
}

rootProject.name = 'bossdemo'
```

### gradle.properties

`gradle.properties`

```properties
org.gradle.jvmargs=-Xmx2G

minecraft_version=1.21.11
loader_version=0.19.3
loom_version=1.17-SNAPSHOT
fabric_api_version=0.141.6+1.21.11

mod_version=1.0.0
```

### build.gradle

`build.gradle`

```groovy
plugins {
	id 'net.fabricmc.fabric-loom-remap' version "${loom_version}"
}

version = project.mod_version
group = 'com.example'

base {
	archivesName = 'bossdemo'
}

repositories {
	mavenCentral()
}

dependencies {
	minecraft "com.mojang:minecraft:${project.minecraft_version}"
	mappings loom.officialMojangMappings()
	modImplementation "net.fabricmc:fabric-loader:${project.loader_version}"
	modImplementation "net.fabricmc.fabric-api:fabric-api:${project.fabric_api_version}"

	// MineFunkin's jar in libs/: compile against it, never ship or require it.
	modCompileOnly fileTree("libs") { include "*.jar" }
}

processResources {
	inputs.property "version", project.version

	filesMatching("fabric.mod.json") {
		expand "version": project.version
	}
}

tasks.withType(JavaCompile).configureEach {
	it.options.release = 21
}

java {
	sourceCompatibility = JavaVersion.VERSION_21
	targetCompatibility = JavaVersion.VERSION_21
}
```

### fabric.mod.json

`src/main/resources/fabric.mod.json`

```json
{
  "schemaVersion": 1,
  "id": "bossdemo",
  "version": "${version}",
  "name": "Boss Fight Demo",
  "description": "Name a zombie \"Gatekeeper\" and hit it: you fight it in MineFunkin. Win and it drops its loot.",
  "environment": "*",
  "entrypoints": {
    "minefunkin": ["com.example.bossdemo.BossDemoAddon"]
  },
  "custom": {
    "minefunkin:api": "2.0",
    "minefunkin:permissions": ["fights.start", "fights.control"]
  },
  "depends": {
    "fabricloader": ">=0.19.3",
    "fabric-api": "*",
    "minecraft": "1.21.11"
  },
  "suggests": {
    "minefunkin": "*"
  }
}
```

### BossDemoAddon.java

`src/main/java/com/example/bossdemo/BossDemoAddon.java`

```java
package com.example.bossdemo;

import com.notfoxxz.minefunkin.api.FightRequest;
import com.notfoxxz.minefunkin.api.FighterKind;
import com.notfoxxz.minefunkin.api.FighterResult;
import com.notfoxxz.minefunkin.api.MineFunkinAddon;
import com.notfoxxz.minefunkin.api.MineFunkinApi;
import com.notfoxxz.minefunkin.api.Opponent;
import net.fabricmc.fabric.api.event.player.AttackEntityCallback;
import net.minecraft.network.chat.Component;
import net.minecraft.server.level.ServerLevel;
import net.minecraft.server.level.ServerPlayer;
import net.minecraft.world.InteractionResult;
import net.minecraft.world.entity.monster.zombie.Zombie;
import net.minecraft.world.BossEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * The whole demo. Name a zombie "Gatekeeper" with a name tag and hit it: MineFunkin asks the player, then the zombie's
 * stage figure sings the song against them. Win the song and the zombie dies and drops its loot. The first time the
 * Gatekeeper's bar falls to half, it catches its breath and heals a little (only its bar - the player's run stays fair).
 *
 * Only this class touches MineFunkin's types, so the mod works without MineFunkin (Fabric never calls the entrypoint).
 */
public final class BossDemoAddon implements MineFunkinAddon {
	private static final Logger LOGGER = LoggerFactory.getLogger("bossdemo");
	/** The boss's name - put it on a zombie with a name tag. */
	private static final String BOSS_NAME = "Gatekeeper";
	/** A song in the server's server_songs folder (its folder name). */
	private static final String SONG = "boss-theme";

	@Override
	public void onMineFunkinApi(MineFunkinApi api) {
		AttackEntityCallback.EVENT.register((player, level, hand, target, hit) -> {
			if (level.isClientSide() || !(player instanceof ServerPlayer serverPlayer) || !(target instanceof Zombie zombie)
					|| !zombie.hasCustomName() || !BOSS_NAME.equals(zombie.getCustomName().getString())) {
				return InteractionResult.PASS;
			}

			if (!api.fights().isFighting(serverPlayer.getUUID())) {
				startFight(api, serverPlayer, zombie);
			}

			// The hit itself never lands: the boss is beaten by singing.
			return InteractionResult.FAIL;
		});
		LOGGER.info("Boss Fight Demo ready: name a zombie \"{}\" and hit it", BOSS_NAME);
	}

	private static void startFight(MineFunkinApi api, ServerPlayer player, Zombie boss) {
		FightRequest request = FightRequest.builder(player, Opponent.entity(boss), SONG)
				.ask(true)
				.bossBar(null, BossEvent.BossBarColor.PURPLE)
				.onResult(result -> {
					FighterResult mine = result.first();
					LOGGER.info("Gatekeeper fight {}: {} {} ({} points, verified {})", result.fight().id(), player.getName().getString(),
							mine.outcome(), mine.score(), mine.verified());

					if (mine.won() && mine.verified() && boss.isAlive()) {
						boss.kill((ServerLevel) boss.level());
						player.sendSystemMessage(Component.literal("The Gatekeeper falls."));
					} else if (mine.outcome() == FighterResult.Outcome.LOST) {
						player.sendSystemMessage(Component.literal("The Gatekeeper laughs at you."));
					}
				})
				.build();

		api.fights().start(request)
				.onStarted(fight -> {
					LOGGER.info("Gatekeeper fight {} started for {}", fight.id(), player.getName().getString());
					boolean[] rested = {false};
					fight.onHealthChanged((f, who, before, after, byAddon) -> {
						if (who.kind() == FighterKind.ENTITY && !byAddon && !rested[0] && after <= 10) {
							rested[0] = true;
							f.addHealth(who.id(), 4);
							LOGGER.info("Gatekeeper fight {}: the Gatekeeper catches its breath ({} -> {})", f.id(), after, after + 4);
						}
					});
				})
				.onRefused(no -> player.displayClientMessage(Component.literal("Not now: " + no.message()), true));
	}
}
```

### zombie.json

`src/main/resources/assets/bossdemo/minefunkin/animations/zombie.json`

```json
{
	"format": 1,
	"entity": "minecraft:zombie",
	"animations": {
		"idle": {
			"time": "beats",
			"length": 2,
			"parts": {
				"head": {"rotation": {"0": [0, 0, 0], "1": {"value": [6, 0, 0], "ease": "sineInOut"}, "2": [0, 0, 0]}},
				"root": {"rotation": {"0": [0, 0, -2], "1": {"value": [0, 0, 2], "ease": "sineInOut"}, "2": {"value": [0, 0, -2], "ease": "sineInOut"}}}
			}
		},
		"left": {
			"parts": {
				"right_arm": {"rotation": {"0": [0, 0, 100], "180": {"value": [30, 0, 75], "ease": "cubicOut"}}},
				"head": {"rotation": {"0": [0, 35, 0], "180": {"value": [0, 25, 0], "ease": "cubicOut"}}},
				"root": {"rotation": {"0": [0, 0, -8], "180": {"value": [0, 0, -5], "ease": "cubicOut"}}}
			}
		},
		"down": {
			"parts": {
				"head": {"rotation": {"0": [30, 0, 0], "180": {"value": [20, 0, 0], "ease": "cubicOut"}}},
				"root": {"position": {"0": [0, -2, 0], "180": {"value": [0, -1, 0], "ease": "cubicOut"}}}
			}
		},
		"up": {
			"parts": {
				"right_arm": {"rotation": {"0": [-95, 0, 25], "180": {"value": [-80, 0, 15], "ease": "cubicOut"}}},
				"left_arm": {"rotation": {"0": [-95, 0, -25], "180": {"value": [-80, 0, -15], "ease": "cubicOut"}}},
				"head": {"rotation": {"0": [-30, 0, 0], "180": {"value": [-22, 0, 0], "ease": "cubicOut"}}},
				"root": {"position": {"0": [0, 3, 0], "180": {"value": [0, 1, 0], "ease": "cubicOut"}}}
			}
		},
		"right": {
			"parts": {
				"left_arm": {"rotation": {"0": [0, 0, -100], "180": {"value": [30, 0, -75], "ease": "cubicOut"}}},
				"head": {"rotation": {"0": [0, -35, 0], "180": {"value": [0, -25, 0], "ease": "cubicOut"}}},
				"root": {"rotation": {"0": [0, 0, 8], "180": {"value": [0, 0, 5], "ease": "cubicOut"}}}
			}
		},
		"hold": {
			"parts": {
				"head": {"rotation": {"0": [0, 0, -4], "80": [0, 0, 4], "160": [0, 0, -4]}}
			}
		},
		"death": {
			"parts": {
				"root": {"rotation": {"0": [0, 0, 0], "150": {"value": [8, 0, 0], "ease": "quadOut"}, "700": {"value": [-90, 0, 0], "ease": "bounceOut"}}},
				"head": {"rotation": {"0": [0, 0, 0], "700": {"value": [-20, 0, 15], "ease": "cubicOut"}}},
				"right_arm": {"rotation": {"0": [0, 0, 0], "700": {"value": [70, 0, 30], "ease": "cubicOut"}}},
				"left_arm": {"rotation": {"0": [0, 0, 0], "700": {"value": [70, 0, -30], "ease": "cubicOut"}}}
			}
		}
	}
}
```

## Next steps

- Your own mob instead of a zombie: `Opponent.entity(yourMob)` - see [Boss opponents](boss-opponents.md).
- More ideas for the running fight: [Recipes](recipes.md#your-own-fights).
- A fight without asking, on your own board, at your own spot: [Starting fights](starting-fights.md).
