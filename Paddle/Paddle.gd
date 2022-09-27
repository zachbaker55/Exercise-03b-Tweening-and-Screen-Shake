extends KinematicBody2D

var target = Vector2.ZERO
export var speed = 10.0
var width = 0
export var time_highlight = 0.4
export var time_highlight_size = 0.3

func _ready():
	width = $CollisionShape2D.get_shape().get_extents().x
	target = Vector2(Global.VP.x / 2, Global.VP.y - width)

func _physics_process(_delta):
	target.x = clamp(target.x, 0, Global.VP.x - 2*width)
	position = target

func _input(event):
	if event is InputEventMouseMotion:
		target.x += event.relative.x

func hit(_ball):
	$Confetti.emitting = true
	$Tween.interpolate_property($Images/Highlight,"modulate:a",1.0,0.0,time_highlight,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($Images/Highlight,"scale",Vector2(2.0,2.0),Vector2(1.0,1.0),time_highlight_size,Tween.TRANS_BOUNCE,Tween.EASE_IN)
	$Tween.start()
