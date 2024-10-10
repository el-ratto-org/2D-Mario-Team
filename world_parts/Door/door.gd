extends StaticBody2D

@export var door_code: String = "aqua"

var open = false


func try_open_door(key_code: String):
	if key_code == door_code:
		_open_door()


# TODO: Change this to actually open the door properly
func _open_door():
	queue_free()


func _on_unlock_area_area_entered(area: Area2D) -> void:
	var player = area.owner
	assert(player != null, "Player has no inventory")
	assert(player.inventory != null, "Player has no inventory")

	for key in area.get_owner().inventory.keys:
		if key == door_code:
			_open_door()
	
