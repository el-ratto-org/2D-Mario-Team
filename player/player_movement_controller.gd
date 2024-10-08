extends CharacterBody2D

# Gravity & falling
@export var slow_gravity: float = 800 # When falling
@export var fast_gravity: float = 1800 # When fast falling
@export var terminal_velocity: float = 500.0

# Subnodes
@onready var inventory = $Inventory
@onready var health = $HealthComponent
@onready var run = $Movement/Run
@onready var jump = $Movement/Jump
@onready var slide = $Movement/Slide
@onready var step_up = $Movement/StepUp
@onready var flying = $Movement/Flying


func _ready() -> void:
	PlayerManager.player = self


func _physics_process(delta: float) -> void:
	# Vertical motion
	apply_gravity(delta)
	flying.update(delta)
	jump.update(delta)
	
	# Horizontal motion
	slide.update(delta)
	if not slide.is_sliding():
		run.update(delta)
	
	# Step up onto any surfaces
	step_up.step_check(delta)
	
	# Complete physics update cycle
	move_and_slide()


func apply_gravity(delta: float):
	# The strength of gravity depends on whether we're fast falling
	var gravity = fast_gravity if Input.is_action_pressed("move_down") else slow_gravity
	
	# Apply gravity
	velocity.y += gravity * delta
	
	# Make sure we don't fall faster than the terminal velocity
	velocity.y = min(velocity.y, terminal_velocity)


func _on_foot_hit_box_area_entered(area: Area2D) -> void:
	jump.do_jump()
