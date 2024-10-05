extends StaticBody2D

@export var door_code: String = "aqua"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var open = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func try_open_door(key_code: String):
	if key_code == door_code:
		_open_door()
	else:
		pass
		
func _open_door():
	print("door opened:", door_code)
	queue_free() # temp open

func _on_unlock_area_area_entered(area: Area2D) -> void:
	print("Door unlock try")
	assert(area.get_owner().get("inventory") != null, "Player has no inventory")

	#var player = area.get_owner()
	#var inventory = area.get_owner().get("inventory")
	#var keys = inventory.get_key_list()
	for key in area.get_owner().get("inventory").get_key_list():
		if key == door_code:
			_open_door()
	
