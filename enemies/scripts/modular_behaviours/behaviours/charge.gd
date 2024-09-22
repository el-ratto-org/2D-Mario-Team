extends EnemyBehaviour
class_name ChargeBehaviour

@export var speed: float = 100
@export var direction: Direction
var direction_value = -1

enum Direction{
	Left,
	Right,
}

func _run() -> void:
	if direction == Direction.Left:
		direction_value = -1
	elif direction == Direction.Right:
		direction_value = 1
	
	character.velocity.x = speed * direction_value
