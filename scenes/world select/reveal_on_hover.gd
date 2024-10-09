extends Control


@onready var selected = false
@onready var parent = get_parent()
@onready var sprite = parent.get_child(0)

func _on_Panel_mouse_entered():
	sprite.visible = true  # Enable or show the layer

# When the mouse exits the specific area
func _on_Panel_mouse_exited():
	if selected:
		pass
	else:
		sprite.visible = false  # Hide or disable the layer

func _on_Panel_gui_input(event):
	# Check if the event is a left mouse button click
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Toggle the visibility of the CanvasLayer
		if selected:
			sprite.visible = false
		else:
			sprite.visible = true
		selected = not selected
