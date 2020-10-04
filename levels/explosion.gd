extends AnimatedSprite

func _ready():
	randomize()
	frame = 0
	speed_scale = rand_range(1.5, 3.0)
	connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	queue_free()

