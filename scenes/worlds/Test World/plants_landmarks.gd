extends TileMapLayer

var current_type = "evil"
var tile_swap_loc = Vector2i(12,-1)


func _ready() -> void:
	# FIXME: Why is this here?
	var self_data = get_cell_tile_data(tile_swap_loc)
