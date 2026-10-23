---
icon: material/tune-variant
---
# Modifiers

Numbers that bend how a playfield is **drawn**, planned on the song's beats. They never change how notes are judged: you press at the same moment whatever the field looks like.

!!! info "How to use it"
    Plan them on the song's beats with [`ease`](shortcuts.md#ease), [`set`](shortcuts.md#set) and [`add`](shortcuts.md#add), change one right now with [`setMod`](shortcuts.md#setmod), read one with [`mod()`](functions.md#mod). Most are **percent** (100 = the full effect), some pixels (measured on a 1280 x 720 screen, whatever the window) or degrees.
    
    **Fields:** 1 = yours, 0 = the opponent's (not drawn - a fight shows only yours), 2-7 = ones [`copyField()`](functions.md#copyfield) made. Leave the field out and a change goes to all of them.
    
    **Names** are looked up without case. Coming from Psych or Kade? The guide's [table](../guides/modifiers.md#coming-from-psych-or-kade) says which of ours is theirs.

## Example code

```lua
function onStart()
    ease(16, 2, "cubicOut", 100, "sway")       -- beat 16, over 2 beats
    ease(16, 2, "cubicOut", 50, "hover")
    set(24, 100, "downscroll1")                -- lane 1 scrolls the other way from beat 24
    ease(32, 4, "sineInOut", 0, "sway")
end
```

## All modifiers

| Modifier | Default | Unit | Per lane | |
|---|---|---|---|---|
| [x](#mod-x) | `0` | px |  | Moves the whole field right. |
| [y](#mod-y) | `0` | px |  | Moves the whole field down. |
| [z](#mod-z) | `0` | px |  | Moves the whole field toward the camera. |
| [zoom](#mod-zoom) | `100` | % |  | The field's size around its middle. |
| [shrink](#mod-shrink) | `0` | % |  | Makes the field smaller: 100 = half its size, -100 = one and a half. |
| [turnX](#mod-turnx) | `0` | ° |  | Tips the field forward / back around its receptor row. |
| [turnY](#mod-turny) | `0` | ° |  | Turns the field left / right around its receptor row. |
| [turnZ](#mod-turnz) | `0` | ° |  | Turns the field clockwise around its receptor row. |
| [spinX](#mod-spinx) | `0` | ° |  | Like turnX, but around the middle of the screen. |
| [spinY](#mod-spiny) | `0` | ° |  | Like turnY, but around the middle of the screen. |
| [spinZ](#mod-spinz) | `0` | ° |  | Like turnZ, but around the middle of the screen. |
| [skewX](#mod-skewx) | `0` | % |  | Notes come in slanted: 100 = one pixel sideways for every pixel they travel. |
| [skewY](#mod-skewy) | `0` | % |  | The receptor row slants: 100 = one pixel down for every pixel to the right. |
| [fade](#mod-fade) | `0` | % |  | Fades the whole field out: receptors, notes and holds. |
| [cam.x](#mod-cam-x) | `0` | px |  | Moves the field's camera right. |
| [cam.y](#mod-cam-y) | `0` | px |  | Moves the field's camera down. |
| [cam.z](#mod-cam-z) | `0` | px |  | Moves the field's camera back. |
| [cam.rotX](#mod-cam-rotx) | `0` | ° |  | Tilts the field's camera up / down. |
| [cam.rotY](#mod-cam-roty) | `0` | ° |  | Turns the field's camera left / right. |
| [cam.rotZ](#mod-cam-rotz) | `0` | ° |  | Rolls the field's camera. |
| [cam.fov](#mod-cam-fov) | `45` | ° |  | The camera's lens. |
| [slideX](#mod-slidex) | `0` | px | yes | Moves lanes right. |
| [slideY](#mod-slidey) | `0` | px | yes | Moves lanes down. |
| [slideZ](#mod-slidez) | `0` | px | yes | Moves lanes toward the camera. |
| [flipSides](#mod-flipsides) | `0` | % |  | Mirrors the lanes left-right. |
| [swapPairs](#mod-swappairs) | `0` | % |  | Swaps neighbouring lanes. |
| [pinch](#mod-pinch) | `0` | % | yes | Pulls the lanes together. |
| [pinchZ](#mod-pinchz) | `0` | % | yes | Bends the row into depth: the outer lanes go back. |
| [downscroll](#mod-downscroll) | `0` | % | yes | Flips the scroll direction. |
| [fold](#mod-fold) | `0` | % |  | Folds the row like a book: the outer lanes turn back into depth. |
| [speed](#mod-speed) | `100` | % |  | The field's scroll speed. |
| [freeze](#mod-freeze) | `0` | % |  | The notes stop where they were when it started. |
| [speedUp](#mod-speedup) | `0` | % | yes | Notes speed up as they come close. |
| [slowDown](#mod-slowdown) | `0` | % | yes | Notes slow down as they come close. |
| [speedWave](#mod-speedwave) | `0` | % | yes | Notes speed up and slow down as they travel. |
| [sway](#mod-sway) | `0` | % | yes | Lanes sway left and right in a wave along the way in. |
| [sway.speed](#mod-sway-speed) | `0` | % |  | How fast sway moves. |
| [sway.period](#mod-sway-period) | `0` | % |  | How tight sway's waves are along the way. |
| [hover](#mod-hover) | `0` | % | yes | Lanes bob up and down, each on its own. |
| [hover.speed](#mod-hover-speed) | `0` | % |  | How fast hover bobs. |
| [bulge](#mod-bulge) | `0` | % | yes | Notes bump toward the camera and back as they travel. |
| [bulge.period](#mod-bulge-period) | `0` | % |  | How close bulge's bumps are. |
| [twister](#mod-twister) | `0` | % | yes | Notes weave across the neighbouring lanes on the way in. |
| [kick](#mod-kick) | `0` | % | yes | The lanes kick sideways on every beat, in a wave along the way in. |
| [bendX](#mod-bendx) | `0` | % | yes | The way in curves sideways, more the further out. |
| [bendZ](#mod-bendz) | `0` | % | yes | The way in curves toward the camera, more the further out. |
| [joltX](#mod-joltx) | `0` | % | yes | The lanes jolt left / right, a new direction every period, easing back. |
| [joltY](#mod-jolty) | `0` | % | yes | Like joltX, up / down. |
| [jolt.period](#mod-jolt-period) | `100` | % |  | How often jolt changes direction: 100 = every beat, 50 = every half beat. |
| [bobX](#mod-bobx) | `0` | % | yes | The lanes sway left / right over time. |
| [bobY](#mod-boby) | `0` | % | yes | Like bobX, up / down. |
| [bob.speed](#mod-bob-speed) | `0` | % |  | How fast bob sways. |
| [ripple](#mod-ripple) | `0` | px |  | Everything shifts sideways in a wave running down the screen. |
| [ripple.freq](#mod-ripple-freq) | `100` | % |  | How many waves ripple has down the screen. |
| [ripple.speed](#mod-ripple-speed) | `100` | % |  | How fast ripple's waves run. |
| [faceX](#mod-facex) | `0` | ° | yes | Turns the arrows. |
| [faceY](#mod-facey) | `0` | ° | yes | Turns the arrows around their own y axis. |
| [faceZ](#mod-facez) | `0` | ° | yes | Turns the arrows in place, clockwise. |
| [twirl](#mod-twirl) | `0` | % | yes | The arrows spin all the time. |
| [tumble](#mod-tumble) | `0` | % | yes | Notes spin as they travel. |
| [shrinkArrows](#mod-shrinkarrows) | `0` | % | yes | Arrows smaller. |
| [swell](#mod-swell) | `0` | % | yes | Notes grow as they come close. |
| [breathe](#mod-breathe) | `0` | % | yes | Notes pulse bigger and smaller as they travel. |
| [fadeStrums](#mod-fadestrums) | `0` | % | yes | Fades the receptors. |
| [fadeNotes](#mod-fadenotes) | `0` | % | yes | Fades the notes and holds. |
| [vanish](#mod-vanish) | `0` | % | yes | Fades the notes and holds too - a second one, to plan apart from fadeNotes. |
| [hideFlash](#mod-hideflash) | `0` | % |  | Hides the receptors' flash when you hit. |
| [ghost](#mod-ghost) | `0` | % | yes | Notes turn see-through. |
| [shade](#mod-shade) | `0` | % | yes | Darkens receptors and notes. |
| [hideNear](#mod-hidenear) | `0` | % |  | Notes fade out as they come close. |
| [hideNear.offset](#mod-hidenear-offset) | `0` | px |  | Moves hideNear's line. |
| [hideNear.fade](#mod-hidenear-fade) | `120` | px |  | How long hideNear's fade is. |
| [hideFar](#mod-hidefar) | `0` | % |  | Notes appear late: hidden until 400 px before the receptor. |
| [hideFar.offset](#mod-hidefar-offset) | `0` | px |  | Moves hideFar's line. |
| [hideFar.fade](#mod-hidefar-fade) | `120` | px |  | How long hideFar's fade is. |
| [drawAhead](#mod-drawahead) | `0` | px |  | How far out notes are drawn. |
| [drawAhead.fade](#mod-drawahead-fade) | `0` | px |  | Notes fade in over this many pixels at drawAhead's end. |
| [drawBehind](#mod-drawbehind) | `0` | px |  | How far past the receptor notes are still drawn. |

## Field

Where the whole field is, how big, how it's turned. Turning goes around the receptor row's middle; `spin` around the screen's.

### x { #mod-x }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"x"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves the whole field right (pixels).

### y { #mod-y }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"y"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves the whole field down (pixels).

### z { #mod-z }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"z"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves the whole field toward the camera (pixels) - it gets bigger.

### zoom { #mod-zoom }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"zoom"</code> <span class="mf-eq">= <code>100</code></span></p>

The field's size around its middle (100 = normal, 200 = twice as big).

### shrink { #mod-shrink }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"shrink"</code> <span class="mf-eq">= <code>0</code></span></p>

Makes the field smaller: 100 = half its size, -100 = one and a half.

### turnX { #mod-turnx }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"turnX"</code> <span class="mf-eq">= <code>0</code></span></p>

Tips the field forward / back around its receptor row (3D).

### turnY { #mod-turny }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"turnY"</code> <span class="mf-eq">= <code>0</code></span></p>

Turns the field left / right around its receptor row (3D).

### turnZ { #mod-turnz }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"turnZ"</code> <span class="mf-eq">= <code>0</code></span></p>

Turns the field clockwise around its receptor row.

### spinX { #mod-spinx }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"spinX"</code> <span class="mf-eq">= <code>0</code></span></p>

Like turnX, but around the middle of the screen.

### spinY { #mod-spiny }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"spinY"</code> <span class="mf-eq">= <code>0</code></span></p>

Like turnY, but around the middle of the screen.

### spinZ { #mod-spinz }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"spinZ"</code> <span class="mf-eq">= <code>0</code></span></p>

Like turnZ, but around the middle of the screen.

### skewX { #mod-skewx }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"skewX"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes come in slanted: 100 = one pixel sideways for every pixel they travel.

### skewY { #mod-skewy }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"skewY"</code> <span class="mf-eq">= <code>0</code></span></p>

The receptor row slants: 100 = one pixel down for every pixel to the right.

### fade { #mod-fade }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"fade"</code> <span class="mf-eq">= <code>0</code></span></p>

Fades the whole field out: receptors, notes and holds (100 = gone).

## Camera

Every field is seen through its own camera (with no field given, they all move together). It looks at the screen from the front - `cam.z` moves it back, `cam.fov` makes the 3D stronger or flatter.

### cam.x { #mod-cam-x }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"cam.x"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves the field's camera right (pixels) - the field moves left.

### cam.y { #mod-cam-y }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"cam.y"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves the field's camera down (pixels).

### cam.z { #mod-cam-z }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"cam.z"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves the field's camera back (pixels) - the field gets smaller.

### cam.rotX { #mod-cam-rotx }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"cam.rotX"</code> <span class="mf-eq">= <code>0</code></span></p>

Tilts the field's camera up / down.

### cam.rotY { #mod-cam-roty }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"cam.rotY"</code> <span class="mf-eq">= <code>0</code></span></p>

Turns the field's camera left / right.

### cam.rotZ { #mod-cam-rotz }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"cam.rotZ"</code> <span class="mf-eq">= <code>0</code></span></p>

Rolls the field's camera.

### cam.fov { #mod-cam-fov }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"cam.fov"</code> <span class="mf-eq">= <code>45</code></span></p>

The camera's lens (degrees, 45 = normal): wider = stronger 3D.

## Lanes

Where each lane is. Per-lane modifiers have a form for one lane: `slideX2` moves only lane 2, on top of `slideX`.

### slideX { #mod-slidex }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"slideX"</code> · <code>"slideX0"</code> … <code>"slideX3"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves lanes right (pixels): slideX = all, slideX0..slideX3 = one lane.

### slideY { #mod-slidey }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"slideY"</code> · <code>"slideY0"</code> … <code>"slideY3"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves lanes down (pixels).

### slideZ { #mod-slidez }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"slideZ"</code> · <code>"slideZ0"</code> … <code>"slideZ3"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves lanes toward the camera (pixels).

### flipSides { #mod-flipsides }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"flipSides"</code> <span class="mf-eq">= <code>0</code></span></p>

Mirrors the lanes left-right (100 = right lane on the left, 50 = all in the middle).

### swapPairs { #mod-swappairs }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"swapPairs"</code> <span class="mf-eq">= <code>0</code></span></p>

Swaps neighbouring lanes (left with down, up with right).

### pinch { #mod-pinch }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"pinch"</code> · <code>"pinch0"</code> … <code>"pinch3"</code> <span class="mf-eq">= <code>0</code></span></p>

Pulls the lanes together (100 = all in the middle, -100 = twice as far apart).

### pinchZ { #mod-pinchz }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"pinchZ"</code> · <code>"pinchZ0"</code> … <code>"pinchZ3"</code> <span class="mf-eq">= <code>0</code></span></p>

Bends the row into depth: the outer lanes go back (100 = as far back as they are from the middle; minus = toward the camera).

### downscroll { #mod-downscroll }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"downscroll"</code> · <code>"downscroll0"</code> … <code>"downscroll3"</code> <span class="mf-eq">= <code>0</code></span></p>

Flips the scroll direction (100 = up- becomes downscroll; 50 = receptors in the middle).

### fold { #mod-fold }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"fold"</code> <span class="mf-eq">= <code>0</code></span></p>

Folds the row like a book: the outer lanes turn back into depth (100 = a quarter turn).

## Travel

How the notes come in. Only the drawing - when you have to press stays exactly the same.

### speed { #mod-speed }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"speed"</code> <span class="mf-eq">= <code>100</code></span></p>

The field's scroll speed (100 = the song's, 200 = notes come twice as fast). Only how they're drawn.

### freeze { #mod-freeze }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"freeze"</code> <span class="mf-eq">= <code>0</code></span></p>

The notes stop where they were when it started (100); going back to 0 they catch up.

### speedUp { #mod-speedup }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"speedUp"</code> · <code>"speedUp0"</code> … <code>"speedUp3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes speed up as they come close.

### slowDown { #mod-slowdown }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"slowDown"</code> · <code>"slowDown0"</code> … <code>"slowDown3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes slow down as they come close.

### speedWave { #mod-speedwave }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"speedWave"</code> · <code>"speedWave0"</code> … <code>"speedWave3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes speed up and slow down as they travel.

## Paths

The notes' way in bends, sways and kicks. Mostly percent: 100 = the full effect.

### sway { #mod-sway }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"sway"</code> · <code>"sway0"</code> … <code>"sway3"</code> <span class="mf-eq">= <code>0</code></span></p>

Lanes sway left and right in a wave along the way in (100 = half a lane).

### sway.speed { #mod-sway-speed }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"sway.speed"</code> <span class="mf-eq">= <code>0</code></span></p>

How fast sway moves (0 = normal, 100 = twice as fast).

### sway.period { #mod-sway-period }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"sway.period"</code> <span class="mf-eq">= <code>0</code></span></p>

How tight sway's waves are along the way (0 = normal, 100 = twice as many).

### hover { #mod-hover }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"hover"</code> · <code>"hover0"</code> … <code>"hover3"</code> <span class="mf-eq">= <code>0</code></span></p>

Lanes bob up and down, each on its own (100 = 0.4 lanes).

### hover.speed { #mod-hover-speed }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"hover.speed"</code> <span class="mf-eq">= <code>0</code></span></p>

How fast hover bobs (0 = normal).

### bulge { #mod-bulge }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bulge"</code> · <code>"bulge0"</code> … <code>"bulge3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes bump toward the camera and back as they travel (3D).

### bulge.period { #mod-bulge-period }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bulge.period"</code> <span class="mf-eq">= <code>0</code></span></p>

How close bulge's bumps are (0 = normal).

### twister { #mod-twister }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"twister"</code> · <code>"twister0"</code> … <code>"twister3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes weave across the neighbouring lanes on the way in.

### kick { #mod-kick }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"kick"</code> · <code>"kick0"</code> … <code>"kick3"</code> <span class="mf-eq">= <code>0</code></span></p>

The lanes kick sideways on every beat, in a wave along the way in.

### bendX { #mod-bendx }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bendX"</code> · <code>"bendX0"</code> … <code>"bendX3"</code> <span class="mf-eq">= <code>0</code></span></p>

The way in curves sideways, more the further out (100 = 160 px at 480 px out).

### bendZ { #mod-bendz }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bendZ"</code> · <code>"bendZ0"</code> … <code>"bendZ3"</code> <span class="mf-eq">= <code>0</code></span></p>

The way in curves toward the camera, more the further out.

### joltX { #mod-joltx }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"joltX"</code> · <code>"joltX0"</code> … <code>"joltX3"</code> <span class="mf-eq">= <code>0</code></span></p>

The lanes jolt left / right, a new direction every period, easing back (100 = half a lane).

### joltY { #mod-jolty }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"joltY"</code> · <code>"joltY0"</code> … <code>"joltY3"</code> <span class="mf-eq">= <code>0</code></span></p>

Like joltX, up / down.

### jolt.period { #mod-jolt-period }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"jolt.period"</code> <span class="mf-eq">= <code>100</code></span></p>

How often jolt changes direction: 100 = every beat, 50 = every half beat.

### bobX { #mod-bobx }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bobX"</code> · <code>"bobX0"</code> … <code>"bobX3"</code> <span class="mf-eq">= <code>0</code></span></p>

The lanes sway left / right over time (100 = one lane).

### bobY { #mod-boby }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bobY"</code> · <code>"bobY0"</code> … <code>"bobY3"</code> <span class="mf-eq">= <code>0</code></span></p>

Like bobX, up / down.

### bob.speed { #mod-bob-speed }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"bob.speed"</code> <span class="mf-eq">= <code>0</code></span></p>

How fast bob sways (0 = once per two beats, 100 = twice as fast).

### ripple { #mod-ripple }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"ripple"</code> <span class="mf-eq">= <code>0</code></span></p>

Everything shifts sideways in a wave running down the screen (pixels).

### ripple.freq { #mod-ripple-freq }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"ripple.freq"</code> <span class="mf-eq">= <code>100</code></span></p>

How many waves ripple has down the screen (100 = two).

### ripple.speed { #mod-ripple-speed }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"ripple.speed"</code> <span class="mf-eq">= <code>100</code></span></p>

How fast ripple's waves run (100 = one a second).

## Arrows

The receptors and notes themselves: turned, spun, bigger or smaller.

### faceX { #mod-facex }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"faceX"</code> · <code>"faceX0"</code> … <code>"faceX3"</code> <span class="mf-eq">= <code>0</code></span></p>

Turns the arrows (receptors and notes) around their own x axis (3D flip).

### faceY { #mod-facey }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"faceY"</code> · <code>"faceY0"</code> … <code>"faceY3"</code> <span class="mf-eq">= <code>0</code></span></p>

Turns the arrows around their own y axis (3D flip).

### faceZ { #mod-facez }

<p class="mf-sig"><span class="mf-type">degrees</span> <code>"faceZ"</code> · <code>"faceZ0"</code> … <code>"faceZ3"</code> <span class="mf-eq">= <code>0</code></span></p>

Turns the arrows in place, clockwise.

### twirl { #mod-twirl }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"twirl"</code> · <code>"twirl0"</code> … <code>"twirl3"</code> <span class="mf-eq">= <code>0</code></span></p>

The arrows spin all the time (100 = one turn every beat).

### tumble { #mod-tumble }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"tumble"</code> · <code>"tumble0"</code> … <code>"tumble3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes spin as they travel (100 = one turn per 360 px).

### shrinkArrows { #mod-shrinkarrows }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"shrinkArrows"</code> · <code>"shrinkArrows0"</code> … <code>"shrinkArrows3"</code> <span class="mf-eq">= <code>0</code></span></p>

Arrows smaller (100 = half, -100 = twice as big) - the lanes stay where they are.

### swell { #mod-swell }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"swell"</code> · <code>"swell0"</code> … <code>"swell3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes grow as they come close (100 = twice as big at the receptor).

### breathe { #mod-breathe }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"breathe"</code> · <code>"breathe0"</code> … <code>"breathe3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes pulse bigger and smaller as they travel.

## Visibility

What you see of the notes and receptors.

### fadeStrums { #mod-fadestrums }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"fadeStrums"</code> · <code>"fadeStrums0"</code> … <code>"fadeStrums3"</code> <span class="mf-eq">= <code>0</code></span></p>

Fades the receptors (100 = gone; notes stay).

### fadeNotes { #mod-fadenotes }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"fadeNotes"</code> · <code>"fadeNotes0"</code> … <code>"fadeNotes3"</code> <span class="mf-eq">= <code>0</code></span></p>

Fades the notes and holds (100 = gone; receptors stay).

### vanish { #mod-vanish }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"vanish"</code> · <code>"vanish0"</code> … <code>"vanish3"</code> <span class="mf-eq">= <code>0</code></span></p>

Fades the notes and holds too - a second one, to plan apart from fadeNotes.

### hideFlash { #mod-hideflash }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"hideFlash"</code> <span class="mf-eq">= <code>0</code></span></p>

Hides the receptors' flash when you hit.

### ghost { #mod-ghost }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"ghost"</code> · <code>"ghost0"</code> … <code>"ghost3"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes turn see-through (100 = 40 % there).

### shade { #mod-shade }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"shade"</code> · <code>"shade0"</code> … <code>"shade3"</code> <span class="mf-eq">= <code>0</code></span></p>

Darkens receptors and notes (100 = black).

### hideNear { #mod-hidenear }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"hideNear"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes fade out as they come close (gone from 200 px before the receptor).

### hideNear.offset { #mod-hidenear-offset }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"hideNear.offset"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves hideNear's line (pixels further out).

### hideNear.fade { #mod-hidenear-fade }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"hideNear.fade"</code> <span class="mf-eq">= <code>120</code></span></p>

How long hideNear's fade is (pixels).

### hideFar { #mod-hidefar }

<p class="mf-sig"><span class="mf-type">percent</span> <code>"hideFar"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes appear late: hidden until 400 px before the receptor.

### hideFar.offset { #mod-hidefar-offset }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"hideFar.offset"</code> <span class="mf-eq">= <code>0</code></span></p>

Moves hideFar's line (pixels further out).

### hideFar.fade { #mod-hidefar-fade }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"hideFar.fade"</code> <span class="mf-eq">= <code>120</code></span></p>

How long hideFar's fade is (pixels).

### drawAhead { #mod-drawahead }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"drawAhead"</code> <span class="mf-eq">= <code>0</code></span></p>

How far out notes are drawn (pixels; 0 = to the edge of the screen).

### drawAhead.fade { #mod-drawahead-fade }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"drawAhead.fade"</code> <span class="mf-eq">= <code>0</code></span></p>

Notes fade in over this many pixels at drawAhead's end.

### drawBehind { #mod-drawbehind }

<p class="mf-sig"><span class="mf-type">pixels</span> <code>"drawBehind"</code> <span class="mf-eq">= <code>0</code></span></p>

How far past the receptor notes are still drawn (pixels; 0 = until they're missed).
