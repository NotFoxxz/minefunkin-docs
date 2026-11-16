---
icon: material/skull-outline
---

# Boss opponents

Your mob as the opponent: the player fights **your boss**, not the dummy. It works with your own mobs (also ones drawn
with GeckoLib) and with every Minecraft mob - a zombie, a skeleton, a villager. You give the mob its moves in
MineFunkin's animation format, or make them in Blockbench and let MineFunkin read the export.

```java
api.fights().start(FightRequest.builder(player, Opponent.entity(boss), "boss-theme")
		.bossBar(Component.literal("The Gatekeeper"), BossEvent.BossBarColor.RED)
		.onResult(result -> {
			if (result.first().won() && result.first().verified()) {
				boss.kill((ServerLevel) boss.level());
			}
		})
		.build());
```

Needs the right `fights.start` like every fight you start (see [Rights](rights.md)). Everything from
[Starting fights](starting-fights.md) works the same: the place, the rules, asking first, leaderboards, the result.

## What happens in the fight

- **Not the mob itself fights, but a stage figure with its model.** Every player who sees the fight sees the figure:
  your mob's model, its looks (a baby zombie stays a baby, a villager keeps its job, the boss keeps its sword and
  helmet), moving with your animations. The figure can't be hurt, pushed or unloaded - nothing in the world can break the
  fight.
- **The boss plays perfectly.** Every note of its side is a "Sick!". The player's game plays the boss's side, the
  server checks only the player's run - like a fight against the dummy.
- **The figure stands where your mob stands**, when that spot fits a fight (a few blocks from the player, flat ground,
  a clear view). Otherwise like the dummy: in front of the player, or a spot nearby. Your own spots and Speakers work
  too ([Where](starting-fights.md#where)).
- **The boss's health:** full at the start, every note the player hits takes a share, it's empty when the player hit
  them all. You read it as the boss fighter's `live().health()` (0-20) and in `onHealthChanged`. `setHealth` /
  `addHealth` on the boss heal or hurt it for the story: the boss bar and `live().health()` move, a heal stays on top of
  later hits. It's only what's shown - who wins and the player's score stay the same.
- **Who wins:** the player, by getting through the song - its health didn't run out. No score could beat a boss that
  never misses, so the score doesn't decide this one. The player's health runs out: the boss wins.
- **When the player wins, the figure plays its death.** It stays a few seconds after the fight, then it's gone.

The boss is a fighter of kind `ENTITY`. Its `FighterRef` has an id made for the fight and the mob's name. The mob
itself: `fight.opponentEntity()`.

## The real mob during the fight

By default MineFunkin makes your mob **invisible, silent and turns its AI off** while the fight runs - so only the
figure is there. Afterwards your mob gets all three back **exactly as they were**, however the fight ends: played to the
end, given up, a player left, you stopped it, the server stopped. If the server stopped or crashed in the middle, the
mob is saved with a mark and gets its state back the next time it's loaded. Several players can fight the same mob at
once - it comes back when the last fight ends.

What happens to the mob after the fight is yours: it dies, drops its loot, runs away.

```java
.hideEntity(false)   // MineFunkin doesn't touch the mob at all
```

Want something else - remove the mob while the fight runs and spawn it again afterwards? Turn the default off and do it
yourself in `onStarted` and `onResult`.

### When the mob disappears anyway

A player kills it with `/kill`, another mod removes it, its chunk unloads: **the fight goes on**, the figure plays to the
end. You get told once per fight:

```java
api.fights().start(request).onStarted(fight -> fight.onEntityGone((f, why) -> {
	if (why == EntityGone.KILLED) {
		f.stop(StopOutcome.winner(f.first().id(), "The boss fell before the song ended"));
	}
}));
```

| `EntityGone` | |
|---|---|
| `KILLED` | it died |
| `REMOVED` | removed from the world (a command, a mod) |
| `UNLOADED` | its chunk was unloaded - it's saved and comes back with the chunk (hidden again while the fight runs) |
| `CHANGED_WORLD` | it went to another world |

## Boss bar

```java
.bossBar(Component.literal("The Gatekeeper"), BossEvent.BossBarColor.PURPLE)   // null as the name = the mob's name
```

A Minecraft boss bar with the boss's health in the fight, for **every player around the fight** - the same distance as
the players who watch it. The two fighters don't see it: they have the song's own screen. It's gone when the fight ends.
Only with an entity as the opponent (else `build()` throws `IllegalArgumentException`).

## Animations

One file per mob type, in your mod's resources:

```
assets/<your mod id>/minefunkin/animations/<mob>.json
```

The file `assets/gatekeeper/minefunkin/animations/gatekeeper.json` is for the mob `gatekeeper:gatekeeper`. A Minecraft
mob gets **no animations from MineFunkin** - your mod brings them. Put the file in your own folder and say which mob it
is for:

```json
{
  "format": 1,
  "entity": "minecraft:zombie",
  "animations": { }
}
```

A resource pack can bring animation files the same way (and change yours). To try a change without building your mod,
put the file into `MineFunkin/client/animations/<namespace>/<mob>.json` in the game folder - it wins over everything.
Press F3 + T to read all files again.

### The set

| Name | When it plays |
|---|---|
| `idle` | between notes, looped on the song's beat |
| `left`, `down`, `up`, `right` | a note in that lane: starts at the note |
| `hold` | on top of the lane's pose while a long note is held (e.g. a little shake) |
| `miss` | a missed note (the boss doesn't miss today - for later and for scripts) |
| `death` | when the player won - from the end of the fight, it stays on its last frame |
| any other name | an extra, for scripts later (`roar`, `taunt`, ...) |

Left and right are the arrows the players see. The boss faces the player, so "left" on the screen is the mob's own
right side.

**Something missing?** A lane or the miss without an animation: the whole figure does a small hop. No death: it falls
over to its side. No idle: it stands still. A broken file: every animation falls back, and the log says what's wrong.

### Timing

The same as the players' fighters:

- **A tap:** the animation starts at the note (its first keyframe is the pose at once), plays to its last keyframe and
  holds that pose. 420 ms after the note it eases back into the idle in 160 ms.
- **A long note:** the lane's animation plays and stays on its last keyframe for as long as the note is held, with
  `hold` on top. Let go, it stays a moment (a fifth of a beat) and eases back.
- **The death** plays once and stays.

`"tapHold"` and `"easeOut"` (ms) change the two numbers for your mob.

### The file

A complete file - a zombie that turns its head on the idle and swings an arm to the left:

```json
{
  "format": 1,
  "entity": "minecraft:zombie",
  "time": "ms",
  "tapHold": 420,
  "easeOut": 160,
  "animations": {
    "idle": {
      "time": "beats",
      "length": 2,
      "parts": {
        "head": { "rotation": { "0": [0, 0, 0], "1": { "value": [6, 0, 0], "ease": "sineInOut" }, "2": [0, 0, 0] } }
      }
    },
    "left": {
      "parts": {
        "right_arm": { "rotation": { "0": [0, 0, 100], "180": { "value": [30, 0, 75], "ease": "cubicOut" } } },
        "head": { "rotation": { "0": [0, 35, 0], "180": { "value": [0, 25, 0], "ease": "cubicOut" } } }
      }
    },
    "up": {
      "parts": {
        "root": { "position": { "0": [0, 3, 0], "180": { "value": [0, 1, 0], "ease": "cubicOut" } } }
      }
    },
    "hold": {
      "parts": {
        "head": { "rotation": { "0": [0, 0, -4], "80": [0, 0, 4], "160": [0, 0, -4] } }
      }
    },
    "death": {
      "parts": {
        "root": { "rotation": { "0": [0, 0, 0], "700": { "value": [-90, 0, 0], "ease": "bounceOut" } } }
      }
    }
  }
}
```

| Field | |
|---|---|
| `format` | `1` |
| `entity` | the mob this file is for (`"minecraft:zombie"`); left out = the file's own name |
| `time` | `"ms"` (the default) or `"beats"` - the unit of the times below |
| `tapHold`, `easeOut` | ms, see [Timing](#timing) |
| `blockbench` | read animations from a Blockbench export - [below](#from-blockbench) |
| `animations` | name -> animation |

**An animation:**

| Field | |
|---|---|
| `parts` | the model's parts by their name -> their moves |
| `time` | `"ms"` or `"beats"` for this animation (else the file's) |
| `length` | where it ends (in its unit); left out = its last keyframe |
| `loop` | start again at the end - on by default for `idle` and `hold`, off for the rest |

**A part** has up to three channels:

| Channel | Values | |
|---|---|---|
| `rotation` | `[x, y, z]` in degrees | a turn |
| `position` | `[x, y, z]` in pixels (1/16 block), y = up | a move |
| `scale` | `[x, y, z]` or one number | `1` = its size |

The values add to the pose the model has on its own (a zombie's arms are already forward). The signs are the ones
Blockbench shows for your model.

**A channel** is one value (it stays) or keyframes - time -> value:

```json
"rotation": {
  "0": [0, 0, 0],
  "150": { "value": [-30, 0, 0], "ease": "backOut" },
  "300": { "pre": [-30, 0, 0], "value": [10, 0, 0] }
}
```

| In a keyframe | |
|---|---|
| `value` | the value |
| `pre` | the value arriving here, when it jumps (`value` is the one leaving) |
| `ease` | how the move **into** this keyframe goes: one of the easings of event scripts (`linear`, `sineInOut`, `cubicOut`, `backOut`, `bounceOut`, ... - see [Easing curves](../api/choices.md#easing)), `smooth` (a soft curve through the keyframes) or `step` (stays, then jumps here) |

**The parts' names** are the names in your mob's model: in Blockbench the names of its groups (bones). Minecraft's
mobs use names like `head`, `body`, `right_arm`, `left_arm`, `right_leg`, `left_leg`. The special name **`root`** is the
whole figure - it turns and moves at its feet (a hop, a lean, falling over).

Limits: a file is at most 1 MiB, 64 animations, 128 parts per animation, 256 keyframes per channel.

## From Blockbench

Animate your mob in Blockbench, then **Animation > Export Animations** - you get a `.animation.json`. Put it next to your
animation file and name it there:

```json
{
  "format": 1,
  "entity": "gatekeeper:gatekeeper",
  "blockbench": {
    "file": "gatekeeper.animation.json",
    "animations": {
      "idle": "animation.gatekeeper.idle",
      "left": "animation.gatekeeper.swing_left",
      "right": "animation.gatekeeper.swing_right",
      "death": "animation.gatekeeper.fall"
    },
    "parts": { "rightArm": "right_arm" }
  }
}
```

| In `blockbench` | |
|---|---|
| `file` | the export, in the same folder (or a folder below it) |
| `animations` | which animation of the export is which of ours. Left out: an animation named like one of ours (`idle`, or ending with it: `animation.gatekeeper.idle`) becomes that one, every other one an extra under its last name part |
| `parts` | a Blockbench bone name -> the model's part name, when they differ |

MineFunkin reads the export when the resources load. From each bone it takes rotation, position and scale; the
keyframes' "Linear", "Catmullrom" (= `smooth`) and "Step"; and the easings Blockbench (with its GeckoLib plugin) writes,
like "easeInOutSine". A loop or "hold on last frame" is kept. Values with a formula (Molang) can't be read: the log says
so and the value is 0. Your own `animations` next to `blockbench` are read too - one of yours wins over the export's with
the same name.

## GeckoLib mobs

A mob drawn with a GeckoLib model works the same: the parts are its bones by their names, your values add to what the
mob's own GeckoLib animations set. GeckoLib stays your mod's dependency - MineFunkin works without it and only uses it
when it's installed.

## Checking your animations

- The game log names every file it reads (`Stage figure animations for 2 entity type(s): ...`) and every problem
  (`Stage figure animation ...: ...`).
- A mob with no file fights with the fallbacks (hop, fall over).
- Try changes from `MineFunkin/client/animations/` and F3 + T - no restart, no build.
