extends Timer
class_name EnemyBehaviourManagerGeneralised

@export var character: CharacterBody2D
@export var movement_controller: EnemyMovementController

@export var horizontal_direction = 1


var behaviours: Array[EnemyBehaviour]
var behaviour_index: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	connect("timeout", _on_timer_timeout)
	
	# Get all behaviours
	for node in get_children():
		behaviours.push_back(node)
	
	# Initialise first  behaviour
	if behaviours.size() > 0:
		behaviour_index = 0
		wait_time = randf_range(behaviours[behaviour_index].duration.x, behaviours[behaviour_index].duration.y)
		start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	# Chose next behaviour
	# **************************************************
	var behaviour_chosen = false
	if behaviours[behaviour_index].random_next_behaviour.size() > 0:
		# Chose random next behaviour from list
		
		# Get valid behaviours from list
		var valid_behaviours: Array[EnemyBehaviour]
		for next_behaviour in behaviours[behaviour_index].random_next_behaviour:
			if _check_behaviour_conditions(next_behaviour):
				valid_behaviours.push_back(next_behaviour)
		
		# Choose from valid behaviours
		if valid_behaviours.size() > 0:
			var tempIndex = randf_range(0, valid_behaviours.size() - 1)
			behaviour_index = valid_behaviours[tempIndex].get_index()
			behaviour_chosen = true
		
	if not behaviour_chosen: # No behaviours specified (or no valid behaviour) so go to next valid one in list
		while not behaviour_chosen:
			# Loop back to start if at end of behaviours
			if behaviour_index >= (behaviours.size() - 1):
				behaviour_index = 0
				behaviour_chosen = true
			else:
				# Go to next behaviour
				behaviour_index += 1
				if _check_behaviour_conditions(behaviours[behaviour_index]):
					behaviour_chosen = true
	# **************************************************
	
	# Restart timer
	wait_time = randf_range(behaviours[behaviour_index].duration.x, behaviours[behaviour_index].duration.y - 1)
	start()
	

# Check all conditions
func _check_behaviour_conditions(behaviour: EnemyBehaviour) -> bool:
	if behaviour.bahaviour_conditions.size() <= 0:
		return true
	
	if behaviour.bahaviour_conditions.size() != behaviour.behaviour_condition_values.size():
		printerr("Error in object: %s, behaviour %i has unequal condtiton types and values", character.name, behaviour.get_index())
		assert(false)
	
	for n in behaviour.bahaviour_conditions.size():
		if not _check_behaviour_condition(behaviour.bahaviour_conditions[n], behaviour.behaviour_condition_values[n]):
			return false
	
	return true

# Check individual condition
func _check_behaviour_condition(condition: EnemyBehaviour.BehaviourConditionType, value: float) -> bool:
	match condition:
		EnemyBehaviour.BehaviourConditionType.PlayerInHorizontalRange:
			if abs(PlayerStatsManager._get_player_position().x - character.position.x) > value:
				return false
		EnemyBehaviour.BehaviourConditionType.PlayerInVerticalRange:
			if abs(PlayerStatsManager._get_player_position().y - character.position.y) > value:
				return false
	
	return true

func _physics_process(delta: float) -> void:
	
	if character.is_on_wall():
		horizontal_direction *= -1
	
	if behaviours[behaviour_index].behaviour_type == EnemyBehaviour.BehaviourTypes.ChasePlayer:
		if (character.position.x - PlayerStatsManager._get_player_position().x) < 0:
			horizontal_direction = 1
		else:
			horizontal_direction = -1
	else:
		if behaviours[behaviour_index].behaviour_type == EnemyBehaviour.BehaviourTypes.RunFromPlayer:
			if (character.position.x - PlayerStatsManager._get_player_position().x) < 0:
				horizontal_direction = -1
			else:
				horizontal_direction = 1
		else:
			horizontal_direction = 0
	
	
	
	movement_controller._set_horizontal_input(horizontal_direction)
	
