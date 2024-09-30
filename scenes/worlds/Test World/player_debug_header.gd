extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "NULL"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#self.text = ("velocity X : " + (str( $"../PlayerMovementController".character.velocity.x).pad_decimals(1)))
	self.text = (" : " + str($"../DustFX".recent_ground_location))
	
	pass
