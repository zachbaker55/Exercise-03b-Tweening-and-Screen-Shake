extends StaticBody2D

var score = 0
var new_position = Vector2.ZERO
var dying = false
export var time_appear = 0.5
export var time_fall = 0.8
export var time_rotate = 1.0
export var time_a = 0.8
export var time_s = 1.2
export var time_v = 1.5

func _ready():
	position.x = new_position.x
	position.y = -100
	$Tween.interpolate_property(self,"position",position, new_position, + randf()*2,Tween.TRANS_BOUNCE,Tween.EASE_IN_OUT)
	$Tween.start()
	
	if score >= 100:
		$ColorRect.color = Color8(224,49,49)
	elif score >= 90:
		$ColorRect.color = Color8(255,146,43)
	elif score >= 80:
		$ColorRect.color = Color8(255,212,59)
	elif score >= 70:
		$ColorRect.color = Color8(148,216,45)
	elif score >= 60:
		$ColorRect.color = Color8(34,139,230)
	elif score >= 50:
		$ColorRect.color = Color8(132,94,247)
	elif score >= 40:
		$ColorRect.color = Color8(190,75,219)
	else:
		$ColorRect.color = Color8(134,142,150)

func _physics_process(_delta):
	if dying and not $Confetti.emitting and not $Tween.is_active():
		queue_free()

func hit(_ball):
	die()

func die():
	dying = true
	collision_layer = 0
	collision_mask = 0
	Global.update_score(score)
	get_parent().check_level()
	$Confetti.emitting = true
	$Tween.interpolate_property(self,"position",position,Vector2(position.x,1000),time_fall,Tween.TRANS_EXPO,Tween.EASE_IN)
	$Tween.interpolate_property(self,"rotation",rotation,-PI+randf()*2*PI,time_rotate,Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect,"color:a",$ColorRect.color.a,0,time_a,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect,"color:s",$ColorRect.color.s,0,time_s,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.interpolate_property($ColorRect,"color:v",$ColorRect.color.v,0,time_v,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$Tween.start()
