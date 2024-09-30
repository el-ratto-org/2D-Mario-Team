extends Node


var player
var player_position
var caption_manager
var player_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_player_position(position: Vector2) -> void:
	player_position = position

func _get_player_position() -> Vector2:
	return player_position
	
func play_caption(caption: String) -> void:
	if caption == 'death':
		caption_manager.death()
	
func get_hp() -> int:
	print ("get_hp is a stub!!!")
	return -999
