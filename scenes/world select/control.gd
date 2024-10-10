extends Control

func _on__pressed() -> void:
	var world = WorldManager.selected_level
	if world:
		get_tree().change_scene_to_file(WorldManager.worlds[world]["path"])
		
