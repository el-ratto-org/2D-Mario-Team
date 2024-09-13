extends Node2D

@export var door_code: String = "aqua"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var door_code = "aqua"
	var used = false
	
	var pickup_area = $Pickup_area


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
# This function is called when another body enters the pickup area
func _on_pickup_area_area_entered(body: Node) -> void:
	pick_up_key(body)

# Function to handle key pickup logic
func pick_up_key(body: Node) -> void:
	var player = body.get_owner()
	print("=-=--=-=-=-=-=-=-=-=-=-= Key picked up!")
	player.add_key(door_code)
	queue_free()  # Remove the key after it's picked up
	
