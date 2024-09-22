extends EnemyBehaviour
class_name RunFromPlayerBehaviour

@export var speed: float = 100

func _run() -> void:
	character.velocity.x = -_player_horizontal_direction() * speed
