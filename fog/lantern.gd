extends Node2D

@export var radius: float = 1

var lantern_radius_current: float = 0

func _process(delta: float) -> void:
	var viewport_size = get_viewport_rect().size
	var camera_center = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_position = (global_position - camera_center) * 2 / viewport_size + Vector2(0.5, 0.5)
	
	if Input.is_key_pressed(KEY_1):
		set_active(true)
	if Input.is_key_pressed(KEY_2):
		set_active(false)
	
	var main_player_distance = pow(PlayerStatsManager.player.global_position.distance_to(global_position) / 200.0, 3.0)
	
	RenderingServer.global_shader_parameter_set("lantern_position", screen_position)
	RenderingServer.global_shader_parameter_set("lantern_radius", lantern_radius_current)
	RenderingServer.global_shader_parameter_set("lantern_opacity", clamp(lantern_radius_current * (1.0 - main_player_distance), 0, 1))

func set_active(active: bool) -> void:
	create_tween().tween_property(self, 'lantern_opacity', 1 if active else 0, 0.25)
	if active:
		create_tween() \
			.tween_property(self, 'lantern_radius_current', radius, 0.75) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)
	else:
		create_tween() \
			.tween_property(self, 'lantern_radius_current', 0, 0.35) \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT)
