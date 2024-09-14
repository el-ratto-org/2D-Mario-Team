extends Node
class_name EnemyBehaviour

@export var character: CharacterBody2D
@export var movement_controller: EnemyMovementController

@export var direction = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if character.is_on_wall():
		direction *= -1
	movement_controller._set_horizontal_input(direction)
