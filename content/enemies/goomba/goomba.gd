extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const BOOST_VELOCITY = 853800.0

@onready var hit_box = $HitBox

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
		# Handle getting hit
	var overlapping_bodies = hit_box.get_overlapping_bodies()
	
	for body in overlapping_bodies:
		if body is CharacterBody2D and body.name == "Player":  # Check if the mob is the player
			body.jump()  # Give the player an upward boost
			take_damage()  # Enemy takes damage
		
func take_damage():
	queue_free()
