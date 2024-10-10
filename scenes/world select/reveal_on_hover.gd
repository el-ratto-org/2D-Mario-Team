extends Control


@onready var selected = false
@onready var parent = get_parent()
@onready var sprite = parent.get_child(0)
@export var world_name : String
var enabled : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(world_name in WorldManager.completion.keys(),("INVALID NAME FOR "+self.name))
	enabled = WorldManager.worlds[world_name]["completed"]
	if enabled:
		get_parent().mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	else:
		get_parent().mouse_default_cursor_shape = Control.CURSOR_FORBIDDEN
	

func _on_Panel_mouse_entered():
	if enabled:
		sprite.visible = true  # Enable or show the layer

# When the mouse exits the specific area
func _on_Panel_mouse_exited():
	if enabled:
		if selected:
			pass
		else:
			sprite.visible = false  # Hide or disable the layer

func _on_Panel_gui_input(event):
	if enabled:
		# Check if the event is a left mouse button click
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# Toggle the visibility of the CanvasLayer
			if selected:
				sprite.visible = false
				WorldManager.selected_level = null
				print(WorldManager.selected_level, " selected!")
			else:
				sprite.visible = true
				WorldManager.selected_level = world_name
				print(WorldManager.selected_level, " selected!")
			selected = not selected
