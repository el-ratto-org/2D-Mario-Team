extends Node

var player
var caption_manager


func play_caption(caption: String) -> void:
	if caption == 'death':
		caption_manager.death()
	elif caption == 'lit':
		caption_manager.lit()
	elif caption == 'feather':
		caption_manager.feather()
	elif caption == 'cloak':
		caption_manager.cloak()
