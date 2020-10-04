extends Area2D

var timer = 0


func _ready():
	timer = 0.1


func _process(delta):
	var collisions = get_overlapping_areas()
	for c in collisions:
		if c.is_in_group("monster"):
			c.get_parent().kill()
			
	timer -= delta
	
	if timer <= 0:
		queue_free()
