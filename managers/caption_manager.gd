extends Node

@onready var fade_rect = $background 
@onready var death_rect = $death 
@onready var lantern_rect = $lantern 
@onready var audio_player = $AudioStreamPlayer2D
@onready var timer = $Timer  # Ensure this matches your Timer node name
@onready var death_caption = $death/YouFailed

var fading_bg: bool = false  # Flag to check if we are fading_bg
var fade_duration: float = 1.0  # Duration of the fade
var pause_time: float = 0.0 # Time elapsed in the fade pause
var fade_time: float = 0.0  # Time elapsed in the fade

# Dictionary to track fade targets and their properties
var fade_targets: Dictionary = {}

var death_snd = "res://assets/sfx/death_sound.mp3"
var lantern_snd = "res://assets/sfx/BB_item_get.mp3"

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
				var alpha = fade_targets[target]["fade_time"] / fade_targets[target]["fade_duration"]  # Calculate the alpha value
				target.modulate.a = clamp(alpha, 0.0, 1.0)  # Update the alpha value and clamp between 0 and 1

			# Check if the fade is complete
			if fade_targets[target]["fade_time"] >= fade_targets[target]["fade_duration"]:
				fade_targets[target]["fading"] = false  # Stop fading
				_on_fade_complete(target)  # Call the completion function for this target

# Function to start the fade for a specific target
func fade_to_black(target: ColorRect, duration: float, wait_duration: float) -> void:
	fade_targets[target] = {
		"fading": true,  # Set the fading flag
		"fade_duration": duration,  # Set the fade duration
		"fade_time": 0.0,  # Reset elapsed time
		"wait_time": wait_duration 
	}
	target.modulate.a = 0.0  # Ensure starting alpha is 0 (fully transparent)
	target.visible = true  # Make sure the ColorRect is visible

# Function to start the fade for a specific target
func fade_to_white(target: ColorRect, duration: float, wait_duration: float) -> void:
	fade_targets[target] = {
		"fading": true,  # Set the fading flag
		"fade_duration": duration,  # Set the fade duration
		"fade_time": 0.0,  # Reset elapsed time
		"wait_time": wait_duration 
	}
	target.modulate.a = 1.0  # Ensure starting color is white (RGBA: 1, 1, 1, 1)
	target.visible = true  # Make sure the ColorRect is visible

# Function to handle what happens after the fade is complete for a specific target
func _on_fade_complete(target: ColorRect) -> void:
	#fade_to_white(target, 1.0, 0.0)
	pass

func death():
	var audio_stream = load(death_snd)
	audio_player.stream = audio_stream
	audio_player.play()
	
	fade_to_black(fade_rect, 2.0, 2.0)
	fade_to_black(death_rect, 1.5, 0.0)
	
	#fade_to_white(fade_rect, 1.0, 5.0)
	#fade_to_white(death_rect, 0.1)
	
func lit():
	var audio_stream = load(lantern_snd)
	audio_player.stream = audio_stream
	audio_player.play()
	
	
	fade_to_black(lantern_rect, 1.0, 1.0)
	
	wait(1)
	
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		lit()
