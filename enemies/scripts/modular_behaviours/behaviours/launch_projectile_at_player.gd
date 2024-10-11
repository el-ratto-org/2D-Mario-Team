@tool
extends EnemyBehaviour
class_name LaunchProjectileAtPlayer


@export var projectile: PackedScene
@export var max_speed: float = 1000
@export var min_height: float = 100
@export var direction: Vector2

var marker

func _enter_tree() -> void:
	_get_configuration_warnings()

func child_enter_tree() -> void:
	_get_configuration_warnings()

func child_exited_tree() -> void:
	_get_configuration_warnings()

func _get_configuration_warnings():
	var has_marker
	for child in get_children():
		if child is Marker2D:
			has_marker = true
	
	if !has_marker:
		return["Must have a child Marker2D node"]
	else:
		return []

func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			marker = child

func _run() -> void:
	if projectile:
		#assert(projectile.)
		
		var new_projectile = projectile.instantiate()
		get_tree().current_scene.add_child(new_projectile)

		var projectile_obj: Projectile = new_projectile.get_child(0).get_parent()

		projectile_obj.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
		
		var starting_position
		if marker:
			starting_position = marker.global_position


		projectile_obj.global_position = starting_position
		
		projectile_obj.max_speed = max_speed
		projectile_obj._set_start_position(starting_position)
		projectile_obj.destination = marker.global_position + direction.normalized()
		if direction == Vector2.ZERO:
			projectile_obj.destination = PlayerManager.player.global_position
		projectile_obj.min_height = min_height
		projectile_obj.launch_when_ready = true
		
		
