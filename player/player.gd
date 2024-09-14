extends CharacterBody2D

# Horizontal motion
@export var move_speed: float = 200
@export var turning_speed: float = 3

# Vertical motion
@export var min_jump_height: float = 200
@export var max_jump_height: float = 400
@export var slow_gravity: float = 800 # When falling
@export var fast_gravity: float = 1800 # When fast falling
@export var terminal_velocity: float = 500.0

# Jump grace & auto jump
@export var jump_grace: float = 0.1
@export var auto_jump: float = 0.1

# Movement variables
var turning_fatigue: float = 0
var current_move: float = 0
var jumped: bool = false
var auto_jump_time: float = 0
var jump_grace_time: float = 0

# Combat
@export var sword_hit_box: HitBox
@onready var hit_box = $HitBox
@onready var sprite = $Sprite2D  # Reference to the Sprite2D node

# Sound
@onready var audio_player = %SfxManager


func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	calculate_horizontal_movement(delta)
	calculate_vertical_movement(delta)
	move_and_slide()

func calculate_horizontal_movement(delta: float):
	# Calculate movement axis
	var horizontal_axis = Input.get_axis("move_left", "move_right")

	# Calculate turning fatigue
	if horizontal_axis:
		turning_fatigue = clamp(turning_fatigue + horizontal_axis * turning_speed * delta, -1, 1)
	else:
		# Calculate decay
		if abs(turning_fatigue) <= turning_speed * delta:
			turning_fatigue = 0
		else:
			turning_fatigue -= sign(turning_fatigue) * turning_speed * delta

	var turning_control = 1 - abs(turning_fatigue)
	current_move = clamp(lerp(current_move, horizontal_axis * move_speed, turning_control), -move_speed, move_speed)

	if horizontal_axis:
		velocity.x = current_move
	else:
		velocity.x = 0

	# Handle getting hit
	#********** ORIGINAL COMBAT CODE CAN BE DELETED **********
	#var overlapping_mobs = hit_box.get_overlapping_bodies()
	#if overlapping_mobs.size() > 0:
	#	take_damage()

	# Apply leaning effect
	apply_leaning_effect(delta)
	
	
	# Temporary sword test
	if Input.is_action_just_pressed("attack") && sword_hit_box != null:
		sword_hit_box.set_process_mode(PROCESS_MODE_INHERIT)
		sword_hit_box.show()
	else:
		sword_hit_box.set_process_mode(PROCESS_MODE_DISABLED)
		sword_hit_box.hide()

func calculate_vertical_movement(delta: float):
	# Decay jump grace time
	jump_grace_time = max(jump_grace_time - delta, 0)
	
	# Remember that we were on the floor `x` seconds ago
	if is_on_floor():
		jump_grace_time = jump_grace

	var floored = jump_grace_time > 0

	# Velocity with fast-falling
	velocity.y = clamp(
		velocity.y +
			(slow_gravity if not Input.is_action_pressed("move_down") else fast_gravity) * delta,
		-terminal_velocity,
		terminal_velocity)

	if Input.is_action_just_pressed("move_up"):
		if floored:
			jump()
		else:
			auto_jump_time = auto_jump
	elif floored and auto_jump_time > 0:
		jump()
	
	# Decay auto jump time
	auto_jump_time = max(auto_jump_time - delta, 0)
	
	if jumped and Input.is_action_just_released("move_up") and velocity.y < 0:
		velocity *= min_jump_height / max_jump_height
		jumped = false

func jump():
	velocity.y = -max_jump_height
	jumped = true
	auto_jump_time = 0
	jump_grace_time = 0

func jumped_on_enemy():
	jump()
	audio_player.play_sound("jumped_on")
	
func take_damage():
	# Since 'regular player' is == small mario (?)
	player_death()
	
func player_death():
	print ("   YOU DIED   ")
	audio_player.play_sound("player_death")

# New function for applying leaning effect
func apply_leaning_effect(_delta: float) -> void:
	pass # TODO: Reimplement leaning effect (?)
	# var target_rotation = 0.0

	# # Lean during horizontal movement
	# if abs(velocity.x) > 0:
	# 	target_rotation += clamp(velocity.x / MAX_SPEED, -1.0, 1.0) * MAX_LEAN

	# # Lean during jumping and falling
	# if velocity.y != 0:
	# 	target_rotation += clamp(velocity.y / JUMP_VELOCITY, -1.0, 1.0) * MAX_LEAN

	# # Smoothly interpolate to the target rotation angle
	# sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, LEAN_SPEED)


func _on_hit_box_deal_damage() -> void:
	print("Jumped on enemy")
	jumped_on_enemy()


func _on_health_component_take_damage() -> void:
	take_damage()
