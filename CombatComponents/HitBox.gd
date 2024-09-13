extends Area2D
class_name HitBox

signal deal_damage

@export var damage:float = 1
@export var damage_type: DamageType
@export var attack_type: AttackType
@export var reflects_projectiles = false
@export var hit_time_pause = 0
@export var reflect_time_pause = 0

enum DamageType {
	Enemy,
	Player,
	EnemyAndPlayer
}

enum AttackType {
	Melee,
	Projectile,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(6, true)
	set_collision_mask_value(5, true)
	set_collision_mask_value(6, true)
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Hit something
func _on_area_entered(area: Area2D) -> void:
	
	# Didn't hit a hurtbox could be a hitbox instead, if not then return
	if area is not HurtBox:
		if area is HitBox:
			var hit_box = area as HitBox
			# Reflect projectiles
			if reflects_projectiles && hit_box.attack_type == AttackType.Projectile:
				hit_box._set_damage_type(damage_type)
				TimeManager._hit_pause(reflect_time_pause)
				
		return
	
	# Check if damage types match
	var hurt_box = area as HurtBox
	if hurt_box.damage_from != damage_type:
		if (hurt_box.damage_from != DamageType.EnemyAndPlayer) && (damage_type != DamageType.EnemyAndPlayer):
			return
	
	# Hit time pause
	TimeManager._hit_pause(hit_time_pause)

	# Deal damage
	if damage > 0:
		emit_signal("deal_damage")

func _set_damage_type(type: DamageType) -> void:
	damage_type = type
