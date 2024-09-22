extends Node
class_name EnemyPhysics

@export var gravity: float = 800
@export var terminal_velocity: float = 500.0

var character: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var node = get_parent()
	while node is not CharacterBody2D:
		if node == get_tree().root:
			printerr("Error: Gravity nod not child of CharacterBody2D")
			return
		node = node.get_parent()
	character = node as CharacterBody2D
	
func _physics_process(delta: float) -> void:
	character.velocity.y = clamp(character.velocity.y + gravity * delta, -terminal_velocity, terminal_velocity)
	character.move_and_slide()
