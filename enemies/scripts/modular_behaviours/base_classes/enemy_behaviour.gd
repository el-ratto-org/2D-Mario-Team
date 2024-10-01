extends Node2D
class_name EnemyBehaviour

var character: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = get_parent()
	while node is not CharacterBody2D:
		if node == get_tree().root:
			printerr("Error: Enemy behaviour nod not child of CharacterBody2D")
			return
		node = node.get_parent()
	character = node as CharacterBody2D

func _run() -> void:
	pass

func _player_direction() -> Vector2:
	return (PlayerStatsManager.player_position - character.position).normalized()

func _player_relative_position() -> Vector2:
	return PlayerStatsManager.player_position - character.position

func _player_horizontal_direction() -> int:
	return sign(_player_direction().x)
