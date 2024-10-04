extends Node


var player
var player_position
var caption_manager
var player_health

@onready var has_double_jump_item = false
@onready var has_dash_item = false
@onready var has_sword_item = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _set_player_position(position: Vector2) -> void:
	player_position = position

func _get_player_position() -> Vector2:
	return player_position
	
func play_caption(caption: String) -> void:
	if caption == 'death':
		caption_manager.death()
	elif caption == 'feather':
		caption_manager.feather()
	elif caption == 'cloak':
		caption_manager.cloak()
	
func get_hp() -> int:
	print ("get_hp may be a stub, be warned!")
	return player_health
	
	#code not needed below?
#func player_can_double_jump() -> bool:
	#return has_double_jump_item
	#
#func player_can_dash() -> bool:
	#return has_dash_item
	#
#func player_can_sword() -> bool:
	#return has_sword_item
