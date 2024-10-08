extends Node

# A dictionary to map stage names to their respective audio files.
var stage_music = {
	"stage1": "res://content/music/Schlatts_Basement.mp3",
	"stage2": "res://content/music/Geneburn (Hard asf (copyrighted))/The_Blood_We_Spill.mp3",
	#"stage3": "res://music/stage3.ogg"
}

var sounds = {
	"jumped_on": "res://content/sfx/kick-heavy.ogg",
	"player_death": "res://content/sfx/bloodborne-death.mp3",
}

# Reference to the AudioStreamPlayer node
@onready var audio_player = $AudioStreamPlayer2D

# play sfx
func play_sound(sound_name: String) -> void:
	if sound_name in sounds:
		var sound_path = sounds[sound_name]
		var audio_stream = load(sound_path) # Load the sound file
		if audio_stream:
			audio_player.stream = audio_stream
			audio_player.play() # Play the sound
		else:
			printerr("Failed to load sound file for: " + sound_name)
	else:
		printerr("No sound found for: " + sound_name)

# Function to play music based on the stage name
func play_stage_music(stage_name: String) -> void:
	if stage_name in stage_music:
		var music_path = stage_music[stage_name]
		var audio_stream = load(music_path)  # Load the music file
		if audio_stream:
			audio_player.stream = audio_stream
			audio_player.play()  # Play the music
		else:
			printerr("Failed to load music file for: " + stage_name)
	else:
		printerr("No music found for: " + stage_name)

# Function to stop the music
func stop_music() -> void:
	audio_player.stop()


# Function to pause the music
func pause_music() -> void:
	if audio_player.playing:
		audio_player.pause()
	else:
		printerr("Music is not currently playing")


# Function to resume the paused music
func resume_music() -> void:
	if !audio_player.playing and audio_player.stream:
		audio_player.play()


func set_volume(volume_db: float) -> void:
	#Sets the volume of the current music playback.
#
	#Parameters:
	#volume_db (float): Volume in decibels (dB).
					   #- 0 dB is the default volume.
					   #- Negative values reduce the volume.
					   #- Values below -80 dB mute the sound
	#Examples:
	#set_volume(0)    # Full volume
	#set_volume(-10)  # Reduced volume
	#set_volume(-80)  # Mute
	audio_player.volume_db = volume_db
