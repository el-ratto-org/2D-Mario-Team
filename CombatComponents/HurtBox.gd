extends Area2D
class_name HurtBox

@export var health_component: HealthComponent
@export var damage_from: HitBox.DamageType = HitBox.DamageType.Player
@export var head_hurtbox = false

enum AttackType { # Ensure this is updated to be the same in hitbox script
	Melee,
	Projectile,
	Jumping,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_collision_layer_value(5, true)
	set_collision_mask_value(6, true)
	connect("area_entered", _on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Got hit by something
func _on_area_entered(area: Area2D) -> void:
	_detect_hit(area)


func _detect_hit(area: Area2D) -> void:
	if area is not HitBox:
		return
	
	var hit_box = area as HitBox
	
	if !hit_box.is_active:
		return
	
	if hit_box.damage_type != damage_from:
		if (hit_box.damage_type != HitBox.DamageType.EnemyAndPlayer) && (damage_from != HitBox.DamageType.EnemyAndPlayer):
			return
	
	if hit_box.damage > 0:
		if health_component != null:
			health_component._take_damage(hit_box.damage)
			#print(get_parent().name, " was hit by (possibly during iframe): ", hit_box.get_parent().name)
			# bounce the entity upwards if it's a head jump and has method
			var entity = hit_box.get_owner()
			if head_hurtbox and area.attack_type == AttackType.Jumping:
				#if entity.has_method("player_bounced"):
				entity.player_bounced()
