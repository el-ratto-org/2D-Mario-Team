extends Node2D
class_name HealthComponent

signal take_damage
signal healed
signal die

var maxHealth = 0
@export var health = maxHealth
@export var invulnerabilityDuration = 10
var invulnerabilityTime = 0

func _take_damage(damage: float) -> void:
	if(invulnerabilityTime > 0):
		return
		
	health -= damage
	health = max(health, 0)
	
	invulnerabilityTime = invulnerabilityDuration
	
	emit_signal("take_damage")
	
	if(health <= 0):
		emit_signal("die")
	
func _heal(healAmount: float) -> void:
	health += healAmount
	health = min(health, maxHealth)
	
	emit_signal("healed")

func _ready() -> void:
	maxHealth = health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(invulnerabilityTime > 0):
		invulnerabilityTime -= get_process_delta_time()
