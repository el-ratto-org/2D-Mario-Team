extends Node2D

@export var player: Node2D

# Prepare child nodes 
@onready var plants_layer_1 : TileMapLayer = $"Plants(Layer1)"
@onready var plants_layer_2 : TileMapLayer = $"Plants(Layer2)"

#Tile set IDs
const EVIL_SOURCE_ID = 0
const HOLY_SOURCE_ID = 1

var tile_pos = Vector2i(17,-1)

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var camera_center = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_position = (player.global_position - camera_center) * 2 / viewport_size + Vector2(0.5, 0.5)
	
	RenderingServer.global_shader_parameter_set("lantern_position", screen_position)
