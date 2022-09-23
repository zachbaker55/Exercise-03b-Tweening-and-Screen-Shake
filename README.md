# Exercise-03b-Tweening-and-Screen-Shake

Exercise for MSCH-C220

This exercise is the next opportunity for you to experiment with juicy features to our brick-breaker game. The exercise will provide you with several more features that should move you towards the implementation of Project 03.

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-03b-Tweening-and-Screen-Shake. Edit the LICENSE and replace BL-MSCH-C220-F22 with your full name. Commit your changes.

Press the green "Code" button and select "Open in GitHub Desktop". Allow the browser to open (or install) GitHub Desktop. Once GitHub Desktop has loaded, you should see a window labeled "Clone a Repository" asking you for a Local Path on your computer where the project should be copied. Choose a location; make sure the Local Path ends with "Exercise-03b-Tweening-and-Screen-Shake" and then press the "Clone" button. GitHub Desktop will now download a copy of the repository to the location you indicated.

Open Godot. In the Project Manager, tap the "Import" button. Tap "Browse" and navigate to the repository folder. Select the project.godot file and tap "Open".

If you run the project, you will see the project where we left off at the end of Exercise 03a. We will now have an opportunity to start making it "juicier".

*I have made a few small adjustments in anticpation of this exercise. If it seems like I have moved things around a bit, don't worry.*

---

## The Ball

Open `res://Ball/Ball.tscn`. As a child of the Ball scene, add a Tween node. Then edit the `_on_Ball_body_entered` and add this to the end of that callback:
```
    $Tween.interpolate_property($Images/Highlight, "modulate:a", 1.0, 0.0, time_highlight, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
    $Tween.interpolate_property($Images/Highlight, "scale", Vector2(2.0,2.0), Vector2(1.0,1.0), time_highlight_size, Tween.TRANS_BOUNCE, Tween.EASE_IN)
    $Tween.start()
    wobble_direction = linear_velocity.tangent().normalized()
    wobble_amplitude = wobble_max

```

I have stubbed out `wobble()` and `distort()` functions (that will ultimately make the ball wobble as it hits something and distort it as it moves faster). The contents of those functions should be as follows:
```
func wobble():
  wobble_period += 1
  if wobble_amplitude > 0:
    var pos = wobble_direction * wobble_amplitude * sin(wobble_period)
    $Images.position = pos
    wobble_amplitude -= decay_wobble
```
```
func distort():
  var direction = Vector2(1 + linear_velocity.length() * distort_effect, 1 - linear_velocity.length() * distort_effect)
  $Images.rotation = linear_velocity.angle()
  $Images.scale = direction

```

## The Indicator

Open `res://UI/Indicator.tscn` and add a Tween node as a child of the Indicator node. Attach `res://UI/Indicator.gd` as a script to the Indicator node, Then edit the script as follows:

```
extends Node2D

var modulate_target = 0.5
var mod = 0
var scale_target = Vector2(0.75,0.75)
var sca = Vector2(0.5,0.5)

func _ready():
	$Tween.interpolate_property($Highlight, "scale", $Highlight.scale, scale_target, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Highlight, "modulate:a", $Highlight.modulate.a, modulate_target, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
```

Select the Tween node and attach a `tween_all_completed` signal back to `res://UI/Indicator.gd`. The contents of that callback should be as follows (the ternary statements on the first two lines alternate between the beginning and target values):
```
func _on_Tween_tween_all_completed():
	mod = 0.0 if mod == modulate_target else modulate_target
	sca = Vector2(0.5,0.5) if sca == scale_target else scale_target
	$Tween.interpolate_property($Highlight, "scale", $Highlight.scale, sca, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Highlight, "modulate:a", $Highlight.modulate.a, mod, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
```

## The Paddle

Open `res://Paddle/Paddle.tscn`; add a Tween node as a child of the Paddle node, and then append the following to the end of `hit(_ball)`:
```
  $Tween.interpolate_property($Images/Highlight, "modulate:a", 1.0, 0.0, time_highlight, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $Tween.interpolate_property($Images/Highlight, "scale", Vector2(2.0,2.0), Vector2(1.0,1.0), time_highlight_size, Tween.TRANS_BOUNCE, Tween.EASE_IN)
  $Tween.start()
```

## The Bricks

Open `res://Brick/Brick.tscn` and add a Tween node as a child of the Brick node. 

Replace line 14 in `res://Brick/Brick.gd` with the following:
```
  position.x = new_position.x
  position.y = -100
  $Tween.interpolate_property(self, "position", position, new_position, 0.5 + randf()*2, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
  $Tween.start()

```

Replace line 36 in `res://Brick/Brick.gd` with the following:
```
  if dying and not $Confetti.emitting and not $Tween.is_active():
```

Then, add the following at the end of the `die()` function:
```
  $Tween.interpolate_property(self, "position", position, Vector2(position.x, 1000), time_fall, Tween.TRANS_EXPO, Tween.EASE_IN)
  $Tween.interpolate_property(self, "rotation", rotation, -PI + randf()*2*PI, time_rotate, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
  $Tween.interpolate_property($ColorRect, "color:a", $ColorRect.color.a, 0, time_a, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $Tween.interpolate_property($ColorRect, "color:s", $ColorRect.color.s, 0, time_s, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $Tween.interpolate_property($ColorRect, "color:v", $ColorRect.color.v, 0, time_v, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
  $Tween.start()
```

In `res://Game.tscn`, update the Brick_Container node so it is now Pause Mode = Process.

## Main Menu

Open `res://UI/Main_Menu.tscn`. As the first child of the Main_Menu node, add a StaticBody2D and rename it Boundary. As a child of Boundary, add a CollisionPolygon2D. Draw a polygon that surrounds the screen on all four sides.

As a child between the Background and Label nodes, Instance a copy of the Ball scene (`res://Ball/Ball.tscn`). Position the ball at (200,200) and give it a Linear Velocity of (800,550)

Attach the following script to the Boundary node as `res://UI/Boundary.gd`:
```
extends StaticBody2D

func hit(ball):
  ball.max_speed *= 1.05
  ball.min_speed *= 1.05
  ball.max_speed = clamp(ball.max_speed, ball.max_speed, 1500)
  ball.min_speed = clamp(ball.min_speed, ball.min_speed, ball.max_speed)
```

## Screen Shake

Finally, open `res://Game.tscn`. As a child of the Game node, attach a Camera2D and rename it Camera. *Set the Camera as Current = yes in the Inspector.* Attach the following script to the Camera node (this would be a good script to save in your GitHub Gists for later):
```
extends Camera2D
# Originally developed by Squirrel Eiserloh (https://youtu.be/tu-Qe66AvtY)
# Refined by KidsCanCode (https://kidscancode.org/godot_recipes/2d/screen_shake/)

export var decay = 2                      # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(10, 0)    # Maximum hor/ver shake in pixels.
export var max_roll = 0.05                  # Maximum rotation in radians (use sparingly).
export (NodePath) var target                # Assign the node this camera will follow.

var trauma = 0.0                            # Current shake strength.
var trauma_power = 3                        # Trauma exponent. Use [2, 3].
var max_trauma = 4.0
onready var noise = OpenSimplexNoise.new()
var noise_y = 0

func _ready():
  randomize()
  noise.seed = randi()
  noise.period = 4
  noise.octaves = 2

func _process(delta):
  if target:
    global_position = get_node(target).global_position
  if trauma:
    trauma = max(trauma - decay * delta, 0)
    shake()
    
func shake():
  var amount = pow(min(trauma,1.0), trauma_power)
  noise_y += 1
  rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
  offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
  offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
  
func add_trauma(amount):
  trauma = min(trauma + amount, max_trauma)
```

Open `res://Ball/Ball_Container.gd`. Replace `_physics_process` with the following:
```
func _physics_process(_delta):
  if get_child_count() == 0:
    Global.update_lives(-1)
    var camera = get_node_or_null("/root/Game/Camera")
    if camera != null:
      camera.add_trauma(3.0)
    make_ball()
```

---

Test the game and make sure it is working correctly. You should be able to see the bricks randomly fall into their designated location and fall (fade and rotate) off the screen as they are hit. There is lots of new movement: the ball, the paddle, the indicators. When you die, the screen should shake. There should also be an animated ball on the main menu.

Quit Godot. In GitHub desktop, you should now see the updated files listed in the left panel. In the bottom of that panel, type a Summary message (something like "Completes the exercise") and press the "Commit to master" button. On the right side of the top, black panel, you should see a button labeled "Push origin". Press that now.

If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-03b-Tweening-and-Screen-Shake) on Canvas.

The final state of the file should be as follows (replacing my information with yours):
```
# Exercise-03b-Tweening-and-Screen-Shake

Exercise for MSCH-C220

The second exercise adding "juicy" features to a simple brick-breaker game.

## To play

Move the paddle using the mouse. Help the ball break all the bricks before you run out of time.


## Implementation

Built using Godot 3.5

## References
 * [Juice it or lose it — a talk by Martin Jonasson & Petri Purho](https://www.youtube.com/watch?v=Fy0aCDmgnxg)
 * [Puzzle Pack 2, provided by kenney.nl](https://kenney.nl/assets/puzzle-pack-2)
 * [Open Color open source color scheme](https://yeun.github.io/open-color/)
 * [League Gothic Typeface](https://www.theleagueofmoveabletype.com/league-gothic)
 * [Orbitron Typeface](https://www.theleagueofmoveabletype.com/orbitron)
 

## Future Development

Adding a face, Comet trail, Music and Sound, Shaders, etc.

## Created by 

Jason Francis
```
