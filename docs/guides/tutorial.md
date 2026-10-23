---
icon: material/school-outline
---

# Your first event

Let's build one together. By the end of this page you'll have **Beat Flash**: an event that flashes the screen on
every beat, in a colour you pick, until you switch it off again. Nothing fancy - but it's a real event you could put
in a real chart, and on the way you'll meet almost everything the bigger ones are made of.

Each step adds one idea. Take your time; it's about ten minutes.

You'll need a song to try it on. Any folder in `.minecraft/MineFunkin/client/songs/` works. The
[Event Showcase](showcase.md) is a nice one, since it was made for playing around.

## 1. The file

Make a new text file called `beat_flash.event` and put it in the song's folder (next to its `.mfkn` chart), or in an
`events/` folder inside it. Every event file starts the same way: a line saying which version of the language it's
written in (always `format 1.1`), and an `event { }` block with its name.

```lua
format 1.1

event {
    name = "Beat Flash",
}
```

Believe it or not, that's already a working event. It doesn't *do* anything yet, but the chart editor knows it: open
the song in the editor (Retro TV → Editor), click the event type in the inspector, and there's **Beat Flash** under
*Custom*.

!!! tip "Changing the file while the editor is open"
    The editor reads the song's folder when it opens. So after you save your file, press **Reload** at the bottom of
    the inspector. If you made a typo, that's also where you'll see it - with the line and what's wrong.

## 2. Make it do something

When the song reaches your event in the chart, the game calls `onEvent`. That's where your code goes:

```lua
format 1.1

event {
    name = "Beat Flash",
}

function onEvent(p)
    flash.color = #FFFFFF
    flash.alpha = 0.6
    tween(flash.alpha, 0, beats(0.5), "quadOut")
end
```

Read it out loud and it almost explains itself: make the flash white, show it at 60 %, then fade it to nothing over
half a beat. Place the event somewhere (click the **EVENTS** lane), press Space, and when the song gets there - flash!

`flash` is a [property](../api/properties.md): a value the game looks at every frame. You can set it right away, or
animate it with `tween`. Times are in milliseconds, and `beats(0.5)` works out how many milliseconds half a beat is at
this song's tempo, so you never have to do that maths yourself.

!!! tip "There's a shorter way"
    For a plain flash there's a [shortcut](../api/shortcuts.md): `flash(#FFFFFF, beats(0.5))` does all of the above in
    one line. We're building it by hand here so you see how properties and `tween` work - you'll want them the moment
    you need something the shortcuts don't do.

## 3. Let people pick the colour

A flash that's always white gets boring fast. **Parameters** fix that: they describe the event's two values (value1
and value2 in the chart), and the editor turns them into proper controls.

```lua
params {
    tint = color { from = "value1", default = #FFFFFF, label = "Colour" },
}

function onEvent(p)
    flash.color = p.tint
    flash.alpha = 0.6
    tween(flash.alpha, 0, beats(0.5), "quadOut")
end
```

Press Reload, and the inspector now has a **Colour** field with a swatch. Whatever you pick ends up in value1 as
`#RRGGBB`, and `p.tint` hands it back to you as a colour. Numbers with sliders, switches, lanes, dropdowns - all the
kinds are on [Parameters](../api/parameters.md).

## 4. Flash on every beat

Now the fun part. Instead of flashing once, the event switches a *mode* on, and the flashing happens on every beat
until another Beat Flash switches it off. For that you need two things: a variable that lives for the whole song (a
`local` at the top of the file), and a second callback, `onBeat`.

```lua
params {
    on   = bool  { from = "value1", default = true, label = "On" },
    tint = color { from = "value2", default = #FFFFFF, label = "Colour" },
}

local active = false
local tint = #FFFFFF

function onEvent(p)
    active = p.on
    tint = p.tint
end

function onBeat(b)
    if not active then return end

    flash.color = tint
    flash.alpha = 0.45
    tween(flash.alpha, 0, beats(0.75), "quadOut")
end
```

Place one Beat Flash with *On* ticked where it should start, and another with *On* unticked where it should stop.
`onBeat` gets called on every single beat of the song - it just leaves straight away while `active` is false.

!!! note "Every callback runs, all the time"
    `onBeat` runs whether your event has fired yet or not. That's why it checks `active` first. It's also a neat
    trick: a file with only `onBeat` and no chart event at all still works - that's a
    [song script](song-scripts.md).

## 5. Make it feel good

Two small touches make a big difference: the first beat of every bar hits harder, and the camera pops along with it.

```lua
function onBeat(b)
    if not active then return end

    local downbeat = b % 4 == 0
    flash.color = tint
    flash.alpha = downbeat ? 0.7 : 0.35
    tween(flash.alpha, 0, beats(0.75), "quadOut")

    if downbeat then
        camera.bump += 0.04
    end
end
```

`b % 4` is what's left after dividing the beat by 4 - so it's 0 on the first beat of each bar. `c ? a : b` picks one of
two values. And `camera.bump` is the game's own little zoom pop: it eases back by itself, so you **add** to it instead
of tweening it.

## 6. When it doesn't do what you expect

It happens to everyone. Ask the script what it's thinking with `log`:

```lua
function onEvent(p)
    active = p.on
    tint = p.tint
    log("Beat Flash", active ? "on" : "off", "in", tint)
end
```

That line lands in `logs/minefunkin-events.log`, right next to Minecraft's `latest.log` - together with every chart
event as it fires and every script error. [Errors and fixes](../help/troubleshooting.md) helps you read it.

## The whole file

Here's everything together, plus three header lines that make it look nice in the editor:

```lua
format 1.1
-- Flashes the screen on every beat until it's switched off again.

event {
    name = "Beat Flash",
    color = #FFE35C,
    category = "Screen",
    description = "Flashes the screen on every beat (harder on the first beat of a bar).",
}

params {
    on   = bool  { from = "value1", default = true, label = "On" },
    tint = color { from = "value2", default = #FFFFFF, label = "Colour" },
}

local active = false
local tint = #FFFFFF

function onEvent(p)
    active = p.on
    tint = p.tint
end

function onBeat(b)
    if not active then return end

    local downbeat = b % 4 == 0
    flash.color = tint
    flash.alpha = downbeat ? 0.7 : 0.35
    tween(flash.alpha, 0, beats(0.75), "quadOut")

    if downbeat then
        camera.bump += 0.04
    end
end
```

`color` is the marker's colour in the editor, `category` puts it into a group in the type picker, and `description` is
what you see when you hover it there.

That's it - you made an event. 🎉

## Where to next

| If you want to ... | Go to |
|---|---|
| start your next one from a working file | [Templates](templates.md) - an on/off effect, a song script, a modchart, a stage |
| do common stuff in one line | [Shortcuts](../api/shortcuts.md) - flashes, fades, zooms, hiding the HUD, flipping the scroll, swapping the fighters |
| react to every hit, miss and beat | [Song scripts](song-scripts.md) |
| make the lanes sway, spin, fly in | [Modcharts](modcharts.md) |
| put pictures and animated sprites around the fighters | [Stages and sprites](stages.md) |
| play your own sounds, mute the song's tracks | [Sounds and music](sound.md) |
| copy something small that just works | [Cookbook](cookbook.md) |
| look up any name | [Event API](../api/index.md) |
