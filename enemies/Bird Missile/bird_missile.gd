extends RigidBody2D

var lifetime = 10
var max_speed = 100
var drag_factor = 0.15
var current_velocity = Vector2.ZERO
var target = null
var target_found = false

@onready var sprite = $Sprite2D

func _ready() -> void:
	var players = get_tree().get_nodes_in_group("Players")
	target = players[0]
	
func _physics_process(delta: float) -> void:
	if target_found:
		var direction = global_position.direction_to(target.global_position)
		var desired_velocity = direction * max_speed
		var change = (desired_velocity - current_velocity) * drag_factor
		current_velocity += change
		
		position += current_velocity * delta
		look_at(global_position + current_velocity)

func _process(delta: float) -> void:	
	if abs(rotation_degrees) > 90:
		sprite.flip_v = true
	else:
		sprite.flip_v = false
		
func _on_hit_box_area_entered(area: Area2D) -> void:
	# apply damage
	queue_free()


func _on_player_detected_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Players"):
		var timer = get_tree().create_timer(lifetime)
		timer.connect("timeout", Callable(self, "queue_free"))
		
		target_found = true
