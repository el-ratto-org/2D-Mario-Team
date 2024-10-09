extends Control

@export var freeze_frame_texture: Texture2D
var freeze_frame_visible: bool = false

func _input(event):
	pass
	# Check for the input to trigger the freeze-frame
	#if Input.is_action_just_pressed("debug"):
		#freeze_frame()

func freeze_frame():
	# Pause the game
	get_tree().paused = true

	# Capture the current frame
	var viewport = get_viewport()
	var image = viewport.get_texture().get_image()   # Capture the current texture
	freeze_frame_texture = ImageTexture.new()
	freeze_frame_texture.create_from_image(image)

	freeze_frame_visible = true

func _draw():
	if freeze_frame_visible and freeze_frame_texture:
		# Draw the freeze frame texture
		draw_texture(freeze_frame_texture, Vector2.ZERO)

func unfreeze_frame():
	# Unpause the game
	get_tree().paused = false
	freeze_frame_visible = false
