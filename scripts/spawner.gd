extends Node2D

const SLIME = preload("res://levels/slime.tscn")
var spawn_timer = 0
export var side = "RIGHT"

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_timer = 1


func _process(delta):
	spawn_timer -= delta
	
	if spawn_timer <= 0:
		spawn_timer = 3.5
		var slime = SLIME.instance()
		slime.position.x = position.x
		slime.position.y = position.y
		slime.start_y = position.y
		if (side == "RIGHT"):
			slime.SPEED_ACCEL = -11.5
			slime.find_node("AnimatedSprite").flip_h = true
		else:
			slime.SPEED_ACCEL = 11.5
		get_parent().add_child(slime)
