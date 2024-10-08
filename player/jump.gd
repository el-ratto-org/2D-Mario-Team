extends Node2D

signal jumped

@export var target: CharacterBody2D

@export var min_jump_height: float = 200
@export var max_jump_height: float = 400

@onready var jump_grace_timer = $JumpGraceTimer
@onready var auto_jump_timer = $AutoJumpTimer

var holding_jump: bool = false


func update(delta: float) -> void:
	assert(target != null, "Must assign player to script")
	
	# Remember that we were on the floor
	if target.is_on_floor():
		jump_grace_timer.start()
	
	# Remember that we pressed jump
	if Input.is_action_just_pressed("move_up"):
		auto_jump_timer.start()
	
	# Check if we just pressed jump, or we pressed it recently
	if not auto_jump_timer.is_stopped():
		# Check if we are on the floor, or just came off it recently
		if not jump_grace_timer.is_stopped():
			do_jump()
	
	# Check if player is still on upwards trajectory from initial jump
	if holding_jump and Input.is_action_just_released("move_up") and target.velocity.y < 0:
		# The player has let go of the jump key while still gaining height,
		# therefore we should cap off the jump early,
		# and switch to the minimum jump height
		target.velocity.y *= min_jump_height / max_jump_height
		holding_jump = false


func do_jump() -> void:
	jumped.emit()
	target.velocity.y = -max_jump_height
	holding_jump = true
	jump_grace_timer.stop()
	auto_jump_timer.stop()
