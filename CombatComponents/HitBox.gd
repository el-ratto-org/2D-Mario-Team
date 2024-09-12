extends Area2D
class_name HitBox

signal deal_damage

@export var damage:float = 1
@export var damage_type: DamageType

enum DamageType {
	Enemy,
	Player,
	EnemyAndPlayer
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(6, true)
	set_collision_mask_value(5, true)
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Hit something
func _on_area_entered(area: Area2D) -> void:
	print(get_parent().name)
	print("Hit something")
	if area is not HurtBox:
		return

	var hurt_box = area as HurtBox
	if hurt_box.damage_from != damage_type:
		if (hurt_box.damage_from != DamageType.EnemyAndPlayer) && (damage_type != DamageType.EnemyAndPlayer):
			return

	if damage > 0:
		emit_signal("deal_damage")
		print("Damage dealt: ")
		print(damage)
