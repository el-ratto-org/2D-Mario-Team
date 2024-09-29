extends TileMapLayer

var current_type = "evil"
var tile_swap_loc = Vector2i(12,-1)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var self_data = self.get_cell_atlas_coords(tile_swap_loc)
	var self_data = self.get_cell_tile_data(tile_swap_loc)
	print(self_data)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
