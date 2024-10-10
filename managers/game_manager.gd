extends Node2D

var checkpoints = {}
var completion = {
	"Clinic" : true,
	"Wall" : false,
	"Executioner" : false,
	"Young" : false,
	"Red" : false,
}
var worlds = {
	"Clinic": {
		"completed": true,
		"path": "res://scenes/worlds/World 1/world1.tscn",
		"checkpoints": Vector2(0, 0)
	},
	"Wall": {
		"completed": false,
		"path": "res://scenes/worlds/World 2/world_2.tscn",
		"checkpoints": Vector2(0, 0)
	},
	"Executioner": {
		"completed": false,
		"path": "res://scenes/worlds/World 2/world_3.tscn",
		"checkpoints": Vector2(0, 0)
	},
	"Young": {
		"completed": false,
		"path": "res://scenes/worlds/World 2/world_4.tscn",
		"checkpoints": Vector2(0, 0)
	},
	"Red": {
		"completed": false,
		"path": "res://scenes/world select/world_select_inside.tscn",
		"checkpoints": Vector2(0, 0)
	}
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
