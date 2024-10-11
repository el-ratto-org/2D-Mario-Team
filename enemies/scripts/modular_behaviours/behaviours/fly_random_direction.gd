extends EnemyBehaviour
class_name FlyRandomDirection

@export var speed: float = 100

@export_range(0, 1, 0.01, "suffix:seconds") var min_direction_change_time: float = 1
@export_range(0, 1, 0.01, "suffix:seconds") var max_direction_change_time: float = 1

@export_range(0, 360, 0.1, "degrees") var min_angle: float = 0
@export_range(0, 360, 0.1, "degrees") var max_angle: float = 360

@export var min_player_relative_position: Vector2
@export var max_player_relative_position: Vector2

@export_range(0, 1) var direction_change_damping: float = 0

var old_direction: Vector2
var new_direction: Vector2
var direction: Vector2
var remaining_time: float = 0
var initial_remaining_time: float = 0

func _run() -> void:
	character.velocity = direction * speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if remaining_time > 0:
		remaining_time -= delta
		direction = _calculate_interpolated_direction()
		direction = _clamp_direction(direction)
		return
	
	initial_remaining_time = randf_range(min_direction_change_time, max_direction_change_time)
	remaining_time = initial_remaining_time
	
	old_direction = new_direction
	new_direction = _calculate_new_direction()
	
func _calculate_new_direction() -> Vector2:
	var lower_angle = min_angle
	var upper_angle = max_angle
	
	if lower_angle > upper_angle:
		lower_angle = max_angle
		upper_angle = min_angle + 360
	
	var angle: float = randf_range(lower_angle, upper_angle)
	angle = fmod(angle, 360)
	
	var x = cos(deg_to_rad(angle))
	var y = -sin(deg_to_rad(angle))
	
	return Vector2(x, y)

func _calculate_interpolated_direction() -> Vector2:
	if direction_change_damping == 0:
		return new_direction
	
	var percentage_through_duration: float = (initial_remaining_time - remaining_time) / initial_remaining_time
	var lerp_amount = clamp(percentage_through_duration / direction_change_damping, 0, 1)
	var lerped_direction = lerp(old_direction, new_direction, lerp_amount)
	
	return lerped_direction

func _clamp_direction(curretn_direction: Vector2) -> Vector2:
	if min_player_relative_position == Vector2.ZERO && max_player_relative_position == Vector2.ZERO:
		return curretn_direction
	
	var clamp_percent: float = 0.5
	
	var inner_x_bounds = Vector2(min_player_relative_position.x + (max_player_relative_position.x - min_player_relative_position.x) * (clamp_percent / 2),
								max_player_relative_position.x - (max_player_relative_position.x - min_player_relative_position.x) * (clamp_percent / 2))
	
	var inner_y_bounds = Vector2(min_player_relative_position.y + (max_player_relative_position.y - min_player_relative_position.y) * (clamp_percent / 2),
								max_player_relative_position.y - (max_player_relative_position.y - min_player_relative_position.y) * (clamp_percent / 2))
	
	var desired_x_direction: float = 0
	var desired_y_direction: float = 0
	
	if _player_relative_position().x > max_player_relative_position.x:
		desired_x_direction = 1
	elif _player_relative_position().x < min_player_relative_position.x:
		desired_x_direction = -1
	elif _player_relative_position().x < inner_x_bounds.x:
		desired_x_direction = -(inner_x_bounds.x - _player_relative_position().x) / (inner_x_bounds.x - min_player_relative_position.x)
	elif _player_relative_position().x > inner_x_bounds.y:
		desired_x_direction = (_player_relative_position().x - inner_x_bounds.y) / (max_player_relative_position.x - inner_x_bounds.y)
	
	if _player_relative_position().y > max_player_relative_position.y:
		desired_y_direction = 1
	elif _player_relative_position().y < min_player_relative_position.y:
		desired_y_direction = -1
	elif _player_relative_position().y < inner_y_bounds.x:
		desired_y_direction = -(inner_y_bounds.x - _player_relative_position().y) / (inner_y_bounds.x - min_player_relative_position.y)
	elif _player_relative_position().y > inner_y_bounds.y:
		desired_y_direction = (_player_relative_position().y - inner_y_bounds.y) / (max_player_relative_position.y - inner_y_bounds.y)
	
	
	curretn_direction.x = lerp(-1.0, curretn_direction.x, clamp(desired_x_direction + 1.0, 0.0, 1.0))
	curretn_direction.x = lerp(curretn_direction.x, 1.0, clamp(desired_x_direction, 0.0, 1.0))
	
	curretn_direction.y = lerp(-1.0, curretn_direction.y, clamp(desired_y_direction + 1.0, 0.0, 1.0))
	curretn_direction.y = lerp(curretn_direction.y, 1.0, clamp(desired_y_direction, 0.0, 1.0))
	
	return curretn_direction
