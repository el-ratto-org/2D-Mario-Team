extends Area2D

signal damage_recieved(damage: float)

func _ready() -> void:
	connect("area_entered", _on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	# Assert will cause an error if the area doesn't have a damage component 
	assert(area.get("damage") != null, "No damage on hitbox that %s hurtbox receieved" % owner.name)
	damage_recieved.emit(area.damage)
