extends Control


func _process(delta: float) -> void:
	%health_container.material.set_shader_parameter("fill_per", PlayerManager.player.health.current)
