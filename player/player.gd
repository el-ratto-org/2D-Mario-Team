extends CharacterBody2D

const MAX_SPEED = 250.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 3750.0  # How quickly the character accelerates
const FRICTION = 1500.0       # How quickly the character decelerates
const MAX_LEAN = 5.0         # Maximum lean angle in degrees
const LEAN_SPEED = 0.2      # How fast the leaning happens

# Dash stuff
const DASH_TIME = 0.2        # Duration of the dash
const DASH_COOLDOWN = 1.0    # Time between dashes
var dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0

# Screen shake
@onready var camera = $Camera2D
var shake_timer = 0.0
var shake_intensity = 0.0
var shake_duration = 0.0

@export var sword_hit_box: HitBox

@onready var hit_box = $HitBox
@onready var sprite = $Sprite2D  # Reference to the Sprite2D node
@onready var audio_player = %SfxManager
@onready var key_manager = $Key_manager

func start_shake(duration: float, intensity: float):
	shake_timer = duration
	shake_duration = duration
	shake_intensity = intensity

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		
		# Calculate shake strength based on a sine wave and damping over time
		var damping_factor = shake_timer / shake_duration  # Reduces from 1 to 0
		var current_intensity = shake_intensity * damping_factor * sin(shake_timer * PI * 10)  # Damped sine wave
		
		# Apply random shake within the current intensity range
		camera.offset = Vector2(
			randi_range(-current_intensity, current_intensity), 
			randi_range(-current_intensity, current_intensity)
		)
	else:
		# Reset the camera position when the shake is done
		camera.offset = Vector2.ZERO

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		jump()
		
	# Handle dash.
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0:
		print ("dash")
		dashing = true
		dash_timer = DASH_TIME
		dash_cooldown_timer = DASH_COOLDOWN

	if dashing:
		dash_timer -= delta
		if dash_timer <= 0:
			dashing = false

	# Get the input direction and handle movement with acceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if dashing and direction != 0:
		pass
		# Apply dash speed while dashing
		#velocity.x = direction * DASH_SPEED
	elif direction != 0:
		# Accelerate in the direction of movement
		velocity.x = move_toward(velocity.x, direction * MAX_SPEED, ACCELERATION * delta)
	else:
		# Apply friction to decelerate when no input is given
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	# Decrease dash cooldown timer.
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta

	# Flip the sprite based on the movement direction.
	if direction != 0:
		$Sprite2D.flip_h = direction < 0  # Flip when moving left

	# Apply the movement
	move_and_slide()
	
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

func jump():
	velocity.y = JUMP_VELOCITY

func jumped_on_enemy():
	velocity.y = JUMP_VELOCITY
	audio_player.play_sound("jumped_on")
	
func take_damage():
	# Since 'regular player' is == small mario (?)
	player_death()
	
func player_death():
	print ("   YOU DIED   ")
	audio_player.play_sound("player_death")

# New function for applying leaning effect
func apply_leaning_effect(delta: float) -> void:
	var target_rotation = 0.0

	# Lean during horizontal movement
	if abs(velocity.x) > 0:
		target_rotation += clamp(velocity.x / MAX_SPEED, -1.0, 1.0) * MAX_LEAN

	# Lean during jumping and falling
	if velocity.y != 0:
		target_rotation += clamp(velocity.y / JUMP_VELOCITY, -1.0, 1.0) * MAX_LEAN

	# Smoothly interpolate to the target rotation angle
	sprite.rotation_degrees = lerp(sprite.rotation_degrees, target_rotation, LEAN_SPEED)

func add_key(code: String):
	key_manager._add_key(code)

func _on_hit_box_deal_damage() -> void:
	print("Jumped on enemy")
	jumped_on_enemy()

func get_keys():
	return key_manager.get_key_list()

func _on_health_component_take_damage() -> void:
	take_damage()
