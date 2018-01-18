extends KinematicBody2D

var sprite_node
var lbl_Cooldown = null
var label = null
var parent_node = null
var animation_node = null

var timer_DashTime = null
var timer_DashCD = null
var dash_time = 0.075
var dash_cooldown = 5
var isDashing = false
var canDash = true
var isDucked = false
var canDuck = true

var input_direction = 0
var direction = 1

var speed = Vector2()
var velocity = Vector2()

const DASH_SPEED = 5000
const MAX_SPEED = 600
const ACCELERATION = 2600
const DECELERATION = 5000

const JUMP_FORCE = 1000
const GRAVITY = 2800
const MAX_FALL_SPEED = 1400

var jump_count = 0
const MAX_JUMP_COUNT = 2

func _ready():
	set_process(true)
	set_process_input(true)
	# Sprite of the player
	sprite_node = get_node("Sprite")
	# How long the Player is dashing
	timer_DashTime = Timer.new()
	timer_DashTime.set_one_shot(true)
	timer_DashTime.set_wait_time(dash_time)
	timer_DashTime.connect("timeout", self, "Dash_on_timeout_complete")
	add_child(timer_DashTime)
	# Cooldown for dash
	timer_DashCD = Timer.new()
	timer_DashCD.set_one_shot(true)
	timer_DashCD.set_wait_time(dash_cooldown)
	timer_DashCD.connect("timeout", self, "CD_on_timeout_complete")
	add_child(timer_DashCD)
	# Label
	label = get_node("Label")
	label.set_text("Cooldown")
	# Animation
	parent_node = get_parent()
	animation_node = parent_node.get_node("AnimationPlayer")

 # Whem the timers timeout completes
func Dash_on_timeout_complete():
	isDashing = false

func CD_on_timeout_complete():
	canDash = true

func _input(event):
	if jump_count < MAX_JUMP_COUNT and Input.is_action_pressed("jump"):
		speed.y = -JUMP_FORCE
		jump_count += 1
		if(isDucked):
			animation_node.play_backwards("player_duck")
			canDuck = false
			isDucked = false

func _process(delta):
	if input_direction:
		direction = input_direction

	# Cant Jump when ducked
	# Try moving into seperat Function (like jump)
	if Input.is_action_pressed("duck") and !isDucked and canDuck:
		animation_node.play("player_duck")
		isDucked = true
	if !Input.is_action_pressed("duck") and isDucked:
		animation_node.play_backwards("player_duck")
		isDucked = false

	if Input.is_action_pressed("move_left"):
		input_direction = -1
		sprite_node.set_flip_h(true)
	elif Input.is_action_pressed("move_right"):
		input_direction = 1
		sprite_node.set_flip_h(false)
	else:
		input_direction = 0

	if Input.is_action_pressed("dash") and isDashing == false and canDash == true:
		if(sprite_node.is_flipped_h()):
			speed.x -= DASH_SPEED
			velocity = Vector2(speed.x * delta * 1, speed.y * delta)
		elif(!sprite_node.is_flipped_h()):
			speed.x += DASH_SPEED
			velocity = Vector2(speed.x * delta * 1, speed.y * delta)
		isDashing = true
		canDash = false
		timer_DashCD.start()
		timer_DashTime.start()

	if(!isDashing):
		if input_direction == - direction:
			speed.x /= 3
		if input_direction:
			speed.x += ACCELERATION * delta
		else:
			speed.x -= DECELERATION * delta
		speed.x = clamp(speed.x, 0, MAX_SPEED)
		speed.y += GRAVITY * delta
		if speed.y > MAX_FALL_SPEED:
			speed.y = MAX_FALL_SPEED

	label.set_text(str(timer_DashCD.get_time_left()))
	if(!isDashing):
		velocity = Vector2(speed.x * delta * direction, speed.y * delta)
	var movement_remainder = move(velocity)

	if is_colliding():
		var normal = get_collision_normal()
		var final_movement = normal.slide(movement_remainder)
		speed = normal.slide(speed)
		move(final_movement)
		
		if normal == Vector2(0, -1):
			jump_count = 0
			canDuck = true