extends StaticBody2D

@onready var collision = $CollisionShape2D

var colliders = 0


func _physics_process(delta: float) -> void:
	collision.set_deferred("disabled", Input.is_action_pressed("move_down") and colliders > 0)


func _on_area_2d_body_entered(body: Node2D) -> void:
	colliders += 1


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliders -= 1
