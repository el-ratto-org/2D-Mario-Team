extends Node2D

# Signals
signal changed(delta: float)

# Health variables
@export var current: float = 1
@export var maximum: float = 1

@export var damaged_sprite: Node2D

@onready var invulnerability_timer: Timer = $InvulnerabilityTimer


func _process(_delta: float) -> void:
	assert(damaged_sprite != null, "Must assign damaged sprite")
	
	# Check if player is still invulnerable,
	# if so; make sure they show their damage flash
	var damaged = not invulnerability_timer.is_stopped()
	damaged_sprite.visible = damaged


func change_health(delta: float) -> void:
	current += delta
	
	# Emit signal
	changed.emit(delta)
	
	# Only give iframes if player took damage
	if delta < 0:
		invulnerability_timer.start()


func _on_hurt_box_damage_recieved(damage: float) -> void:
	change_health(-damage)
