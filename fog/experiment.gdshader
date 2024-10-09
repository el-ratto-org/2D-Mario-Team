shader_type canvas_item;

#include "fog_util.gdshaderinc"

// Lantern blending uniforms (from shader 1)
global uniform vec2 lantern_position;
global uniform float lantern_radius;
global uniform float lantern_opacity;

// Frame-based color cycling uniforms (from shader 2)
uniform int start_frame = 0;
uniform int current_frame = 0;
uniform float mix_ratio = 0.0;

const vec3 colors[6] = vec3[] (
	vec3(1.0, 0.0, 0.0), // Red
	vec3(0.5, 0.0, 0.0), // Dark red
	vec3(0.0, 0.0, 0.0), // Black
	vec3(0.0, 0.0, 1.0), // Blue
	vec3(0.0, 0.0, 0.5), // Dark blue
	vec3(0.0, 0.0, 0.0)  // Black
);

void fragment() {
	// Part 1: Lantern blending
	vec4 first = texture(TEXTURE, UV);
	vec4 second = texture(TEXTURE, UV + vec2(0, .5));

	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	float weight = linear_weight(distance(SCREEN_UV * vec2(1, aspect), lantern_position * vec2(1, aspect)), 0.1 * lantern_radius, 0.4 * lantern_radius);
	float interpolated = circular_smooth(weight, 3.0);
	vec4 lantern_mix = mix(second, first, interpolated);

	// Part 2: Frame-based color modification
	// Calculate brightness using Rec. 709 luma coefficients
	float brightness = dot(lantern_mix.rgb, vec3(0.2126, 0.7152, 0.0722));

	// Determine color offset based on brightness
	int offset = 0;
	if (brightness > 0.75) {
		offset = 2;
	} else if (brightness > 0.25) {
		offset = 1;
	}

	// Select color based on current frame and offset
	int color_index = (start_frame + current_frame + offset) % colors.length();
	vec3 selected_color = colors[color_index];

	// Apply the selected color to the final lantern-blended texture
	COLOR = vec4(mix(lantern_mix.rgb, selected_color, mix_ratio), lantern_mix.a);
}
