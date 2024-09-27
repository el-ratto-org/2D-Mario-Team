extends StaticBody2D

enum state
{
	inactive,
	active,
}

@export var activation_status : state 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var turn_off = null
	var turn_on = null
	
	if activation_status == state.inactive:
		turn_on = $Inactive
		turn_off = $Active
	else:
		turn_on = $Inactive
		turn_off = $Active

	turn_on.show() # Enable processing
	turn_off.hide() # Disable processing

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_state():
	var turn_off = null
	var turn_on = null
	
	if activation_status == state.active:
		print ("on -> off ", activation_status) 
		turn_on = $Active
		turn_off = $Inactive
		activation_status = state.inactive
	else:
		print ("off -> on ", activation_status) 
		turn_on = $Inactive
		turn_off = $Active
		activation_status = state.active

	turn_on.hide() # Enable processing
	turn_off.show() # Disable processing


func _on_activation_area_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		print ("lamp change state") 
		change_state()
