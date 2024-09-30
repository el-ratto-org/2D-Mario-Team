extends Node2D

@export var player: CharacterBody2D

func _process(delta: float) -> void:
	assert(player, "need to assign @export")
	var viewport_size = get_viewport_rect().size
	var camera_center = get_viewport().get_camera_2d().get_screen_center_position()
	var screen_position = (player.global_position - camera_center) * 2 / viewport_size + Vector2(0.5, 0.5)
	
	RenderingServer.global_shader_parameter_set("lantern_position", screen_position)
