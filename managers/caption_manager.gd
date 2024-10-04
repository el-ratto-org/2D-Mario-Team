extends Node

@onready var fade_rect = $background 
@onready var death_rect = $death 
@onready var lantern_rect = $lantern 
@onready var audio_player = $AudioStreamPlayer2D
@onready var timer = $Timer  # Ensure this matches your Timer node name
@onready var death_caption = $death/YouFailed
@onready var feather_rect = $item_feather

var fading_bg: bool = false  # Flag to check if we are fading_bg
var fade_duration: float = 1.0  # Duration of the fade
var pause_time: float = 0.0 # Time elapsed in the fade pause
var fade_time: float = 0.0  # Time elapsed in the fade

# Dictionary to track fade targets and their properties
var fade_targets: Dictionary = {}

var death_snd = "res://assets/sfx/death_sound.mp3"
var lantern_snd = "res://assets/sfx/BB_item_get.mp3"
var item_snd = "res://assets/sfx/BOTW_item_get.mp3"
var item_snd_feather = "res://assets/sfx/item_get_feather.ogg"

func wait(seconds: float) -> void:
	OS.delay_msec(seconds * 1000)


# Process function to handle the fade effects
func _process(delta: float) -> void:
	for target in fade_targets.keys():
		if fade_targets[target]["fading"]:
			if fade_targets[target]["wait_time"] >= 0:
				fade_targets[target]["wait_time"] += -delta
			else:
				fade_targets[target]["fade_time"] += delta  # Increment elapsed time by delta
				var progress = fade_targets[target]["fade_time"] / fade_targets[target]["fade_duration"]  # Calculate the progress of the fade
				var start_alpha = fade_targets[target]["start_alpha"]
				var final_alpha = fade_targets[target]["final_alpha"]
				
				# Interpolate the alpha from start_alpha to final_alpha
				var alpha = lerp(start_alpha, final_alpha, clamp(progress, 0.0, 1.0))
				target.modulate.a = alpha  # Update only the alpha value (keeping original color)

			# Check if the fade is complete
			if fade_targets[target]["fade_time"] >= fade_targets[target]["fade_duration"]:
				#fade_targets[target]["fading"] = false  # Stop fading
				if fade_targets[target]["complete_fade_signal_on_finish"]:
					if fade_targets[target]["tail_wait"] >= 0:
						fade_targets[target]["tail_wait"] += -delta
					else:
						fade_targets[target]["complete_fade_signal_on_finish"] = false
						_on_fade_complete(target)  # Call the completion function for this target
						
	#if Input.is_action_just_pressed("debug"):
	#	feather()

# Function to start the fade for a specific target and color
func fade_to_color(target: ColorRect, start_alpha: float, final_alpha: float, duration: float, wait_duration: float,fade_to_clear_on_finish: bool, tail_wait: float) -> void:
	fade_targets[target] = {
		"fading": true,  # Set the fading flag
		"fade_duration": duration,  # Set the fade duration
		"fade_time": 0.0,  # Reset elapsed time
		"wait_duration": wait_duration, #useless?
		"wait_time": wait_duration,
		"start_alpha": start_alpha,  # Initial alpha value
		"final_alpha": final_alpha,  # Set the target color (black or white)
		"complete_fade_signal_on_finish": fade_to_clear_on_finish,
		"tail_wait": tail_wait
	}
	target.modulate.a = 0.0 if final_alpha > 0 else 1.0  # Start with fully transparent or fully opaque based on fade direction
	target.visible = true  # Make sure the ColorRect is visible

# Function to start the fade for a specific target
func fade_to_transparent(target: ColorRect, duration: float, wait_duration: float, tail_wait: float) -> void:
	fade_to_color(target, 1.0, 0.0,duration, wait_duration, false, tail_wait)

# Function to start the fade for a specific target
func fade_to_opaque(target: ColorRect, duration: float, wait_duration: float, tail_wait: float) -> void:
	fade_to_color(target, 0.0, 1.0, duration, wait_duration, true, tail_wait)  # Pass white color
	
# Function to handle what happens after the fade is complete for a specific target
func _on_fade_complete(target: ColorRect) -> void:
	fade_to_transparent(target, 1, 0, 0)
	

func death():
	var audio_stream = load(death_snd)
	audio_player.stream = audio_stream
	audio_player.play()
	
	fade_to_opaque(fade_rect, 2.0, 1.0, 3)
	fade_to_opaque(death_rect, 1, 0.0, 2.5)
	
func lit():
	var audio_stream = load(lantern_snd)
	audio_player.stream = audio_stream
	audio_player.play()
	
	
	fade_to_opaque(lantern_rect, 2, 1, 0)
	
func feather():
	var audio_stream = load(item_snd_feather)
	audio_player.stream = audio_stream

	audio_player.play()
	
	fade_to_opaque(feather_rect, 0.4, 0.7, 3)
	
func cloak():
	print ("no cloak code so playing the feather stuff 🎍")
	var audio_stream = load(item_snd_feather)
	audio_player.stream = audio_stream

	audio_player.play()
	
	fade_to_opaque(feather_rect, 0.4, 0.7, 3)
	
	
func _ready() -> void:
	PlayerStatsManager.caption_manager = self
	
func _physics_process(delta: float) -> void:
	pass
