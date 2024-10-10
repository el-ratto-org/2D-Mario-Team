shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float surface_y;  // The Y position of the water surface (in screen coordinates)
uniform float reflection_strength : hint_range(0.0, 1.0) = 0.5; // How strong the reflection is

vec2 ripple_offset(vec2 uv) {
	float ripple = sin(uv.y * 128.0 - TIME * 4.0);
	ripple = step(ripple, 0) / 512.0;
	return vec2(ripple, step(cos(uv.x * 128.0 - TIME * 4.0), 0) / 512.0);
}

void fragment() {
	float blur = smoothstep(0, 1, UV.y) * 16.0;
	vec4 reflected_color = texture(screen_texture, vec2(SCREEN_UV.x, surface_y - UV.y) + ripple_offset(UV), blur);
	vec4 original_color = texture(screen_texture, SCREEN_UV);

	COLOR = mix(original_color, reflected_color, reflection_strength);
}
