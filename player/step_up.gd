extends Node2D

@export var target: CharacterBody2D
@export var auto_step_size: float = 3

@onready var bottom_left_ray: RayCast2D = $BottomLeft
@onready var bottom_right_ray: RayCast2D = $BottomRight
@onready var top_left_ray: RayCast2D = $TopLeft
@onready var top_right_ray: RayCast2D = $TopRight


func step_check(delta: float):
	# Determine which direction we're moving
	var horizontal_stride = target.velocity.x
	
	# Figure out which raycast to use
	var bottom_ray: RayCast2D = null
	var top_ray: RayCast2D = null
	
	# Depending on the direction we're moving,
	# we want to select the correct raycasts to
	# be checking
	if horizontal_stride < 0:
		# We're moving left, check the left side rays
		bottom_ray = bottom_left_ray
		top_ray = top_left_ray
	elif horizontal_stride > 0:
		# We're moving right, check the right side rays
		bottom_ray = bottom_right_ray
		top_ray = top_right_ray
	else:
		# We're not moving; so don't do anything,
		# and bail early
		return
	
	# If the bottom ray is not colliding,
	# then there's nothing to step on, so bail early
	if not bottom_ray.is_colliding():
		return
	
	# Determine where the bottom raycast is
	var bottom_point: Vector2 = bottom_ray.get_collision_point()
	var bottom_length: float = bottom_ray.global_position.distance_to(bottom_point)
	
	# Will we step into something?
	if bottom_length > abs(horizontal_stride * delta):
		return
	
	# Check if something is blocking it
	if top_ray.is_colliding():
		# Figure out how steep the step is
		var top_point: Vector2 = top_ray.get_collision_point()
		var step_size = bottom_ray.global_position.y - top_point.y
		
		if step_size <= auto_step_size:
			# Move player up and make sure they don't continue falling
			target.position.y -= step_size + 2
			target.velocity.y = min(target.velocity.y, 0)
