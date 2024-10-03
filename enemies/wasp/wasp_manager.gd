extends EnemyBehaviourManager

@export var fly_behaviour: EnemyBehaviour
@export var shoot_behaviour: EnemyBehaviour

@export var shoot_interval: float = 2

var can_shoot: bool = false
@onready var timer: Timer = $"../Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = shoot_interval
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	
	# Chose new charge direction
	if can_shoot:
		shoot_behaviour._run()
		print("wasp is shooting")
		can_shoot = false
		timer.wait_time = shoot_interval
		timer.start()
	else:
		fly_behaviour._run()

func _on_timer_timeout() -> void:
	can_shoot = true
