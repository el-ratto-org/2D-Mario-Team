extends Node

var player
var caption_manager

@onready var has_double_jump_item = false
@onready var has_dash_item = false
@onready var has_sword_item = false


func play_caption(caption: String) -> void:
	if caption == 'death':
		caption_manager.death()
	elif caption == 'feather':
		caption_manager.feather()
	elif caption == 'cloak':
		caption_manager.cloak()
