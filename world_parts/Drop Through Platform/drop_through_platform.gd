extends StaticBody2D

@onready var collision = $CollisionShape2D
@onready var area = $Area2D

var is_moving_down = false
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("move_down") and not is_moving_down:
			is_moving_down = true
			area.set_deferred("monitoring", true)
	elif event.is_action_released("move_down") and is_moving_down:
		is_moving_down = false
		area.set_deferred("monitoring", false)


func _on_area_2d_area_entered(area: Area2D) -> void:
	collision.set_deferred("disabled", true)


func _on_area_2d_area_exited(area: Area2D) -> void:
	collision.set_deferred("disabled", false)
	area.set_deferred("monitoring", false)
