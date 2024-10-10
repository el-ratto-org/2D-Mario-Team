extends Node2D

@export var target: CharacterBody2D
@export var move_speed: float = 30
@export var move_drag: float = 1.065

@onready var slide_timer: Timer = $SlideTimer
@onready var cooldown_timer: Timer = $CooldownTimer

signal start_slide


func update(delta: float) -> void:
	assert(target != null, "Must assign player to script")
	
	# Determine which direction the player is moving
	var horizontal_axis = Input.get_axis("move_left", "move_right")
	
	# Check if we are already sliding, if so; bail
	if is_sliding():
		# We are currently sliding, slow down over time
		target.velocity.x /= move_drag
		if Input.is_action_just_released("slide"):
			slide_timer.stop()
		return
	
	# Ensure we want to slide
	if not Input.is_action_just_pressed("slide"):
		return
	
	# Ensure we aren't on a slide cooldown
	if not cooldown_timer.is_stopped():
		return
	
	# Ensure we're moving in any direction
	if not horizontal_axis:
		return
	
	# Ensure we're on the floor
	if not target.is_on_floor():
		return
		
	if not target.inventory.has_double_jump_item:
		return
	
	# Determine which direction we're moving and how fast
	var max_move_speed = move_speed * 1000 * delta
	var horizontal_motion = horizontal_axis * max_move_speed
	
	# Apply velocity & start slide/cooldown timers
	start_slide.emit()
	target.velocity.x = horizontal_motion
	slide_timer.start()
	cooldown_timer.start()
	


func is_sliding() -> bool:
	return not slide_timer.is_stopped()
