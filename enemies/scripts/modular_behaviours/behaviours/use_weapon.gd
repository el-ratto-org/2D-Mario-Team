extends EnemyBehaviour
class_name UseWeapon

@export var weapon: HitBox

func _run() -> void:
	weapon._trigger_attack()
