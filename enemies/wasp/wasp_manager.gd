extends EnemyBehaviourManager

@export var fly_behaviour: EnemyBehaviour
@export var shoot_behaviour: EnemyBehaviour

@export var shoot_interval: float = 2

var can_shoot: bool = false
@onready var shoot_timer: Timer = $"../ShootTimer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shoot_timer.wait_time = shoot_interval
	shoot_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	
	# Chose new charge direction
	if can_shoot:
		shoot_behaviour._run()
		can_shoot = false
		shoot_timer.wait_time = shoot_interval
		shoot_timer.start()
	else:
		fly_behaviour._run()


func _on_shoot_timer_timeout() -> void:
	can_shoot = true
