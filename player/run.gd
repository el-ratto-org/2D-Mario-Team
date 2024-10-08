extends Node2D

@export var target: CharacterBody2D
@export var move_speed: float = 12.5
@export_range(0, 100, 0.5, "suffix:%") var turning_speed: float = 30

var inertia: float = 0


func update(delta: float) -> void:
	assert(target != null, "Must assign player to script")
	
	var max_move_speed = move_speed * 1000 * delta
	var horizontal_axis = Input.get_axis("move_left", "move_right")
	var horizontal_motion = horizontal_axis * max_move_speed
	
	inertia = lerp(inertia, horizontal_motion, turning_speed / 100)
	
	if horizontal_axis:
		target.velocity.x = inertia
	else:
		target.velocity.x = 0
