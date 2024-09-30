extends Node2D

@export var door_code: String = "aqua"

# Variables to control the bobbing motion
@export var amplitude: float = 4.0 # The height of the bobbing motion (how far it moves up and down)
@export var frequency: float = 0.2  # How fast the key bobs up and down

# Internal variable to track time
var time: float = 0.0
var start_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var door_code = door_code
	var used = false
	
	var start_position: Vector2 = position
	var pickup_area = $Pickup_area


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# Increase the time counter based on the frame time
	time += delta

	# Calculate the new Y position using a sine wave
	var bob_offset: float = sin(time * frequency * TAU) * amplitude

	# Apply the bobbing motion to the key's Y position
	position.y += bob_offset
		
# This function is called when another body enters the pickup area
func _on_pickup_area_area_entered(body: Node) -> void:
	pick_up_key(body)

# Function to handle key pickup logic
func pick_up_key(hitbox: Node) -> void:
	var body = hitbox.get_owner()
	if body.has_method("get_inventory"):
		print("=-=--=-=-=-=-=-=-=-=-=-= Key picked up!")
		var inventory = body.get_inventory()  # Call the method to get the inventory
		if inventory:
			inventory.add_key(door_code)  # Call the add_key method on the inventory
			queue_free()  # Remove the key from the scene
