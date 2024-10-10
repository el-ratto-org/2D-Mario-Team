extends Node2D

# Preloaded scenes
var animated_sprite_scene = preload("res://assets/fx/dust_fx.tscn")

# Sprite variables
var anim_type = ["slide_fx_1", "slide_fx_2", "slide_fx_3", "slide_fx_4"]
var sprite_flip = false
var slide_timer_completed = true


func _process(delta: float) -> void:
	if start_slide_timer_condition_met():
		$SlideDustTimer.start()


func spawn_vfx(animation_name, position):
	if owner.velocity.x < -100:
		sprite_flip = true
	else:
		sprite_flip = false
	var new_sprite = animated_sprite_scene.instantiate() as AnimatedSprite2D
	var random_range = 5.0
	var random_float = randf_range(-random_range, random_range)
	var new_position = Vector2(position.x, position.y + random_float)
	
	print()
	print(new_position)
	print(position)
	print()
	new_sprite.global_position = new_position
	new_sprite.animation = animation_name.pick_random()
	new_sprite.play()
	new_sprite.flip_h = sprite_flip
	get_tree().root.add_child(new_sprite)


func start_slide_timer_condition_met():
	return  $SlideDustTimer.time_left == 0 and \
			owner.slide.is_sliding()


func _on_slide_dust_timer_timeout() -> void:
	slide_timer_completed = true
	spawn_vfx(anim_type, global_position)
