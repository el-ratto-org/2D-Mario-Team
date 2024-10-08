extends Node2D

signal landed

# Preloaded scenes
var animated_sprite_scene = preload("res://assets/fx/dust_fx.tscn")

# Sprite variables
var anim_type = "jump_straight"
var sprite_flip = false

# Timer variables
var timer_between_step_completed = false # This is used to check if this FX manager is allowed to place a step
var air_timer_completed = false

# Player stats
var recent_ground_location = Vector2(0,0)

func _process(delta: float) -> void:
	if step_conditions_met():
		step_dust()
	
	if landing_conditions_met():
		landing_dust()
	
	if start_falling_timer_condition_met():
		$FallingTimer.start()

func step_conditions_met():
	return  owner.velocity.x != 0 and \
			timer_between_step_completed and \
			owner.is_on_floor()

func landing_conditions_met():
	return  owner.velocity.y == 0 and \
			air_timer_completed and \
			owner.is_on_floor()

func step_dust():
	timer_between_step_completed = false
	spawn_vfx("step", global_position, sprite_flip)
	$StepDustTimer.start()

func landing_dust():
	air_timer_completed = false
	spawn_vfx("landing_fx", global_position, sprite_flip)
	landed.emit()

func start_falling_timer_condition_met():
	return  $FallingTimer.time_left == 0 and \
			not air_timer_completed and \
			not owner.is_on_floor()

func spawn_vfx(animation_name, position, flipped:bool):
	var new_sprite = animated_sprite_scene.instantiate() as AnimatedSprite2D
	new_sprite.global_position = position
	new_sprite.animation = animation_name
	new_sprite.play()
	new_sprite.flip_h = flipped
	get_tree().root.add_child(new_sprite)


func _on_step_dust_timer_timeout():
	timer_between_step_completed = true


func _on_falling_timer_timeout() -> void:
	air_timer_completed = true


func _on_jump_jumped() -> void:
	var player_x_velocity = owner.velocity.x
	
	# Figure out which animation to play
	if not owner.is_on_floor():
		anim_type = "jump_air"
	else:
		if player_x_velocity < 100 and player_x_velocity > -100:
			anim_type = "jump_straight"
		else:
			anim_type = "jump_angle"
	
	# Check if player sprite should be flipped
	if owner.velocity.x > 100:
		sprite_flip = true
	else:
		sprite_flip = false
	
	spawn_vfx(anim_type, global_position, sprite_flip)
