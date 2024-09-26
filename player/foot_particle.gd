extends AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_vfx("jump_angle")

# Function to spawn an instance of AnimatedSprite2D and play the specified animation
func spawn_vfx(animation_name: String) -> void:
	var position = self.global_position  # Correctly use self's global position
	
	# Create a new AnimatedSprite2D instance
	var new_sprite = AnimatedSprite2D.new()
	
	# Set properties for the new sprite instance
	new_sprite.sprite_frames = self.sprite_frames
	
	# Check if the animation exists and get its frame count
	if new_sprite.sprite_frames.has_animation(animation_name):
		print("Animation found. Frame count: ", new_sprite.sprite_frames.get_frame_count(animation_name))
	else:
		print("Animation not found!")
		return

	new_sprite.global_position = position
	new_sprite.animation = animation_name
	new_sprite.play()
	
	# Check if the callable is valid
	var callable = Callable(new_sprite, "_on_animation_finished")
	print("Is Callable valid?", callable.is_valid())  # Should print true

	if not callable.is_valid():
		print("Callable is not valid! Check method and target object.")
		return

	# Connect the 'animation_finished' signal to the new instance's '_on_animation_finished' function
	var connection_result = new_sprite.connect("animation_finished", callable)
	print("Signal connection result:", connection_result)  # Should print 0 (OK)
	
	# Add the new sprite to the scene tree (to the root node, or adjust as needed)
	get_tree().root.add_child(new_sprite)
	print("New sprite added to the scene.")

	# Function to be called when the animation finishes
func _on_animation_finished() -> void:
	print("Animation finished. Removing node: ", self)
	queue_free()  # Remove the node from the scene tree
