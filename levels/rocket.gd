extends Area2D

const EXPLOSION = preload("res://levels/explosion.tscn")
const BLAST = preload("res://levels/rocket_blast.tscn")

var MAX_SPEED = 5
var vx = 0
var ax = 1

func _ready():
	connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
		if body.name != "player":
			explode()

func set_accel(accel):
	ax = accel
	$TextureRect.flip_h = (ax < 0)

func explode():
	get_parent().shake()
	for i in range(5):
		var explosion = EXPLOSION.instance()
		explosion.offset.x = position.x + (randi() % 24) - 12
		explosion.offset.y = position.y + (randi() % 24) - 12
		get_parent().add_child(explosion)
	var blast = BLAST.instance()
	blast.position.x = position.x
	blast.position.y = position.y
	get_parent().add_child(blast)
	$"/root/RocketSound".play()
	queue_free()
	
func _process(delta):
	vx += ax
	
	if vx > MAX_SPEED:
		vx = MAX_SPEED
	elif vx < -MAX_SPEED:
		vx = -MAX_SPEED
		
	position.x += vx
	
	if (position.x < 0 or position.x > 340):
		queue_free()
