extends CharacterBody2D

@onready var health = $Health


func _on_health_changed(_delta: float) -> void:
	# Did this kill us?
	if health.current <= 0:
		queue_free()
