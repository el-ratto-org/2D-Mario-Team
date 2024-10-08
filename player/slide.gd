extends Node2D

@export var target: CharacterBody2D
@export var move_speed: float = 30
@export var move_drag: float = 1.065

@onready var slide_timer: Timer = $SlideTimer
@onready var cooldown_timer: Timer = $CooldownTimer


func update(delta: float) -> void:
	assert(target != null, "Must assign player to script")
	
	var horizontal_axis = Input.get_axis("move_left", "move_right")
	
	if not is_sliding():
		if horizontal_axis and Input.is_action_just_pressed("slide") and target.is_on_floor() and cooldown_timer.is_stopped():
			var max_move_speed = move_speed * 1000 * delta
			var horizontal_motion = horizontal_axis * max_move_speed
			
			target.velocity.x = horizontal_motion
			slide_timer.start()
			cooldown_timer.start()
	else:
		# We are currently sliding, slow down over time
		target.velocity.x /= move_drag
		if Input.is_action_just_released("slide"):
			slide_timer.stop()


func is_sliding() -> bool:
	return not slide_timer.is_stopped()
