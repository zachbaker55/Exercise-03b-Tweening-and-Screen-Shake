extends Camera2D


export var decay = 2
export var max_offset = Vector2(10,0)
export var max_roll = 0.05
export (NodePath) var target

var trauma = 0.0
var trauma_power = 3
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
	var amount = pow(min(trauma,1.0),trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed,noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2,noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*2,noise_y)
	
func add_trauma(amount):
	trauma = min(trauma + amount,max_trauma) 
 
