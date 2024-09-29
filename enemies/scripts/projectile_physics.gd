extends RigidBody2D
class_name Projectile

@export var projectile_speed: float = 800
@export var gravity: float = 800
@export var min_height: float = 100

var projectile: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = get_parent()
	while node is not CharacterBody2D:
		if node == get_tree().root:
			printerr("Error: Gravity nod not child of CharacterBody2D")
			return
		node = node.get_parent()
	projectile = node as CharacterBody2D


func _set_destination(destination: Vector2) -> void:
	# calculate launch angle and other variables
	var x_difference = abs(projectile.position.x - destination.x)
	var y_difference = abs(projectile.position.y - destination.y)
	var travel_time = sqrt(2*y_difference/gravity) + sqrt(2*min_height/gravity)
	var rad_angle = acos(x_difference / (travel_time * projectile_speed))
	var launch_direction = Vector2(cos(rad_angle), sin(rad_angle))
	var launch_velocity = launch_direction * projectile_speed
	
	# launch
	_launch_with_velocity(launch_velocity)

func _launch_with_velocity(velocity: Vector2) -> void:
	projectile.velocity = velocity


func _physics_process(delta: float) -> void:
	projectile.velocity.y = projectile.velocity.y + gravity * delta
	projectile.move_and_slide()
