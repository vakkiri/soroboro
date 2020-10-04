extends Area2D


func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	if body.name == "player":
		activate()
		
		
func activate():
	get_parent().get_node("TextureRect").texture = load("res://assets/images/switch_active.png")
	get_parent().get_parent().get_node("door").open()
	
