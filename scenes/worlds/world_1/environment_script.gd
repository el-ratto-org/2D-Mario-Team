extends Node2D

# Prepare child nodes 
@onready var plants_layer_1 : TileMapLayer = $"Plants(Layer1)"
@onready var plants_layer_2 : TileMapLayer = $"Plants(Layer2)"

#Tile set IDs
const EVIL_SOURCE_ID = 0
const HOLY_SOURCE_ID = 1

var tile_pos = Vector2i(17,-1)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var atlas_pos = plants_layer_1.get_cell_atlas_coords(tile_pos)
	#print(atlas_pos)
	#plants_layer_1.set_cell(Vector2i(17,-1), HOLY_SOURCE_ID, atlas_pos)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
