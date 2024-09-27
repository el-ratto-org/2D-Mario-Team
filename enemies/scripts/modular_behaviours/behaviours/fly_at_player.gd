extends EnemyBehaviour
class_name FlyAtPlayer

@export var speed: float = 100

func _run() -> void:
	character.velocity = _player_direction() * speed
