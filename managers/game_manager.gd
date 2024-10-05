extends Node2D

var checkpoints = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_last_checkpoint(level: String):
	if checkpoints[level] != null:
		return checkpoints[level]
	else:
		return Vector2(0,0)
