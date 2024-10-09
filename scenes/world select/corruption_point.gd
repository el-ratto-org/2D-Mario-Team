extends Node2D

@onready var vhs = %vhs


# This variable will hold the distance value from 0 to 1
var mouse_ratio: float = 0.0

# The maximum distance from which the value will be calculated
var max_distance: float = 700.0

# Exponential factor for sensitivity
var exponential_factor: float = 5.0  # Adjust this value to change sensitivity

# List of dictionaries for shader parameters
var PARAMETERS = [
	{
		"parameter_name": "samples",
		"default_value": 2.0,
		"max_value": 8.0
	},
	{
		"parameter_name": "crease_noise",
		"default_value": 1.0,
		"max_value": 2.0
	},
	{
		"parameter_name": "crease_opacity",
		"default_value": 0.5,
		"max_value": 1.0
	},
	{
		"parameter_name": "filter_intensity",
		"default_value": 0.1,
		"max_value": 0.2
	},
	{
		"parameter_name": "tape_crease_smear",
		"default_value": 0.2,
		"max_value": 2.0
	},
	{
		"parameter_name": "tape_crease_intensity",
		"default_value": 0.2,
		"max_value": 1.0
	},
	{
		"parameter_name": "tape_crease_jitter",
		"default_value": 0.10,
		"max_value": 1.0
	},
	{
		"parameter_name": "tape_crease_speed",
		"default_value": 0.5,
		"max_value": 2.0
	},
	{
		"parameter_name": "tape_crease_discoloration",
		"default_value": 1.0,
		"max_value": 2.0
	},
	{
		"parameter_name": "bottom_border_thickness",
		"default_value": 6.0,
		"max_value": 32.0
	},
	{
		"parameter_name": "bottom_border_jitter",
		"default_value": 6.0,
		"max_value": 24.0
	},
	{
		"parameter_name": "noise_intensity",
		"default_value": 0.1,
		"max_value": 0.8
	},
]

@export var MAX_VOLUME = 1.0
var regular_static_player
var corrupt_static_player
@onready var regular_static = load("res://assets/ambience/vhs_static.ogg")
@onready var corrupt_static = load("res://assets/ambience/ganzfeld_short.ogg")

func _ready():
	
	regular_static_player = self.get_child(0)
	corrupt_static_player = self.get_child(1)

	regular_static_player.volume_db = 0
	corrupt_static_player.volume_db = 0
	
	# Start both white noise sources
	regular_static_player.play()
	corrupt_static_player.play()

func play_static(proportion: float):
	# Clamp the proportion to be between 0.0 and 1.0
	proportion = clamp(proportion, 0.0, 1.0)

	# Calculate volumes for both sources based on the proportion
	var volume_1 = MAX_VOLUME * (1.0 - proportion)  # Volume for sound 1
	var volume_2 = MAX_VOLUME * proportion           # Volume for sound 2

	# Set volumes in decibels
	regular_static_player.volume_db = min(linear2db(volume_1), 0.5)
	corrupt_static_player.volume_db = linear2db(volume_2)
	
func linear2db(linear_volume: float) -> float:
	return 20 * log(linear_volume) / log(10) if linear_volume > 0 else -80  # Handle zero volume case

func _process(delta: float) -> void:
	# Get the current mouse position
	var mouse_position = get_global_mouse_position()
	
	# Calculate the distance between the mouse and this node
	var distance = global_position.distance_to(mouse_position)
	
	# Clamp the distance to be within the maximum distance
	distance = clamp(distance, 0, max_distance)
	
	# Update mouse_dist using the custom function
	mouse_ratio = calculate_mouse_distance_sine(distance)

	play_static(1-mouse_ratio)

	#var scaled_mouse_ratio = scale_value_to_range(mouse_ratio) #old, part of for loop
		#vhs.material.set_shader_parameter("noise_intensity", scaled_mouse_ratio) # ""
	
	for parameter in PARAMETERS:
		var parameter_intensity = scale_value_to_range(mouse_ratio, parameter["default_value"], parameter["max_value"])
		vhs.material.set_shader_parameter(parameter["parameter_name"], parameter_intensity)
	
	# Optional: Debug output
	print("mouse ratios: ", mouse_ratio)

# Function to scale a value from [0.0, 1.0] to a new range [min_value, max_value]
func scale_value_to_range(normalized_value: float, max_value: float, min_value: float) -> float: # max and min are mixed up ⨘⨒⨠⨪
	return min_value + normalized_value * (max_value - min_value)

# Wacky calculations 🐈
func calculate_mouse_distance_pow(distance: float) -> float:
	return 1.0 - pow(distance / max_distance, exponential_factor)

func calculate_mouse_distance_sine(distance: float) -> float:
	# Normalize the distance
	var normalized_distance = distance / max_distance
	# Use sine to create oscillation; scale and clamp to [0, 1]
	return clamp(0.5 + 0.5 * sin(normalized_distance * PI - (PI / 2)), 0.0, 1.0)

func calculate_mouse_distance_quadratic(distance: float) -> float:
	# Normalize the distance
	var normalized_distance = distance / max_distance
	# Calculate a quadratic drop-off
	return 1.0 - pow(normalized_distance, 2)
	
func calculate_mouse_distance_logarithmic(distance: float) -> float:
	# Normalize the distance
	var normalized_distance = distance / max_distance
	# Calculate logarithmic influence
	if normalized_distance == 0:
		return 1.0  # Prevent log(0)
	return clamp(1.0 - log(normalized_distance) / log(1.0), 0.0, 1.0)
	
func calculate_mouse_distance_cubic(distance: float) -> float:
	# Normalize the distance
	var normalized_distance = distance / max_distance
	# Calculate cubic influence
	return 1.0 - pow(normalized_distance, 3)
	
func calculate_mouse_distance_exponential(distance: float) -> float:
	# Normalize the distance
	var normalized_distance = distance / max_distance
	# Calculate exponential decay
	return clamp(1.0 * exp(-exponential_factor * normalized_distance), 0.0, 1.0)
