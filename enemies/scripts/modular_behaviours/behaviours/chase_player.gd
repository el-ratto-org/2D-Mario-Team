extends EnemyBehaviour
class_name ChasePlayerBehaviour

@export var speed: float = 100

func _run() -> void:
	character.velocity.x = _player_horizontal_direction() * speed
	character.move_and_slide()
