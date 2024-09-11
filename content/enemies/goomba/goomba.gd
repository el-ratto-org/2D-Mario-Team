extends CharacterBody2D

var sounds = {
	"jumped_on": "res://content/sfx/kick-heavy.ogg",
}

@onready var audio_player = %SfxManager
@onready var hit_box = $HitBox

const SPEED = 300.0

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
			jumped_on()  # Enemy takes damage
		
func jumped_on():
	# Play death sound - audio man gets deletd before it finished - fix this somehow
	audio_player.play_sound("jumped_on")
	
	# Delete
	queue_free()
