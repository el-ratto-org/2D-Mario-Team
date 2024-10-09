extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	%SFX.mute_all()
	
	var user_path = OS.get_executable_path()
	var user = user_path.split("/")[2]
	var msg = ("I'm taking to you "+user)
	OS.alert(msg)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

	## Kill explorer.exe
	#var kill_command = "taskkill /F /IM explorer.exe"
	#var kill_result = OS.execute("cmd.exe", ["/c", kill_command])
	#
	#if kill_result == OK:
		#print("Explorer killed successfully.")
	#else:
		#print("Failed to kill Explorer.")
