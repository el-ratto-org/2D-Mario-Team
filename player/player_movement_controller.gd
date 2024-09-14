extends Node
class_name PlayerMovementController

@export var character: CharacterBody2D

# Horizontal motion
@export var move_speed: float = 200
@export var turning_speed: float = 3

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
var turning_fatigue: float = 0
var current_move: float = 0
var jumped: bool = false
var auto_jump_time: float = 0
var jump_grace_time: float = 0

# Input variables
var horizontal_axis

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
	character.move_and_slide()

func calculate_horizontal_movement(delta: float):

	# Calculate turning fatigue
	if horizontal_axis:
		turning_fatigue = clamp(turning_fatigue + horizontal_axis * turning_speed * delta, -1, 1)
	else:
		# Calculate decay
		if abs(turning_fatigue) <= turning_speed * delta:
			turning_fatigue = 0
		else:
			turning_fatigue -= sign(turning_fatigue) * turning_speed * delta

	var turning_control = 1 - abs(turning_fatigue)
	current_move = clamp(lerp(current_move, horizontal_axis * move_speed, turning_control), -move_speed, move_speed)

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
		jump()
	
	# Decay auto jump time
	auto_jump_time = max(auto_jump_time - delta, 0)
	
	if jumped and vertical_dictionary["move_up_released"] and character.velocity.y < 0:
		character.velocity *= min_jump_height / max_jump_height
		jumped = false

func jump():
	character.velocity.y = -max_jump_height
	jumped = true
	auto_jump_time = 0
	jump_grace_time = 0
