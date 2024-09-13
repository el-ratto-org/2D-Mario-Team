extends Node2D
class_name HealthComponent

# Signals
signal health_changed
signal take_damage
signal healed
signal die

var maxHealth
@export var health:float = 1
@export var invulnerabilityDuration:float = 10
var invulnerabilityTime:float = 0

func _ready() -> void:
	maxHealth = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if invulnerabilityTime > 0:
		invulnerabilityTime -= delta 

func _take_damage(damage: float) -> void:
	if invulnerabilityTime > 0:
		return
	
	# Deeal damage
	health -= damage
	health = max(health, 0)
	
	# Set iframes
	invulnerabilityTime = invulnerabilityDuration
	
	# Send signals
	emit_signal("take_damage")
	emit_signal("health_changed")
	
	# Detect death
	if health <= 0:
		emit_signal("die")
	
func _heal(healAmount: float) -> void:
	health += healAmount
	health = min(health, maxHealth)
	
	emit_signal("healed")
	emit_signal("health_changed")
