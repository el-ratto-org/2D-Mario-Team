extends Camera2D

@export var target: Node2D
@export_range(0, 100, 0.1, "suffix:%") var smoothing: float = 0

func _process(delta: float) -> void:
	global_position = lerp(global_position, target.global_position, 1.0 - (smoothing / 100.0))
