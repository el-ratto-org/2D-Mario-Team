extends EnemyBehaviour
class_name LaunchProjectileAtPlayer

#oad var projectile: Projectile
@export var speed: float = 100
#func _run() -> void:
	#var new_projectile = projectile.instance()
