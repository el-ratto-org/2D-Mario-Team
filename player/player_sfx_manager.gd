extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	step_sound()
			
func step_sound():
	var player_x_velocity = owner.velocity.x
	
	if not abs(player_x_velocity) > 0 :
		return
	
	if not owner.is_on_floor():
		return
		
	if $StepTimer.time_left <= 0:
		$Step_sound.pitch_scale = randf_range(0.8, 1.2)
		$Step_sound.play()
		$StepTimer.start()


func _on_player_jumped() -> void:
	$JumpSound.pitch_scale = randf_range(0.8, 1.2)
	$JumpSound.play()


func _on_dust_fx_landed() -> void:
	$LandingSound.pitch_scale = randf_range(0.8, 1.2)
	$LandingSound.play()
	pass # Replace with function body.
