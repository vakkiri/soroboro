extends KinematicBody2D

const ROCKET = preload("res://levels/rocket.tscn")
const EXPLOSION = preload("res://levels/explosion2.tscn")

var motion = Vector2()
const UP = Vector2(0, -1)
const GRAVITY = 8.5
const MAX_SPEED = 90
const SPEED_ACCEL = 12
const JUMP = -195
const FRICTION = 5
const AIR_DRAG = 3

var left_pressed_last = false
var facing_left = false

var MAX_Y = 550 / 4
var vx = 0
var vy = 0

var jump_period

var fall_timer = 0
var death_timer = 0

var state = "ALIVE"

func _ready():
	$AnimatedSprite.animation = "idle"
	state = "ALIVE"
	facing_left = false
	vx = 0
	jump_period = 0


func handle_gravity(delta):
	if Input.is_action_pressed("jump") or state == "HIT" or Input.is_action_pressed("ui_up"):
		motion.y += GRAVITY
	else:
		motion.y += GRAVITY * 2


func handle_movement():
	facing_left = left_pressed_last and not (Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left")) or (Input.is_action_pressed("ui_left") and not Input.is_action_pressed("ui_right"))
			
	var dvx
	
	if is_on_floor():
		dvx = FRICTION
	else:
		dvx = AIR_DRAG
	if vx > 0:
		vx = max(vx - dvx, 0)
	elif vx < 0:
		vx = min(vx + dvx, 0)
		
	if Input.is_action_pressed("ui_right") and not (Input.is_action_pressed("ui_left") and left_pressed_last):
		if vx < 0:
			vx += SPEED_ACCEL * 2
		else:
			vx += SPEED_ACCEL
	elif Input.is_action_pressed("ui_left") and not (Input.is_action_pressed("ui_right") and not left_pressed_last):
		if vx > 0:
			vx -= SPEED_ACCEL * 2
		else:
			vx -= SPEED_ACCEL
				
	motion.x = vx
	
	$AnimatedSprite.flip_h = facing_left
				
	if motion.x != 0:
		$AnimatedSprite.animation = "run"
	else:
		$AnimatedSprite.animation = "idle"

func _physics_process(delta):
	if state == "ALIVE":
		_alive_process(delta)
	elif state == "HIT":
		$AnimatedSprite.animation = "hit"
		death_timer -= delta
		if death_timer <= 0:
			$AnimatedSprite.animation = "ded"
			state = "DEAD"
		_hit_process(delta)
	else:
		die()
		
		
func _hit_process(delta):
	handle_gravity(delta)
	
	if (motion.y > MAX_Y):
		motion.y = MAX_Y
	if (vx > MAX_SPEED):
		vx = MAX_SPEED
	if (vx < -MAX_SPEED):
		vx = -MAX_SPEED
		
	jump_period -= delta;
	if (jump_period < 0):
		jump_period = 0
		
	motion.x = vx
	
	if is_on_floor():
		jump_period = 0.2
		if fall_timer > 0.5:
			$"/root/FallSound".play()
			fall_timer = 0
	else:
		fall_timer += delta
	
	motion = move_and_slide(motion, UP)
	if position.x > 320:
		position.x -= 320
	if position.x < 0:
		position.x += 320
		
		
func _alive_process(delta):
	if Input.is_action_just_pressed("ui_right"):
		left_pressed_last = false
	if Input.is_action_just_pressed("ui_left"):
		left_pressed_last = true
	if Input.is_action_just_pressed("ui_down"):
		check_door()
		
	handle_gravity(delta)
	
	if (motion.y > MAX_Y):
		motion.y = MAX_Y
	if (vx > MAX_SPEED):
		vx = MAX_SPEED
	if (vx < -MAX_SPEED):
		vx = -MAX_SPEED
		
	jump_period -= delta;
	if (jump_period < 0):
		jump_period = 0
		
	handle_movement()
	
	if is_on_floor():
		jump_period = 0.2
		if fall_timer > 0.5:
			$"/root/FallSound".play()
			fall_timer = 0
	else:
		fall_timer += delta
	if jump_period > 0:
		if Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("ui_up"):
			motion.y = JUMP
			$"/root/JumpSound".play()
			jump_period = 0
	if Input.is_action_just_pressed("shoot"):
		for i in range(5):
			var explosion = EXPLOSION.instance()
			explosion.offset.x = position.x + (randi() % 14)
			explosion.offset.y = position.y + (randi() % 8) - 4
			if (facing_left):
				explosion.offset.x -= 16
			get_parent().add_child(explosion)
		
		var rocket = ROCKET.instance()
		if facing_left:
			rocket.set_accel(-0.3)
			rocket.position.x = position.x
			rocket.position.y = position.y
		else:
			rocket.set_accel(0.3)
			rocket.position.x = position.x
			rocket.position.y = position.y
		get_parent().add_child(rocket)
		
	var prex = position.x
	var prey = position.y
	motion = move_and_slide(motion, UP)
	if position.x > 320:
		position.x -= 320
	if position.x < 0:
		position.x += 320


func hit():
	if state == "ALIVE":
		state = "HIT"
		death_timer = 1
		motion.y = -150


func die():
	get_tree().get_root().find_node("root", true, false).on_death()


func check_door():
	var door = get_tree().get_root().find_node("door", true, false)
	if self in door.get_overlapping_bodies():
		door.use()
