extends Control


var video_file_path = "res://assets/captions/2024-10-11 20-04-09_1.mp4"
var user_video_path = "user://my_video.mp4"


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
	var msg = ("EAS EMERGENCY ALERT FOR USER(ADMIN) "+user)
	OS.alert(msg)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)
	open_video(video_file_path)


func copy_video_to_user_path():
	var file = FileAccess.open(video_file_path, FileAccess.READ)
	if file:
		var user_file = FileAccess.open(user_video_path, FileAccess.WRITE)
		if user_file:
			user_file.store_buffer(file.get_buffer(file.get_len()))
			user_file.close()
		file.close()
	else:
		print("Failed to open the video file at: ", video_file_path)

func open_video(video_path: String) -> void:
	# Open the video in the default video player
	if FileAccess.file_exists(video_path):
		OS.shell_open(video_path)
	else:
		print("File does not exist: ", video_path)
