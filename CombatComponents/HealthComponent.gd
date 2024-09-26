extends Node2D
class_name HealthComponent

# Signals
signal health_changed
signal take_damage
signal healed
signal die

@export var health: float = 1
@export var invulnerability_duration: float = 10

var max_health
var invulnerability_time: float = 0

func _ready() -> void:
	max_health = health

func _process(delta: float) -> void:
	if invulnerability_time > 0:
		invulnerability_time -= delta

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
		emit_signal("die")
	
func _heal(heal_amount: float) -> void:
	health += heal_amount
	health = min(health, max_health)
	
	emit_signal("healed")
	emit_signal("health_changed")
