extends Control

export var indicator_margin = Vector2(25, 15)
export var indicator_index = 25
onready var Indicator = load("res://UI/Indicator.tscn")

func _ready():
	update_score()
	update_time()
	update_lives()


func update_score():
	$Score.text = "Score: " + str(Global.score)

func update_time():
	$Time.text = "Time: " + str(Global.time)

func update_lives():
	var indicator_pos = Vector2(indicator_margin.x, Global.VP.y - indicator_margin.y)
	for i in $Indicator_Container.get_children():
		i.queue_free()
	for i in range(Global.lives):
		var indicator = Indicator.instance()
		indicator.position = Vector2(indicator_pos.x + i*indicator_index, indicator_pos.y)
		$Indicator_Container.add_child(indicator)

func _on_Timer_timeout():
	Global.update_time(-1)
