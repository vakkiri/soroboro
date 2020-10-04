extends Area2D

var _open = false

export(int) var next0
export(int) var next1
export(int) var next2
export(int) var next3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func open():
	if not _open:
		$"/root/DoorSlide".play()
	$AnimatedSprite.playing = true
	_open = true


func use():
	if (_open):
		var root = get_tree().get_root().find_node("root", true, false)
		var timestep = 	root.active_indicator
		if timestep == 0:
			root.load_level(next0)
		elif timestep == 1:
			root.load_level(next1)
		elif timestep == 2:
			root.load_level(next2)
		elif timestep == 3:
			root.load_level(next3)
			
