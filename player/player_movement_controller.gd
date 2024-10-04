extends CharacterBody2D
class_name PlayerMovementController

signal jumped

# Step up
@export var auto_step_size: float = 3

# Horizontal motion
@export var move_speed: float = 200
@export var turning_speed: float = 7

# Vertical motion
@export var min_jump_height: float = 200
@export var max_jump_height: float = 400
@export var slow_gravity: float = 800 # When falling
@export var fast_gravity: float = 1800 # When fast falling
@export var terminal_velocity: float = 500.0

# Jump grace & auto jump
@export var jump_grace: float = 0.1
@export var auto_jump: float = 0.1

var grounded

# Movement variables
var inertia: float = 0
var fatigue: float = 0
var current_move: float = 0
var has_jumped: bool = false
var double_jump: bool = false
var auto_jump_time: float = 0
var jump_grace_time: float = 0

# Dash settings
var dash_speed = 3
var dash_duration = 0.15
var dash_cooldown = 1
var can_dash = true
var is_dashing = false

var wall_slide_speed = 50

# slide settings
var slide_speed = 500.0
var slide_end_speed = 185.0
var slide_cooldown = .5
var is_sliding = false
var can_slide = true
var slide_time_passed = 0
var slide_duration = .5

# Connections
@onready var bottom_left_ray: RayCast2D = $CollisionShape2D/BottomLeft
@onready var bottom_right_ray: RayCast2D = $CollisionShape2D/BottomRight
@onready var top_left_ray: RayCast2D = $CollisionShape2D/TopLeft
@onready var top_right_ray: RayCast2D = $CollisionShape2D/TopRight


func _ready() -> void:
	PlayerStatsManager.player = self

func _physics_process(delta: float) -> void:
	# Detect dash
	if Input.is_action_just_pressed("dash") and not is_dashing and can_dash:
		is_dashing = true
		can_dash = false
		
	# Detect slide
	if Input.is_action_just_pressed("slide") and not is_sliding and can_slide and is_on_floor():
		is_sliding = true
		can_slide = false
		
	calculate_vertical_movement(delta)
	calculate_horizontal_movement(delta)
	step_check(velocity.x, delta)
	move_and_slide()
	PlayerStatsManager._set_player_position(position)

func calculate_horizontal_movement(delta: float):
	var horizontal_axis = Input.get_axis("move_left", "move_right")
	
	# Calculate horizontal inertia
	if horizontal_axis:
		inertia = clamp(inertia + horizontal_axis * turning_speed * delta, -1, 1)
		fatigue = clamp(fatigue + turning_speed * delta, 0, 1)
	else:
		fatigue = clamp(fatigue - turning_speed * delta, 0, 1)
		
		# Calculate decay
		var decay = sign(inertia) * turning_speed * delta
		
		if abs(inertia) <= decay:
			inertia = 0
		else:
			inertia -= decay
	
	inertia = lerp(horizontal_axis, inertia, fatigue)
	
	var turning_control = 1 - abs(inertia)
	current_move = clamp(lerp(inertia, horizontal_axis, turning_control), -1, 1) * move_speed
	
	if horizontal_axis:
		if is_dashing:
			dash()
		elif is_sliding:
			ground_slide(delta)
		else:
			velocity.x = current_move
	else:
		velocity.x = 0

func calculate_vertical_movement(delta: float):
	# Decay jump grace time
	jump_grace_time = max(jump_grace_time - delta, 0)
	
	# Remember that we were on the floor `x` seconds ago
	if is_on_floor():
		jump_grace_time = jump_grace
		grounded = true
		double_jump = false
	else:
		grounded = false
		
	var floored = jump_grace_time > 0

	# Velocity with fast-falling
	velocity.y = clamp(
		velocity.y +
			(slow_gravity if not Input.is_action_just_pressed("move_down") else fast_gravity) * delta,
		-terminal_velocity,
		terminal_velocity)
		
	if is_on_wall():
		wall_jump_slide()
		
	if Input.is_action_just_pressed("move_up"):
		if floored:
			jump()
		else:
			auto_jump_time = auto_jump
			# Double jump
			if Input.is_action_just_pressed("move_up"):
				if not double_jump:
					jump()
					double_jump = true  
	elif floored and auto_jump_time > 0:
		if Input.is_action_pressed("move_up"):
			jump()		

	# Jump when holding space
	#if floored and vertical_dictionary["move_up_held"]:
		#jump()
	
	# Decay auto jump time
	auto_jump_time = max(auto_jump_time - delta, 0)
	
	if has_jumped and Input.is_action_just_released("move_up") and velocity.y < 0:
		velocity *= min_jump_height / max_jump_height
		has_jumped = false

func step_check(horizontal_stride: float, delta: float):
	# Figure out which raycast to use
	var bottom_ray: RayCast2D = null
	var top_ray: RayCast2D = null
	var step_possible: bool = true
	
	if horizontal_stride < 0:
		bottom_ray = bottom_left_ray
		top_ray = top_left_ray
	elif horizontal_stride > 0:
		bottom_ray = bottom_right_ray
		top_ray = top_right_ray
	else:
		step_possible = false
	
	# Check step can even happen
	if not step_possible:
		return
	
	# Make sure the raycasts are frame accurate
	bottom_ray.force_raycast_update()
	top_ray.force_raycast_update()
	
	# Make sure it's possible for us to step into something
	if not bottom_ray.is_colliding():
		return
	
	var bottom_point: Vector2 = bottom_ray.get_collision_point()
	var bottom_length: float = bottom_ray.global_position.distance_to(bottom_point)
	
	# Will we step into something?
	if bottom_length > abs(horizontal_stride * delta):
		return
	
	# Check if something is blocking it
	if top_ray.is_colliding():
		# Figure out how steep the step is
		var top_point: Vector2 = top_ray.get_collision_point()
		var step_size = bottom_ray.global_position.y - top_point.y
		
		if step_size <= auto_step_size:
			# Move player up and make sure they don't continue falling
			position.y -= step_size + 2
			velocity.y = min(velocity.y, 0)

func jump():
	jumped.emit()
	velocity.y = -max_jump_height
	has_jumped = true
	auto_jump_time = 0
	jump_grace_time = 0

func dash():
	velocity.x = current_move * dash_speed
	await get_tree().create_timer(dash_duration).timeout
	is_dashing = false
	await get_tree().create_timer(dash_cooldown).timeout
	can_dash = true

func wall_jump_slide():
	if Input.is_action_just_pressed('move_up') and velocity.y >= 0:
		jump()

func ground_slide(delta):
	slide_time_passed += delta
	var t = clamp(slide_time_passed / slide_duration, 0, 1)
	var easing = t * t * t
	
	var initial_push_amount = slide_speed
	initial_push_amount -= slide_time_passed

	var current_push_amount = lerp(initial_push_amount, slide_end_speed, easing)
	
	if velocity.x > 0:
		velocity.x = current_push_amount
	elif velocity.x < 0:
		velocity.x = -current_push_amount
		
	if Input.is_action_just_released("slide") or current_push_amount == slide_end_speed:
		is_sliding = false
		velocity.x = 0
		slide_time_passed = 0
		await get_tree().create_timer(slide_cooldown).timeout
		can_slide = true
