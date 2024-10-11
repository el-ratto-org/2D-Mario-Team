extends Node2D

@export var target: CharacterBody2D
@export var move_speed: float = 15
@export_range(0, 1000, 0.5) var jump_force: float = 300
@export_range(0, 100, 0.1, "suffix:%") var turning_speed: float = 30

var current_lantern = null
var jump_amount: float = 0
var flying_amount: float = 0
var inertia: float = 0


func update(delta: float) -> void:
	assert(target != null, "Must assign player to script")
	
	if current_lantern != null:
		# Determine flying ability based on distance to the lantern
		var lantern_radius = current_lantern.lantern_radius_current
		var lantern_distance = current_lantern.global_position.distance_to(global_position)
		var lantern_distance_normalised = clamp(lantern_distance / lantern_radius, 0.0, 1.0)
		flying_amount = 1.0 - lantern_distance_normalised
	else:
		# Reset flying ability if not near a lantern,
		# then bail because we don't need to think about
		# flying logic if we can't fly
		flying_amount = 0
		return
	
	# Decay the current lift off over time
	jump_amount = lerp(jump_amount, 0.0, delta * 7.5)
	
	# Have we jumped while flying?
	if Input.is_action_just_pressed("move_up") and target.is_on_floor():
		jump_amount = jump_force
	
	# Get flying direction & speed
	var max_move_speed = move_speed * 1000 * delta
	var vertical_axis = Input.get_axis("move_up", "move_down")
	var vertical_motion = vertical_axis * max_move_speed
	
	if vertical_motion < 0:
		# We're moving upwards, make sure we're slowing down,
		# depending on how much we can actually fly
		vertical_motion *= flying_amount
	elif vertical_motion > 0:
		# If we're moving downwards,
		# then we probably don't want to be jumping
		jump_amount = 0
	
	# Smoothly interpolate inertia towards the desired vertical motion
	inertia = lerp(inertia, vertical_motion, turning_speed / 100)
	
	target.movement_direction.y = inertia - jump_amount


func _on_lantern_detection_area_entered(area: Area2D) -> void:
	current_lantern = area.owner
	


func _on_lantern_detection_area_exited(area: Area2D) -> void:
	print(area.owner)
	current_lantern = null
