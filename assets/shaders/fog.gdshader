shader_type canvas_item;
//render_mode unshaded; // optional

// Noise texture
uniform sampler2D noise_texture: repeat_enable, filter_nearest;
// Fog density
uniform float density: hint_range(0.0, 1.0) = 0.25;
// Fog speed
uniform vec2 speed = vec2(0.02, 0.01);
// Pixelation factor
uniform float pixelation_size: hint_range(1.0, 64.0) = 128.0; // Lower value = more pixelated

// Called for every pixel the material is visible on
void fragment() {
	// Make the fog slowly move
	vec2 uv = UV + speed * TIME;
	
	// Apply pixelation effect by snapping UV coordinates to a grid
	vec2 pixelated_uv = floor(uv * pixelation_size) / pixelation_size;

	// Sample the noise texture at pixelated UV coordinates
	float noise = texture(noise_texture, pixelated_uv).r;

	// Convert the noise from the (0.0, 1.0) range to the (-1.0, 1.0) range
	// and clamp it between 0.0 and 1.0 again
	float fog = clamp(noise * 2.0 - 1.0, 0.0, 1.0);

	// Apply the fog effect
	COLOR.a *= fog * density;
}
