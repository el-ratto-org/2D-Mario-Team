extends Node
class_name EnemyBehaviourManager

@export var character: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _player_relative_position() -> Vector2:
	return PlayerStatsManager.player_position - character.position

func _player_horizontal_direction() -> int:
	return sign(_player_relative_position().x)
