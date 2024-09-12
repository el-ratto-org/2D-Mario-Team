extends CharacterBody2D

@onready var audio_player = %SfxManager
@onready var hit_box = $HitBox

@export var speed = 3000.0
var turn_counter = 0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	velocity.x = speed

	turn_counter += 1
	if is_on_wall() and turn_counter > 10:
		speed *= -1
		turn_counter = 0

	move_and_slide()
	
		# Handle getting hit
		#********** ORIGINAL COMBAT CODE CAN BE DELETED **********
	#var overlapping_bodies = hit_box.get_overlapping_bodies()
	
	#for body in overlapping_bodies:
	#	if body is CharacterBody2D and body.name == "Player":  # Check if the mob is the player
	#		body.jumped_on_enemy() 
	#		jumped_on(body)  
		
#func jumped_on(body):
	# Play death sound - audio man gets deletd before it finished - fix this somehow
	#audio_player.play_sound("jumped_on")
	
#	body.start_shake(0.3, 20.0)  # Shake for 0.3 seconds with intensity 2

	
	# Delete
#	queue_free()


func _on_health_component_die() -> void:
	print("goomba now dead")
	queue_free()
