extends EnemyBehaviourManager

@export var charge_left: EnemyBehaviour
@export var charge_right: EnemyBehaviour
@export var charge_duration: float = 2
var is_charging: bool = false
var current_charge_behaviour: EnemyBehaviour

@onready var timer: Timer = $"../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	
	# Chose new charge direction
	if !is_charging && abs(_player_relative_position().x) < 200:
		if _player_relative_position().x < 0:
			current_charge_behaviour = charge_left
		else:
			current_charge_behaviour = charge_right
		
		timer.wait_time = charge_duration
		timer.start()
		is_charging = true
	
	if current_charge_behaviour != null:
		current_charge_behaviour._run()


func _on_timer_timeout() -> void:
	is_charging = false
