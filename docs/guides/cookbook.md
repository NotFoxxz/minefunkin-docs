---
icon: material/chef-hat
---

# Cookbook

Small recipes to steal. Each one is complete and tested: put it in a file under a `format 1.1` line and an
`event { name = "..." }`, and it works. Recipes that need a chart event use `onEvent`; the others are
[song scripts](song-scripts.md) that run for the whole song.

Click one open, copy it, change the numbers until it feels right. That's really all there is to it.

## Camera and HUD

??? example "Zoom pop on every downbeat"

    ```lua
    function onBeat(b)
        if b % 4 == 0 then
            camera.bump += 0.035
        end
    end
    ```

??? example "A slow zoom that stays"

    ```lua
    params {
        zoom = number { from = "value1", default = 1.15, min = 0.5, max = 2, step = 0.05 },
        length = number { from = "value2", default = 4, min = 0, max = 32, step = 0.5, label = "Beats" },
    }

    function onEvent(p)
        tween(camera.zoom, p.zoom, beats(p.length), "sineInOut")
    end
    ```

    The [shortcut](../api/shortcuts.md) for the same: `zoom(p.zoom, beats(p.length))`.

??? example "Shake on a hard hit"

    ```lua
    function onEvent(p)
        camera.shake = 0.012
        tween(camera.shake, 0, beats(1), "quadOut")
    end
    ```

    Or with the [shortcut](../api/shortcuts.md): `shake(0.012, beats(1))`.

??? example "The playfield rocks with the beat"

    ```lua
    local side = 1

    function onBeat(b)
        side = -side
        hud.angle = side * 3
        tween(hud.angle, 0, beats(1), "quadOut")
    end
    ```

## Flashes and colours

??? example "Red flash on a miss"

    ```lua
    function onMiss(note)
        flash.color = #FF3040
        flash.alpha = 0.3
        tween(flash.alpha, 0, beats(0.5), "quadOut")
    end
    ```

??? example "Cut to black and back"

    ```lua
    params {
        hold = number { from = "value1", default = 2, min = 0, max = 16, step = 0.5, label = "Beats black" },
    }

    function onEvent(p)
        screen.color = #000000
        screen.alpha = 1
        after(beats(p.hold), function()
            tween(screen.alpha, 0, beats(1))
        end)
    end
    ```

    With the [shortcuts](../api/shortcuts.md): `fadeOut(#000000, 0)`, then `fadeIn(beats(1))` in the `after`.

??? example "Strum background in the colour of the last judgment"

    ```lua
    function onHit(note)
        local c = note.judgment == "sick" ? #5CF2FF : note.judgment == "good" ? #5CFF8F : #FFB547
        underlay.color = c
        underlay.alpha = 0.8
        tween(underlay.color, #000000, beats(1))
        tween(underlay.alpha, 0.65, beats(1))
    end
    ```

## Text

??? example "A line of lyrics that fades in and out"

    ```lua
    params {
        line = text { from = "value1", label = "Line" },
        length = number { from = "value2", default = 4, min = 1, max = 16, step = 1, label = "Beats" },
    }

    local shown = 0

    function onEvent(p)
        shown += 1
        local mine = shown
        text[7].value = p.line ?? ""
        text[7].y = 0.82
        text[7].alpha = 0
        tween(text[7].alpha, 1, beats(0.25))
        after(beats(p.length), function()
            if shown == mine then tween(text[7].alpha, 0, beats(0.5)) end
        end)
    end
    ```

    The counter makes sure a newer line isn't faded out by an older one's timer.

??? example "Live accuracy in a corner"

    ```lua
    function onFrame(dt)
        text[3].value = round(player.accuracy * 10) / 10 .. " %"
        text[3].align = "right"
        text[3].x = 0.97
        text[3].y = 0.92
        text[3].size = 0.8
    end
    ```

??? example "Combo shout every 50"

    ```lua
    local next = 50

    function onHit(note)
        if player.combo >= next then
            text[4].value = next .. " COMBO!"
            text[4].y = 0.6
            text[4].size = 1.6
            text[4].alpha = 1
            tween(text[4].size, 1.1, beats(0.5), "backOut")
            tween(text[4].alpha, 0, beats(1.5), "quadIn")
            next += 50
        end
    end

    function onMiss(note)
        next = 50
    end
    ```

## Lanes

??? example "Lanes light up when they're pressed"

    ```lua
    function onFrame(dt)
        for lane = 0, 3 do
            strum[lane].scale = strum[lane].pressed ? 1.12 : 1
        end
    end
    ```

??? example "The opponent's notes shake your lanes"

    ```lua
    function onOpponentHit(note)
        strum[note.lane].wobbleY = -10
        tween(strum[note.lane].wobbleY, 0, beats(0.5), "elasticOut")
    end
    ```

??? example "Slow down, then speed up"

    ```lua
    function onEvent(p)
        scrollTo(0.6, beats(2))
        after(beats(4), function() scrollTo(1.4, beats(1)) end)
    end
    ```

More in [Modcharts](modcharts.md) and [strum[lane]](../api/strum.md).

## Fighters (fights only)

??? example "Both fighters bounce on every beat"

    ```lua
    function onBeat(b)
        for who = 0, 1 do
            puppet[who].squash = 0.18
            tween(puppet[who].squash, 0, beats(0.8), "elasticOut")
        end
    end
    ```

??? example "The opponent flinches when you hit a sick"

    ```lua
    function onHit(note)
        if note.judgment != "sick" then return end
        opponent.pitch = -8
        tween(opponent.pitch, 0, beats(0.5), "backOut")
    end
    ```

??? example "The opponent turns red as your combo grows"

    ```lua
    function onFrame(dt)
        local heat = min(1, player.combo / 100)
        opponent.color = mix(#FFFFFF, #FF4040, heat)
    end
    ```

More in [The fighters](fighters.md).

## Sound

??? example "A sound on the drop"

    ```lua
    function onEvent(p)
        playSound("impact.ogg", 0.8)   -- a file in the song folder or events/
        camera.bump += 0.08
    end
    ```

??? example "The opponent's voice drops out for a bar"

    ```lua
    function onEvent(p)
        tween(volume.opponent, 0, beats(0.5))
        after(beats(4), function() tween(volume.opponent, 1, beats(0.5)) end)
    end
    ```

## The game window

More in [Game window and pop-outs](windows.md).

??? example "The window shakes on every miss"

    ```lua
    function onMiss(note)
        window.x = 14
        tween(window.x, 0, beats(0.5), "elasticOut")
    end
    ```

??? example "The judgments in a window of their own, floating above the game"

    ```lua
    function onEvent(p)
        popout[0].show = "judgments"
        tween(popout[0].y, -260, beats(2), "sineInOut")
    end
    ```

??? example "Each lane flies out into its own window and circles the screen"

    ```lua
    local circling = false

    function onEvent(p)
        popout[0].show = "left"
        popout[1].show = "down"
        popout[2].show = "up"
        popout[3].show = "right"
        circling = true
        after(beats(16), function()
            circling = false
            resetWindow(beats(2))    -- glide home, then close
        end)
    end

    function onFrame(dt)
        if not circling then return end
        for i = 0, 3 do
            local a = time / 1000 + i * pi / 2
            popout[i].x = cos(a) * 300
            popout[i].y = sin(a) * 150
        end
    end
    ```
