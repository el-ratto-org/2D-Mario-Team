extends AnimatedSprite2D


## Function to spawn an instance of AnimatedSprite2D and play the specified animation
func spawn_vfx(animation_name: String) -> void:
	# Create a new AnimatedSprite2D instance
	var new_sprite = AnimatedSprite2D.new()
	
	# Set properties for the new sprite instance
	new_sprite.sprite_frames = sprite_frames
	
	# Check if the animation exists
	assert(new_sprite.sprite_frames.has_animation(animation_name), "No animation found")
	
	# We've ensured the animation exists,
	# now setup the sprite and play its animation
	new_sprite.global_position = global_position
	new_sprite.animation = animation_name
	new_sprite.play()
	
	# Check if the callable is valid
	var callable = Callable(new_sprite, "_on_animation_finished")
	assert(callable.is_valid(), "Callable is not valid! Check method and target object")

	# Connect the 'animation_finished' signal to the new instance's '_on_animation_finished' function
	var connection_result = new_sprite.connect("animation_finished", callable)
	
	# Add the new sprite to the scene tree (to the root node, or adjust as needed)
	get_tree().root.add_child(new_sprite)


## Function to be called when the animation finishes
func _on_animation_finished() -> void:
	queue_free()  # Remove the node from the scene tree
