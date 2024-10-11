extends RigidBody2D
class_name Projectile

@export var lifetime: float = 5
@export var face_movement_direction: bool = true
@export var drop_particles_on_destroy: bool = false

# set from other scripts
var max_speed: float
var destination: Vector2
var min_height: float
var launch_when_ready = false

# internal variables
var ready_to_launch = false
var reset_state = false
var starting_position: Vector2

var gravity: float


func _ready() -> void:
	gravity = gravity_scale * ProjectSettings.get_setting("physics/2d/default_gravity")
	if !contact_monitor && max_contacts_reported <= 0:
		contact_monitor = true
		max_contacts_reported = 1

func _set_start_position(position: Vector2) -> void:
	# Reset
	starting_position = position
	reset_state = true


func _begin_launch() -> void:
	# Check for zero gravity
	if gravity == 0:
		var launch_velocity = (destination - global_position).normalized() * max_speed
		_launch_with_velocity(launch_velocity)
		return
	
	# Calculate launch angle and other variables
	var damp = max(linear_damp, ProjectSettings.get_setting("physics/2d/default_linear_damp"))
	var x_difference = abs(global_position.x - destination.x)
	var y_difference = abs(global_position.y - destination.y)
	var time_up = sqrt(-2 * min((destination.y - global_position.y) - min_height, -min_height) / gravity)
	var time_down = sqrt(-2 * min((global_position.y - destination.y) - min_height, -min_height) / gravity)
	var travel_time = time_up + time_down
	var desired_x_speed = (x_difference / travel_time) * sign(destination.x - global_position.x)
	var desired_y_speed = (gravity * time_up) * -1
	var launch_velocity = Vector2(desired_x_speed, desired_y_speed)
	
	# fix for lineaer damping
	var full_physics_steps = Engine.physics_ticks_per_second * travel_time
	var full_damped_velocity_percentage = pow(1 - ((damp * (x_difference / sqrt(pow(x_difference, 2) + pow((y_difference + min_height * 2), 2)))) / Engine.physics_ticks_per_second), full_physics_steps)
	launch_velocity.x = launch_velocity.x / full_damped_velocity_percentage
	
	# clamp to max speed
	launch_velocity = launch_velocity.normalized() * min(launch_velocity.length(), max_speed)
	
	# launch
	_launch_with_velocity(launch_velocity)


func _launch_with_velocity(launch_velocity: Vector2) -> void:
	linear_velocity = launch_velocity


func _physics_process(delta: float) -> void:
	if launch_when_ready && ready_to_launch:
		launch_when_ready = false
		ready_to_launch = false
		_begin_launch()
	
	# Die after life time
	lifetime -= delta
	if lifetime <= 0:
		queue_free()
	
	# Die on collision
	if get_colliding_bodies().size() > 0:
		_despawn()
	
	
	# Point in movement direction
	if face_movement_direction:
		look_at(global_position + linear_velocity.normalized())


func _integrate_forces(state):
	if global_position.distance_to(starting_position) < 10:
		reset_state = false
		ready_to_launch = true
	
	if reset_state:
		state.transform = Transform2D(0.0, starting_position)
		physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT


func _on_hit_box_deal_damage() -> void:
	_despawn()


func _despawn() -> void:
	# spawn any child particle systems
	if drop_particles_on_destroy:
		for child in get_children():
			if child is CPUParticles2D:
				var position = child.global_position
				remove_child(child)
				get_tree().current_scene.add_child(child)
				child.global_position = position
				child.emitting = true
				# trigger particles to despawn
				for despawner in child.get_children():
					if despawner is Despawner:
						despawner._start_timer()
	
	# Delete
	queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	_despawn()
