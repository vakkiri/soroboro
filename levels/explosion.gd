extends AnimatedSprite

func _ready():
	speed_scale = rand_range(2.0, 4.0)
	connect("animation_finished", self, "_on_animation_finished")

func _on_animation_finished():
	queue_free()

