extends AnimatedSprite2D

signal wing_fx(in_light:bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	prime_wings()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func uncurl_wings():
	play("uncurl")

func prime_wings():
	play("uncurl")
	stop()

func _on_animation_finished() -> void:
	play("loop")
	pass # Replace with function body.


func _on_animated_sprite_2d_flip_sprite(flip_value) -> void:
	flip_h = flip_value

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("Lantern"):
		uncurl_wings()
		wing_fx.emit(true)


func _on_hurt_box_area_exited(area: Area2D) -> void:
	prime_wings()
	wing_fx.emit(false)


func _on_lantern_detection_area_entered(area: Area2D) -> void:
	uncurl_wings()
	wing_fx.emit(true)


func _on_lantern_detection_area_exited(area: Area2D) -> void:
	prime_wings()
	wing_fx.emit(false)
