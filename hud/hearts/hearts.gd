extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#PlayerStatsManager.health
	%health_container.material.set_shader_parameter("fill_per", PlayerStatsManager.player_health)
