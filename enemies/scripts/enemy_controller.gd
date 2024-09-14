extends CharacterBody2D

func _on_health_component_die() -> void:
	queue_free()
 
