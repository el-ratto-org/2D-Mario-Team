extends StaticBody2D

enum state
{
	inactive,
	active,
}

@export var activation_status : state 
@export var world : String

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

func change_state(turning_on: bool):
	var turn_off = null
	var turn_on = null
	
	if activation_status == state.active:
		turning_on = false
		_turn_on()
	else:
		turning_on = true
		_turn_off()
	
	
	return turning_on

func _turn_on():
		var turn_on = $Active
		var turn_off = $Inactive
		activation_status = state.inactive
		
		## change spawn point
		
		#sprites
		turn_on.hide()
		turn_off.show() 
	
func _turn_off():
		var turn_on = $Inactive
		var turn_off = $Active
		activation_status = state.active
		
		#sprites
		turn_on.hide()
		turn_off.show() 



func _on_activation_area_area_entered(area: Area2D) -> void:
	#var is_turning_on = false
	#if area.name == "HitBox":
		#if change_state(is_turning_on): ## << old
			#%caption_manager.lit()
			
	#assert(area.name == "HitBox", "non player touched lamp, layers wrong")
	if activation_status != state.active:
		_turn_off()
		PlayerManager.play_caption("lit")
		var lantern = self.get_child(0)
		lantern.set_active(true)
		WorldManager.worlds[world]["Checkpoint"] = self.global_position
		print(WorldManager.worlds[world]["Checkpoint"])
