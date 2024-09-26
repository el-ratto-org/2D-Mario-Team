extends Node2D
class_name PlayerMovementController

@export var character: CharacterBody2D

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

# Movement variables
var inertia: float = 0
var fatigue: float = 0
var current_move: float = 0
var jumped: bool = false
var auto_jump_time: float = 0
var jump_grace_time: float = 0

# Connections
@onready var bottom_left_ray: RayCast2D = $"../CollisionShape2D/BottomLeft"
@onready var bottom_right_ray: RayCast2D = $"../CollisionShape2D/BottomRight"
@onready var top_left_ray: RayCast2D = $"../CollisionShape2D/TopLeft"
@onready var top_right_ray: RayCast2D = $"../CollisionShape2D/TopRight"

# Input variables
var horizontal_axis: float

var vertical_dictionary: Dictionary = {
	"move_up_pressed": false,
	"move_up_released": false,
	"move_down_pressed": false,
	"move_down_released": false,
}

func _ready() -> void:
	pass

func _set_input(h_axis: float, v_dictionary: Dictionary) -> void:
	horizontal_axis = h_axis
	vertical_dictionary = v_dictionary

func _physics_process(delta: float) -> void:
	calculate_horizontal_movement(delta)
	calculate_vertical_movement(delta)
	step_check(character.velocity.x, delta)
	character.move_and_slide()
	PlayerStatsManager._set_player_position(character.position)

func calculate_horizontal_movement(delta: float):
	# Calculate horizontal inertia
	if horizontal_axis:
		inertia = clamp(inertia + horizontal_axis * turning_speed * delta, -1, 1)
		fatigue = clamp(fatigue + delta * turning_speed, 0, 1)
	else:
		fatigue = clamp(fatigue - delta * turning_speed, 0, 1)
		
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
		character.velocity.x = current_move
	else:
		character.velocity.x = 0
	

func calculate_vertical_movement(delta: float):
	# Decay jump grace time
	jump_grace_time = max(jump_grace_time - delta, 0)
	
	# Remember that we were on the floor `x` seconds ago
	if character.is_on_floor():
		jump_grace_time = jump_grace

	var floored = jump_grace_time > 0

	# Velocity with fast-falling
	character.velocity.y = clamp(
		character.velocity.y +
			(slow_gravity if not vertical_dictionary["move_down_pressed"] else fast_gravity) * delta,
		-terminal_velocity,
		terminal_velocity)

	if vertical_dictionary["move_up_pressed"]:
		if floored:
			jump()
		else:
			auto_jump_time = auto_jump
	elif floored and auto_jump_time > 0:
		if Input.is_action_pressed("move_up"):
			jump()
	
	# Jump when holding space
	#if floored and vertical_dictionary["move_up_held"]:
		#jump()
	
	# Decay auto jump time
	auto_jump_time = max(auto_jump_time - delta, 0)
	
	if jumped and vertical_dictionary["move_up_released"] and character.velocity.y < 0:
		character.velocity *= min_jump_height / max_jump_height
		jumped = false

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
			character.position.y -= step_size + 2
			character.velocity.y = min(character.velocity.y, 0)

func jump():
	character.velocity.y = -max_jump_height
	jumped = true
	auto_jump_time = 0
	jump_grace_time = 0
