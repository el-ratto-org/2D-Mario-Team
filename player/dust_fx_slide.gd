extends Node2D

# Preloaded scenes
var animated_sprite_scene = preload("res://assets/fx/dust_fx.tscn")

# Desired dust animations that exist in the dust_fx.tscn scene
var anim_type = ["slide_fx_1", "slide_fx_2", "slide_fx_3", "slide_fx_4"]
# Flipping state for mirroring depending on player facing direction
var sprite_flip = false

# Get timer starting duration
@onready var default_max_dust_spawn_freq = $SlideDustTimer.wait_time

# Main loop, checking if dust should be emitting
func _process(delta: float) -> void:
	if start_slide_timer_condition_met():
		$SlideDustTimer.wait_time = set_timer_duration()
		$SlideDustTimer.start()

# Slow dust emission rate over slide duration
func set_timer_duration():
	# Gather timing durations from the movement slide timer, and normalize
	var max_slide_time = $"../Movement/Slide/SlideTimer".wait_time
	var remaining_slide_time = $"../Movement/Slide/SlideTimer".time_left
	
	# Get a 0-1 value of the progress of the slide
	var normalized_remaining_slide = 1- (remaining_slide_time) / (max_slide_time) 

	# Gather timing durations from the dust timers
	var max_dust_spawn_freq = $SlideDustTimer.wait_time
	
	# A cool curve that feels nice
	var magic_formula = max_dust_spawn_freq + (normalized_remaining_slide**4)/1.4
	return magic_formula

# Return true if the timer runs out and the player is currently sliding
func start_slide_timer_condition_met():
	return  $SlideDustTimer.time_left == 0 and \
			owner.slide.is_sliding()

# When the dust fx timer runs out, spawn a dust particle
func _on_slide_dust_timer_timeout() -> void:
	spawn_vfx(anim_type, global_position)

# When the movement script first activates slide, reset the fx slide timer to the default max duration
func _on_slide_start_slide() -> void:
	$SlideDustTimer.wait_time = default_max_dust_spawn_freq
	
# Spawn dust
func spawn_vfx(animation_name, position):
	# Depending on player velocity, flip the dust sprite 
	# TODO UPDATE THIS TO BE UNIFORM ACROSS ALL FX
	if owner.velocity.x < -100:
		sprite_flip = true
	else:
		sprite_flip = false
		
	# Load dust scene, set postion to the players position with a subtle vertical random offset added
	var new_sprite = animated_sprite_scene.instantiate() as AnimatedSprite2D
	var random_range = 5.0
	var random_float = randf_range(-random_range, random_range)
	var new_position = Vector2(position.x, position.y + random_float)
	new_sprite.global_position = new_position
	
	# Pick dust fx, play, and apply flip defined earlier
	new_sprite.animation = animation_name.pick_random()
	new_sprite.play()
	new_sprite.flip_h = sprite_flip
	
	# Add fx into scene
	get_tree().root.add_child(new_sprite)
