extends Control

func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

#func _on_music_slider_value_changed(value: float) -> void:
	#AudioServer.set_bus_volume_db(0, value)

func _on_mute_button_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


func _on_resolutions_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))
			


func _on_fullscreen_checkbox_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		$MarginContainer/VBoxContainer/TabContainer/Video/Resolutions.disabled = true  
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$MarginContainer/VBoxContainer/TabContainer/Video/Resolutions.disabled = false 


var input_actions = {
	"move_left" : "Left",
	"move_right": "Right",
	"move_down" : "Down",
	"move_up" : "Jump",
	#"interact": "Interact",
	"Attack": "Attack",
	"dash" : "Dash"
}
