extends Node

@export var movement_controller: PlayerMovementController
@onready var inventory = $Inventory

# Movement variables
var horizontal_axis

var dashing = false

var vertical_dictionary: Dictionary = {
	"move_up_pressed": false,
	"move_up_released": false,
	"move_up_held": false,
	"move_down_pressed": false,
	"move_down_released": false,
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerStatsManager.player = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	_get_input(delta)
	
	if movement_controller != null:
		_process_movement(delta)
	

func _get_input(delta: float) -> void:
	horizontal_axis = Input.get_axis("move_left", "move_right")
	
	if Input.is_action_just_pressed("dash") and dashing == false:
		dashing = true
	else: # collect inputs if not dashing
		if Input.is_action_just_pressed("move_up"):
			vertical_dictionary["move_up_pressed"] = true
			vertical_dictionary["move_up_held"] = true;
		else:
			vertical_dictionary["move_up_pressed"] = false
				
		if Input.is_action_just_released("move_up"):
			vertical_dictionary["move_up_released"] = true
			vertical_dictionary["move_up_held"] = false;
		else:
			vertical_dictionary["move_up_released"] = false
		
		if Input.is_action_just_pressed("move_down"):
			vertical_dictionary["move_down_pressed"] = true
		else:
			vertical_dictionary["move_down_pressed"] = false
		
		if Input.is_action_just_released("move_down"):
			vertical_dictionary["move_down_released"] = true
		else:
			vertical_dictionary["move_down_released"] = false

	

func _process_movement(delta: float) -> void:
	movement_controller._set_input(horizontal_axis, vertical_dictionary)
	
func get_inventory():
	return inventory

func player_bounced() -> void:
	movement_controller.jump()

func _on_health_component_take_damage() -> void:
	print("Player was hit")
