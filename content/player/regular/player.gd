extends CharacterBody2D

const MAX_SPEED = 250.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 3750.0  # How quickly the character accelerates
const FRICTION = 1500.0       # How quickly the character decelerates

const DASH_TIME = 0.2        # Duration of the dash
const DASH_COOLDOWN = 1.0    # Time between dashes
var dashing = false
var dash_timer = 0.0
var dash_cooldown_timer = 0.0


@onready var hit_box = $HitBox

# testing
var hit_count = 0

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
	var overlapping_mobs = hit_box.get_overlapping_bodies()
	if overlapping_mobs.size() > 1:
		print (hit_count)
		hit_count += 1
		take_damage()
		
func jump():
	velocity.y = JUMP_VELOCITY
	
func take_damage():
	print ("player hit")
