extends Node2D

@onready var keys = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _add_key(code: String):
	keys.append(code)
	
func get_key_list():
	return keys
