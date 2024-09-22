extends Node2D

@onready var settings_menu = $Player/Settings
var paused = false

func pause_menu():
	if paused:
		settings_menu.hide()
		Engine.time_scale = 1
	else:
		settings_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		pause_menu()
		

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var music_manager = $MusicManager  # Get the MusicManager node
	#music_manager.play_stage_music("stage1")  # Play music for stage1
