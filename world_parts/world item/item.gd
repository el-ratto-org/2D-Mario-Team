extends CharacterBody2D

var fall_speed_modifier = 0.1
var gravity = 100

# Exported variable for item type selection
@export var item_type: PackedScene
#@export var item_sprite: Sprite2D

func _ready():
	var item_instance = item_type.instantiate()
	add_child(item_instance)  # Add the sprite to the current scene

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# Apply gravity
	self.velocity.y += gravity * delta * fall_speed_modifier
	
	# Reset velocity if on the floor to prevent continuous fall
	if is_on_floor():
		velocity.y = 0
		
	move_and_slide()
