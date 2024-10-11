extends EnemyBehaviourManager

@export var fly_behaviour: EnemyBehaviour
@export var swoop_behaviour: EnemyBehaviour
@export var shoot_behaviour: EnemyBehaviour


@onready var timer: Timer = $"../Timer"

var flying: bool = false
var swooping: bool = false
var shooting: bool = false

var volley_shot_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flying = true
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	super(delta)
	if flying:
		fly_behaviour._run()
	elif swooping:
		swoop_behaviour._run()
	elif shooting:
		fly_behaviour._run()
		_shoot_volley()
	else:
		_choose_next_behaviour()

func _choose_next_behaviour() -> void:
	var rand = randi_range(0, 2)
	
	if rand == 0:
		flying = true
		timer.wait_time = 2
		timer.start()
	elif rand == 1:
		swoop_behaviour._calculate_swoop_path(PlayerManager.player.global_position)
		swooping = true
	elif  rand == 2:
		shooting = true
	

func _shoot_volley() -> void:
	var number_of_shots = 5
	
	if volley_shot_count <= 0:
		volley_shot_count = number_of_shots
	
	if timer.time_left <= 0 && volley_shot_count > 0:
		var angle = volley_shot_count * ((PI / 2) / number_of_shots) + (PI * 0.25)
		shoot_behaviour.direction = Vector2(cos(angle), sin(angle))
		shoot_behaviour._run()
		timer.wait_time = 0.4
		timer.start()


func _on_timer_timeout() -> void:
	timer.stop()
	flying = false
	
	volley_shot_count -= 1
	if volley_shot_count <= 0:
		shooting = false


func _on_swoop_swoop_finished() -> void:
	swooping = false
