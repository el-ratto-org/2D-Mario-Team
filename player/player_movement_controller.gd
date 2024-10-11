extends CharacterBody2D

# Gravity & falling
@export var slow_gravity: float = 800 # When falling
@export var fast_gravity: float = 1800 # When fast falling
@export var terminal_velocity: float = 500.0

# Knockback
@export var knockback_decay: float = 2.0

# Subnodes
@onready var inventory = $Inventory
@onready var health = $Health
@onready var run = $Movement/Run
@onready var jump = $Movement/Jump
@onready var wall_jump = $Movement/WallJump
@onready var slide = $Movement/Slide
@onready var step_up = $Movement/StepUp
@onready var flying = $Movement/Flying

var movement_direction: Vector2 = Vector2.ZERO

var knockback: float = 0 # How much you're currently in control, or getting flung
var knockback_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	PlayerManager.player = self


func _physics_process(delta: float) -> void:
	# Vertical motion
	apply_gravity(delta)
	flying.update(delta)
	
	if is_on_wall():
		wall_jump.update(delta)
	else:
		jump.update(delta)
	
	# Horizontal motion
	slide.update(delta)
	if not slide.is_sliding():
		run.update(delta)
	
	# Step up onto any surfaces
	step_up.step_check(delta)
	
	# Decay knockback over time
	knockback = max(knockback - knockback_decay * delta, 0.0)
	
	# Remove control from the player when they're being flung
	velocity = lerp(movement_direction, knockback_direction, knockback)
	
	print(movement_direction)
	
	# Complete physics update cycle
	move_and_slide()


func apply_gravity(delta: float):
	# Bail if we're on the floor, and stop us from moving down
	if is_on_floor():
		movement_direction.y = 0
		return
	
	# The strength of gravity depends on whether we're fast falling
	var gravity = fast_gravity if Input.is_action_pressed("move_down") else slow_gravity
	
	# Apply gravity
	movement_direction.y += gravity * delta
	
	# Make sure we don't fall faster than the terminal velocity
	movement_direction.y = min(movement_direction.y, terminal_velocity)


func _on_foot_hit_box_area_entered(area: Area2D) -> void:
	jump.do_jump()
