extends AnimatedSprite2D
@onready var player_movement_controller = $"../PlayerMovementController"

signal flip_sprite(flip: bool)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func switch_animation(anim_name):
	self.play(anim_name)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player_movement_controller.character.velocity.y > 0:
		switch_animation("fall")
	elif player_movement_controller.character.velocity.y < 0:
		switch_animation("jump")
	elif player_movement_controller.character.velocity.x > 0 or player_movement_controller.character.velocity.x < 0:
		switch_animation("run")
	else:
		switch_animation("idle")
		
		
	# Flip sprite
	var player_x_velocity = player_movement_controller.character.velocity.x
	
	# if player is moving
	if player_x_velocity != 0:
		var flip = player_x_velocity < 0
		flip_h = flip
		flip_sprite.emit(flip)
