extends AnimatedSprite2D

var animated_sprite_scene = preload("res://scenes/fx/dust_fx.tscn")
var anim_type = "jump_straight"
var flip = false
var step_primed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#spawn_vfx("jump_angle", self.global_position, true)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var player_x_velocity = $"../PlayerMovementController".character.velocity.x
	var floored = $"../PlayerMovementController".grounded
	if player_x_velocity != 0 and step_primed:
		if floored:
			dust_step("step")
	pass

func dust_step(animation_name):
	step_primed = false
	spawn_vfx(animation_name, self.global_position, flip)
	$StepDustTimer.start()
	
func _on_step_dust_timer_timeout():
	step_primed = true
	pass # Replace with function body.


	
func _on_player_movement_controller_player_jump() -> void:
	var player_x_velocity = $"../PlayerMovementController".character.velocity.x
	if player_x_velocity < 100 and player_x_velocity > -100:
		anim_type = "jump_straight"
	else:
		anim_type = "jump_angle"
	
	if $"../PlayerMovementController".character.velocity.x > 100:
		flip = true
	else:
		flip = false
	spawn_vfx(anim_type, self.global_position, flip)
	pass # Replace with function body.
	
	pass # Replace with function body.

func spawn_vfx(animation_name, position, flipped:bool):
	var new_sprite = animated_sprite_scene.instantiate() as AnimatedSprite2D
	new_sprite.global_position = position
	new_sprite.animation = animation_name
	new_sprite.play()
	new_sprite.flip_h = flipped
	#add_child(new_sprite)
	#print(new_sprite.animation)
	get_tree().root.add_child(new_sprite)
	
