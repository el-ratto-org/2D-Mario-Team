extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _on_pickup_range_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity.name == "Player":
		print("player picked up item feather / 2xjump")
		PlayerStatsManager.has_double_jump_item = true
		PlayerStatsManager.play_caption('feather')
		queue_free()
	else:
		print("non player entity tried to pick up item, layers/masks are wrong 🐕‍🦺")
		
