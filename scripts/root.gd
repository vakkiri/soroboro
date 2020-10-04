extends Node2D

var INDICATOR_SWITCH_TIME = 5
var NUM_INDICATORS = 4
var time = 0
var active_indicator = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var child_name = "indicator" + str(active_indicator + 1)
	get_node(child_name).set_active()


func _process(delta):
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


func load_level(level):
	find_node("level", true, false).queue_free()
	remove_child(find_node("level", true, false))
	add_child(load("res://levels/level" +  str(level) + ".tscn").instance())

	
	
