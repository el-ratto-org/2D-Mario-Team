extends Node2D

var wasp
var FLIP_THRESHOLD = 20

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	wasp = get_parent().get_parent().get_node("AnimatedSprite2D")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var distance_to_player = PlayerManager.player.global_position.x - global_position.x
	
	if abs(distance_to_player) >= FLIP_THRESHOLD:  # Only flip if the player is outside the threshold
		if distance_to_player > 0:
			wasp.scale.x = -1  # Face right
		else:
			wasp.scale.x = 1  # Face left
