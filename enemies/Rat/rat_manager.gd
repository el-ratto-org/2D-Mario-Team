extends EnemyBehaviourManager

@export var chase_behaviour: EnemyBehaviour
@export var flee_behaviour: EnemyBehaviour
@export var attack_behaviour: EnemyBehaviour

func _physics_process(delta: float) -> void:
	super(delta)
	if abs(_player_relative_position().x) < 200:
		if _player_relative_position().y < -10:
			flee_behaviour._run()
		else:
			chase_behaviour._run()
			attack_behaviour._run()
