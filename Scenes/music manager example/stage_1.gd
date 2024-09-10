extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var music_manager = $MusicManager  # Get the MusicManager node
	music_manager.play_stage_music("stage1")  # Play music for stage1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
