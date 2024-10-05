extends CollisionShape2D

func _on_lantern_lantern_radius(lantern_scale: float) -> void:
	scale.x = lantern_scale
	scale.y = lantern_scale
