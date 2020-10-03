extends TextureRect

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_active():
	texture = load("res://assets/images/indicator_active.png")
	
func set_inactive():
	texture = load("res://assets/images/indicator_inactive.png")
