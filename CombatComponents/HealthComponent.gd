extends Node2D
class_name HealthComponent

# Signals
signal health_changed
signal take_damage
signal healed
signal die

@export var health: float = 1
@export var invulnerability_duration: float = 0.1

var max_health
var invulnerability_time: float = 0


@export var damage_flash_duration = 0.1
var damage_flash_time = damage_flash_duration
var currently_flashing = false

@onready var player_sprite = $"../AnimatedSprite2D"
@onready var caption_manager = %caption_manager

@onready var take_damage_shader = load("res://assets/shaders/damaged.tres")


func _ready() -> void:
	max_health = health

	var player_sprite = get_player_sprite()

func _process(delta: float) -> void:
	if invulnerability_time > 0:
		invulnerability_time -= delta
		
	if damage_flash_time >= 0:
		damage_flash_time -= delta
	elif currently_flashing == true:
		hit_shader(false)
		
	if Input.is_action_just_pressed("debug"):
		_take_damage(0.5)

func _take_damage(damage: float) -> void:
	if invulnerability_time > 0:
		return
	
	# Deeal damage
	health -= damage
	health = max(health, 0)
	
	# Set iframes
	invulnerability_time = invulnerability_duration
	
	# Send signals
	emit_signal("take_damage")
	emit_signal("health_changed")
	
	# Detect death
	if health <= 0:
		PlayerStatsManager.caption_manager.death()
		emit_signal("die")
	
	hit_shader(true)
	
func get_player_sprite() -> Node:
	# Get the player node (parent of HealthComponent)
	var player = get_parent()  # This should get the Player node
	
	# Ensure the player is valid and is of the expected type
	if player:
		# Access the AnimatedSprite2D node using a relative path
		var animated_sprite = player.get_node("AnimatedSprite2D")  # Correct path based on your scene tree
		var sprite = player.get_node("Sprite2D")
		
		# Check if the AnimatedSprite2D is valid
		if animated_sprite and animated_sprite is AnimatedSprite2D:
			print ("flag")
			return animated_sprite
		elif sprite and sprite is Sprite2D:
			return sprite
			
	print("HealthComponent Error: Sprite/AnimSprite not found or is not a valid instance for ", player)
	return null  # Return null if not found or not valid

func hit_shader(on: bool):
	if on == true:
		if player_sprite != null:
			player_sprite.material.set_shader_parameter("mix_ratio", 1.0)
			damage_flash_time = damage_flash_duration
			currently_flashing = true
	else:
		if player_sprite != null:
			player_sprite.material.set_shader_parameter("mix_ratio", 0.0)
			currently_flashing = false
		# Optionally, you can add logic for other effects, like changing the color
		# sprite.material.set_shader_param("your_param_name", value)
	
func _heal(heal_amount: float) -> void:
	health += heal_amount
	health = min(health, max_health)
	
	emit_signal("healed")
	emit_signal("health_changed")
