extends Button

# Path to the new level/scene
@export var scene_to_load = "res://scenes/worlds/world_1/game.tscn"

func _on_pressed() -> void:
	# Check if the scene exists before loading
	if ResourceLoader.exists(scene_to_load):
		# Correct method for changing scenes
		get_tree().change_scene_to_file(scene_to_load)
	else:
		printerr("Error: Scene not found at: ", scene_to_load)


func _on_button_2_pressed() -> void:
	get_tree().quit()
