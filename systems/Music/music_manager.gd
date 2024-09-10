extends Node

# A dictionary to map stage names to their respective audio files.
var stage_music = {
	"stage1": "res://content/music/Schlatts_Basement.mp3",
	#"stage2": "res://music/stage2.ogg",
	#"stage3": "res://music/stage3.ogg"
}

# Reference to the AudioStreamPlayer node
@onready var audio_player = $AudioStreamPlayer2D

# Function to play music based on the stage name
func play_stage_music(stage_name: String) -> void:
	if stage_name in stage_music:
		var music_path = stage_music[stage_name]
		var audio_stream = load(music_path)  # Load the music file
		if audio_stream:
			audio_player.stream = audio_stream
			audio_player.play()  # Play the music
			print("Now playing: " + stage_name)
		else:
			print("Failed to load music file for: " + stage_name)
	else:
		print("No music found for: " + stage_name)

# Function to stop the music
func stop_music() -> void:
	audio_player.stop()
