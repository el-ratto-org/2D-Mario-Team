extends Node

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
		var audio_stream = load(sound_path)  # Load the sound file
		if audio_stream:
			audio_player.stream = audio_stream
			audio_player.play()  # Play the sound
			print("Now playing: " + sounds[sound_name])
		else:
			print("Failed to load sound file for: " + sound_name)
	else:
		print("No sound found for: " + sound_name)

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
	print("Volume set to: " + str(volume_db) + " dB")
