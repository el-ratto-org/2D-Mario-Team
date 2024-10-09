extends Node2D

var checkpoints = {}
var completion = {
	"Clinic" : true,
	"Wall" : false,
	"Executioner" : false,
	"Young" : false,
	"Red" : false,
}
var selected_level = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_last_checkpoint(level: String):
	if checkpoints[level] != null:
		return checkpoints[level]
	else:
		return Vector2(0,0)
