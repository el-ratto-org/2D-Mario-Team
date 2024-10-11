extends Node2D
var idle_mode = true




func _on_hurtbox_idle_area_entered(area: Area2D) -> void:
	if idle_mode == true:
		print("hit idle mode")
	pass # Replace with function body.


func _on_hurtbox_swoop_area_entered(area: Area2D) -> void:
	if idle_mode == false:
		print("hit swoop mode")
	pass # Replace with function body.


func _on_mode_switch_timeout() -> void:
	if idle_mode == true:
		$AnimatedSprite2D.play("swoop")
		idle_mode = false
	else:
		$AnimatedSprite2D.play("idle")
		idle_mode = true
	pass # Replace with function body.
