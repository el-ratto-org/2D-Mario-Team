extends Timer
class_name Despawner

@export var lifetime: float = 1
@export var start_on_ready: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("timeout", _despawn)
	if start_on_ready:
		_start_timer()

func _start_timer() -> void:
	wait_time = lifetime
	start()

func _despawn() -> void:
	get_parent().queue_free()
