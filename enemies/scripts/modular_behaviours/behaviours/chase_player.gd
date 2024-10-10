extends EnemyBehaviour
class_name ChasePlayerBehaviour

@export var speed: float = 150

func _run() -> void:
	character.velocity.x = _player_horizontal_direction() * speed
