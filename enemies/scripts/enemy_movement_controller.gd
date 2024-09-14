extends Node
class_name EnemyMovementController

@export var character: CharacterBody2D

# Horizontal motion
@export var move_speed: float = 200

# Vertical motion
@export var jump_height: float = 200
@export var gravity: float = 800
@export var terminal_velocity: float = 500.0


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

func _set_horizontal_input(h_axis: float) -> void:
	horizontal_axis = h_axis

func _set_vertical_input(v_dictionary: Dictionary) -> void:
	vertical_dictionary = v_dictionary

func _physics_process(delta: float) -> void:
	calculate_horizontal_movement(delta)
	calculate_vertical_movement(delta)
	character.move_and_slide()

func calculate_horizontal_movement(delta: float):
	character.velocity.x = horizontal_axis * move_speed



func calculate_vertical_movement(delta: float):
	
	# Velocity with fast-falling
	character.velocity.y = clamp(character.velocity.y + gravity * delta, -terminal_velocity, terminal_velocity)

	if vertical_dictionary["move_up_pressed"]:
		if character.is_on_floor():
			jump()

func jump():
	character.velocity.y = -jump_height
