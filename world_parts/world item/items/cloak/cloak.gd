extends Node2D


func _on_pickup_range_area_entered(area: Area2D) -> void:
	assert(area.owner.is_in_group("Players"), "Non player entity tried to pick up cloak, layers/masks are wrong o*￣▽￣*)ブ")
	
	# Give player item, then play caption
	PlayerManager.player.inventory.has_dash_item = true
	PlayerManager.play_caption('cloak')
	
	# Remove pickup item
	queue_free()
