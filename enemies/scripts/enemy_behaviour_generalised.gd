extends Node
class_name EnemyBehaviourGeneralised

@export var behaviour_type: BehaviourTypes
@export var duration: Vector2
@export var bahaviour_conditions: Array[BehaviourConditionType]
@export var behaviour_condition_values: Array[float]
@export var random_next_behaviour: Array[EnemyBehaviour]

enum BehaviourTypes {
	Idle,
	ChasePlayer,
	RunFromPlayer,
	DashAtPlayer,
}

enum BehaviourConditionType {
	PlayerInHorizontalRange,
	PlayerInVerticalRange
}
