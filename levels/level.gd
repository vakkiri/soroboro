extends Node2D

var shake_time = 0
var shake_decay = 1
var shake_factor = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	shake_time -= shake_decay * delta
	
	if shake_time <= 0:
		shake_time = 0
		position.x = 0
		position.y = 0
	else:
		if position.x < -2:
			position.x += rand_range(1, shake_factor) * delta
		elif position.x > 2:
			position.x += rand_range(1, shake_factor) * delta
		elif randi() % 2 == 0:
			position.x += rand_range(1, shake_factor) * delta
		else:
			position.x -= rand_range(1, shake_factor) * delta
			
		if position.y < -2:
			position.y += rand_range(1, shake_factor) * delta
		elif position.y > 2:
			position.y += rand_range(1, shake_factor) * delta
		elif randi() % 2 == 0:
			position.y += rand_range(1, shake_factor) * delta
		else:
			position.y -= rand_range(1, shake_factor) * delta
			


func shake():
	shake_time = 0.25
	
