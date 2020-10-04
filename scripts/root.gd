extends Node2D

var INDICATOR_SWITCH_TIME = 5
var NUM_INDICATORS = 4
var time = 0
var active_indicator = 0
var state = "PLAYING"
var load_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("CanvasLayer").get_node("gameover").visible = false
	state = "LOADING"
	time = 0
	load_timer = 1
	var child_name = "indicator" + str(active_indicator + 1)
	get_node(child_name).set_active()


func _process(delta):
	if state == "DEATH":
		if Input.is_action_pressed("jump") or Input.is_action_pressed("shoot"):
			get_tree().reload_current_scene()
	elif state == "LOADING":
		load_timer -= delta
		if load_timer <= 0:
			state = "PLAYING"
		var left_curtain = get_node("CanvasLayer").get_node("left_curtain")
		var right_curtain = get_node("CanvasLayer").get_node("right_curtain")
		if (left_curtain.rect_position.x > -320):
			left_curtain.rect_position.x -= 320 * delta
		if (right_curtain.rect_position.x < 320):
			right_curtain.rect_position.x += 320 * delta
	else:
		time += delta
		if (time > INDICATOR_SWITCH_TIME):
			var child_name = "indicator" + str(active_indicator + 1)
			get_node(child_name).set_inactive()
			time -= INDICATOR_SWITCH_TIME
			active_indicator += 1
			if (active_indicator >= NUM_INDICATORS):
				active_indicator = 0
			child_name = "indicator" + str(active_indicator + 1)
			get_node(child_name).set_active()


func on_death():
	get_node("CanvasLayer").get_node("gameover").visible = true
	state = "DEATH"
	
	
func load_level(level):
	var left_curtain = get_node("CanvasLayer").get_node("left_curtain")
	var right_curtain = get_node("CanvasLayer").get_node("right_curtain")
	left_curtain.rect_position.x = 0
	right_curtain.rect_position.x = 0
	state = "LOADING"
	load_timer = 1
	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://levels/level" +  str(level) + ".tscn").instance())

	
	
