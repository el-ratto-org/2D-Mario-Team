extends ColorRect

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print('test')
	var viewport_size = get_viewport_rect().size
	var camera_center = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_position = (global_position - camera_center) * 2 / viewport_size + Vector2(0.5, 0.5)
	
	(material as ShaderMaterial).set_shader_parameter('surface_y', screen_position.y)
