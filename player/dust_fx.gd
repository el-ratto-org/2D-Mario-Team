extends AnimatedSprite2D

# Preloaded scenes
var animated_sprite_scene = preload("res://scenes/fx/dust_fx.tscn")

# Sprite variables
var anim_type = "jump_straight"
var sprite_flip = false

# Timer variables
var timer_between_step_completed = false # This is used to check if this FX manager is allowed to place a step (
var air_timer_completed = false


func _process(delta: float) -> void:
	if step_conditions_met():
		dust_step("step")
	
	if landing_conditions_met():
		air_timer_completed = false
		spawn_vfx("landing_fx", self.global_position, sprite_flip)
	
	if start_falling_timer_condition_met():
		$FallingTimer.start()
	
	
func step_conditions_met():
	var player_x_velocity = $"../PlayerMovementController".character.velocity.x
	if player_x_velocity != 0 and timer_between_step_completed:
		if player_on_ground():
			return true
	return false
	
func landing_conditions_met():
	var player_y_velocity = $"../PlayerMovementController".character.velocity.y
	if player_y_velocity == 0 and air_timer_completed:
		if player_on_ground():
			return true
	return false	

func player_on_ground():
	var floored = $"../PlayerMovementController".grounded
	if floored:
			return true
	return false	
	
func start_falling_timer_condition_met():
	if not player_on_ground():
		if $"../DustFX/FallingTimer".time_left == 0 and air_timer_completed == false:
			return true
	return false

func dust_step(animation_name):
	timer_between_step_completed = false
	spawn_vfx(animation_name, self.global_position, sprite_flip)
	$StepDustTimer.start()
	
func spawn_vfx(animation_name, position, flipped:bool):
	var new_sprite = animated_sprite_scene.instantiate() as AnimatedSprite2D
	new_sprite.global_position = position
	new_sprite.animation = animation_name
	new_sprite.play()
	new_sprite.flip_h = flipped
	#add_child(new_sprite)
	#print(new_sprite.animation)
	get_tree().root.add_child(new_sprite)
		
	
	
	# Timers #
	
func _on_step_dust_timer_timeout():
	timer_between_step_completed = true
	pass # Replace with function body.

func _on_falling_timer_timeout() -> void:
	print("Falling timer out")
	air_timer_completed = true
	pass # Replace with function body.
	
	
	# Player Movement Script Signal Attachments #
	
func _on_player_movement_controller_player_jump() -> void:
	var player_x_velocity = $"../PlayerMovementController".character.velocity.x
	if player_x_velocity < 100 and player_x_velocity > -100:
		anim_type = "jump_straight"
	else:
		anim_type = "jump_angle"
	
	if $"../PlayerMovementController".character.velocity.x > 100:
		sprite_flip = true
	else:
		sprite_flip = false
	spawn_vfx(anim_type, self.global_position, sprite_flip)
	pass # Replace with function body.
	
	pass # Replace with function body.
