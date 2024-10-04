extends AnimatedSprite2D

func switch_animation(anim_name):
	self.play(anim_name)
	
func _process(delta: float) -> void:
	if owner.velocity.y > 0:
		switch_animation("fall")
	elif owner.velocity.y < 0:
		switch_animation("jump")
	elif owner.velocity.x > 0 or owner.velocity.x < 0:
		switch_animation("run")
	else:
		switch_animation("idle")
	
	if owner.velocity.x < 0:
		flip_h = true
	if owner.velocity.x > 0:
		flip_h = false
