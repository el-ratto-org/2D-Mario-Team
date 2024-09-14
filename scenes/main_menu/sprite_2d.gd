extends Sprite2D

# Parameters to control the shake effect
@export var shake_amplitude = 5.0   # How far the sprite moves during shake
@export var shake_speed = 0.2       # Speed of the shake (lower means slower shake)
@export var max_rotation_degrees = 0.5  # Maximum rotation in degrees

# To keep track of original position and rotation
var original_position: Vector2
var original_rotation: float

# Timer to control the shake progress
var shake_timer: float = 0.0

# Called when the node is added to the scene
func _ready():
	# Store the original position and rotation of the sprite
	original_position = position
	original_rotation = rotation

# Called every frame
func _process(delta):
	# Increment the timer by delta and multiply by shake speed
	shake_timer += delta * shake_speed

	# Calculate the new offset using a sine wave for smooth movement
	var offset_x = sin(shake_timer * TAU) * shake_amplitude
	var offset_y = cos(shake_timer * TAU) * shake_amplitude * 0.5  # Smaller vertical shake
	
	# Update the sprite's position with the shake effect
	position = original_position + Vector2(offset_x, offset_y)
	
	# Apply rotation shake: rotate ±max_rotation_degrees based on sine wave
	rotation = original_rotation + deg_to_rad(sin(shake_timer * TAU) * max_rotation_degrees)
