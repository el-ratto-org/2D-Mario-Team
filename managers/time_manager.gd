extends Node

@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process_mode(Node.PROCESS_MODE_ALWAYS)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _hit_pause(duration: float) -> void:
	_set_pause_duration(duration)

func _set_pause_duration(duration: float) -> void:
	if duration > 0:
		_pause_game()
	timer.stop()
	timer.wait_time = max(timer.time_left, duration)
	timer.start()

func _pause_game() -> void:
	get_tree().paused = true

func _resume_game() -> void:
	get_tree().paused = false

func _on_timer_timeout() -> void:
	_resume_game()
