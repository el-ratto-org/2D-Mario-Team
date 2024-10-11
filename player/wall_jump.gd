extends Node2D

signal jumped

@export var target: CharacterBody2D

@export var jump_horizontal_length: float = 300
@export var jump_vertical_height: float = 400


func update(delta: float) -> void:
	assert(target != null, "Must assign player to script")
	
	# Remember that we pressed jump
	if Input.is_action_just_pressed("move_up"):
		target.knockback_direction.x = target.get_wall_normal().x * jump_horizontal_length
		target.knockback_direction.y = -jump_vertical_height
		target.knockback = 1
