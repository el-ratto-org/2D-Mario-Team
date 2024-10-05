extends Node2D

@onready var wing_fx_ray : RayCast2D = $WingFXRay

# Height of wing_fx
@export var wing_fx_offset = -10


# Preloaded scenes
var animated_sprite_scene = preload("res://assets/fx/dust_fx_fog.tscn")

# Inherited variables
var wing_fx_allowed = false
var flipped = false


func spawn_vfx(animation_name, position, flipped:bool, height_difference):
	#await get_tree().create_timer(height_difference/1000).timeout
	#var opacity_value = 1 - height_difference/10
	#opacity_value = clamp(opacity_value, 0.1, 1.0)
	#print(opacity_value)
	var new_sprite = animated_sprite_scene.instantiate() as AnimatedSprite2D
	#new_sprite.modulate.a = opacity_value
	new_sprite.global_position = position
	new_sprite.animation = animation_name
	new_sprite.play()
	
	new_sprite.flip_h = flipped
	#add_child(new_sprite)
	#print(new_sprite.animation)
	get_tree().root.add_child(new_sprite)

func _on_wing_flap_timer_timeout() -> void:
	if wing_fx_allowed == false:
		return
	$WingFlapTimer.start()
	if true:
		# gather player and ray info
		var player_x = owner.velocity.x
		var player_y = owner.velocity.y
		var ray_cast_point = wing_fx_ray.get_collision_point()
		
		# Project the fx forward based on player movement
		player_x = player_x / 10
		var height_difference = player_y - ray_cast_point.y
		
		# calc wing flap fx loc
		var fx_location = ray_cast_point + Vector2(0 + player_x, wing_fx_offset)
		
		
		spawn_vfx("wing_flap", fx_location, flipped, height_difference)
	pass # Replace with function body.


func _on_wings_wing_fx(in_light: bool) -> void:
	print("Set to "+str(in_light))
	wing_fx_allowed = in_light
	$WingFlapTimer.start()


func _on_animated_sprite_2d_flip_sprite(flip: bool) -> void:
	flipped = flip
