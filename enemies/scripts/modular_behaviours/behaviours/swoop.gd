extends EnemyBehaviour

signal swoop_finished

@export var speed: float = 100

var swoop_points: Array[Vector2]

@onready var debug_lines: Line2D = $"../../Line2D"

func _calculate_swoop_path(target: Vector2) -> void:
	# calculate swoop direction and swoop arc radius
	var height = abs(global_position.y - target.y)
	var width = max(abs(global_position.x - target.x), height)
	var direction_value = -_player_horizontal_direction()
	
	# calculate the starting angle
	var angle = ((2 * PI) if direction_value >= 0 else (PI))
	# set how many points in the swoop arc we want
	var points = 50
	# set the angle between each point
	var angle_steps = (PI / points) * direction_value
	
	# reset array of points
	swoop_points.clear()
	var desired_points: Array[Vector2]
	for n in (points + 1):
		# calculate point position
		var point_pos = global_position + Vector2(cos(angle) * width, sin(angle) * height)
		# clamp height to player target height
		point_pos.y = clamp(point_pos.y, global_position.y, target.y)
		# add position to array
		swoop_points.push_back(point_pos)
		# increment angle
		angle += angle_steps
	
	# debug lines
	debug_lines.clear_points()
	var previous_point: Vector2 = global_position
	for point in swoop_points:
		debug_lines.add_point(previous_point - global_position)
		previous_point = point
	debug_lines.add_point(swoop_points.back() - global_position)
	

func _run() -> void:
	# calculate direction to fly
	var direction_to_point: Vector2 = (swoop_points.front() - global_position).normalized()
	
	# set velcotiy
	character.velocity = direction_to_point * speed
	#character.velocity = Vector2.ZERO
	
	# remove point from array once reached
	if global_position.distance_to(swoop_points.front()) < 20:
		swoop_points.pop_front()
	
	# detect end of swoop
	if swoop_points.size() <= 0:
		swoop_finished.emit()
