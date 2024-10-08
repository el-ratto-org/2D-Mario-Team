extends Node2D


func _on_pickup_range_area_entered(area: Area2D) -> void:
	assert(area.owner.is_in_group("Players"), "Non player entity tried to pick up feather, layers/masks are wrong 🐕‍🦺")
	
	# Give player item, then play caption
	PlayerManager.player.inventory.has_double_jump_item = true
	PlayerManager.play_caption('feather')
	
	# Remove pickup item
	queue_free()
