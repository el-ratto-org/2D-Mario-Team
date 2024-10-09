extends Node2D

@onready var children = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0,self.get_child_count()):
		children.append(self.get_child(i))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug"):
		mute_all()
	
func mute_all():
	for i in children:
		i.stream_paused = not i.stream_paused
