extends CharacterBody2D

@onready var audio_player = %SfxManager
@onready var hit_box = $HitBox

@export var speed = 3000.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	#var direction := Input.get_axis("ui_left", "ui_right")
	if 1==1: #direction != 0:
		# Accelerate in the direction of movement
		velocity.x = speed
	else:
		pass

	move_and_slide()
	
		# Handle getting hit
	var overlapping_bodies = hit_box.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body is CharacterBody2D and body.name == "Player":  # Check if the mob is the player
			body.jump()  # Give the player an upward boost
			jumped_on()  # Enemy takes damage
		
func jumped_on():
	# Play death sound - audio man gets deletd before it finished - fix this somehow
	audio_player.play_sound("jumped_on")
	
	# Delete
	queue_free()
