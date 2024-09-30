extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	step_sound()
			
func step_sound():
	var player_x_velocity = $"../PlayerMovementController".character.velocity.x
	
	if not abs(player_x_velocity) > 0 :
		return
	if not player_floored():
		return
		
	if $StepTimer.time_left <= 0:
		$Step_sound.pitch_scale = randf_range(0.8, 1.2)
		$Step_sound.play()
		$StepTimer.start()
			
func player_floored():
	if $"../PlayerMovementController".grounded:
		return true
	else:
		return false
		
func _on_player_movement_controller_player_jump() -> void:
	$JumpSound.pitch_scale = randf_range(0.8, 1.2)
	$JumpSound.play()


func _on_dust_fx_landed() -> void:
	$LandingSound.pitch_scale = randf_range(0.8, 1.2)
	$LandingSound.play()
	pass # Replace with function body.
