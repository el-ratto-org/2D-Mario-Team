extends AnimatedSprite2D

signal flip_sprite(flip: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func switch_animation(anim_name):
	self.play(anim_name)
	
func _process(delta: float) -> void:
	if owner.is_sliding == true:
		switch_animation("slide")
	elif owner.velocity.y > 0:
		switch_animation("fall")
	elif owner.velocity.y < 0:
		switch_animation("jump")
	elif owner.velocity.x > 0 or owner.velocity.x < 0:
		switch_animation("run")
	else:
		switch_animation("idle")
		
	# Flip sprite
	var player_x_velocity = owner.velocity.x
	var flip = player_x_velocity < 0
	
	# If player is moving
	if player_x_velocity != 0:
		flip_h = flip
		flip_sprite.emit(flip)
