extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.text = "NULL"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.text = ("Jump grace time : " + (str( $"..".jump_grace_time).pad_decimals(3)))
	#self.text = ("velocity X : " + (str( $"..".velocity.x).pad_decimals(1)))
	#self.text = ("velocity Y : " + (str( $"..".velocity.y).pad_decimals(1)))
	#self.text = ("current_move : " + (str( $"..".current_move).pad_decimals(10)))
	
	pass
