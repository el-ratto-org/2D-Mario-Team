extends Node


var player
var player_position

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
