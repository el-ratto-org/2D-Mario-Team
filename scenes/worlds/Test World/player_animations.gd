extends AnimatedSprite2D

signal flip_sprite(flip: bool)

const FLYING_EPSILON: float = 0.01


func _process(delta: float) -> void:
	# Figure out which way the player is intending to move
	var horizontal_axis = Input.get_axis("move_left", "move_right")
	
	# Check if the player is actually moving
	if abs(owner.velocity.x) == 0:
		# Player is stopped, don't show move
		horizontal_axis = 0
	else:
		# Check if we should flip the sprite
		var flip = owner.velocity.x < 0
		flip_h = flip
		flip_sprite.emit(flip)
	
	var on_floor = owner.is_on_floor()
	
	# Determine which animation to play
	if owner.slide.is_sliding():
		play("slide")
	elif not on_floor and (owner.velocity.y >= -FLYING_EPSILON or owner.flying.flying_amount > 0):
		play("fall")
	elif not on_floor and owner.velocity.y < 0:
		play("jump")
	elif on_floor and (horizontal_axis > 0 or horizontal_axis < 0):
		play("run")
	else:
		# No animation was viable, play idle instead
		play("idle")
