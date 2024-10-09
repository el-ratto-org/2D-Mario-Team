shader_type canvas_item;

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
	vec4 sampled = texture(TEXTURE, UV);
	
	// Calculate brightness using Rec. 709 luma coefficients
	float brightness = dot(sampled.rgb, vec3(0.2126, 0.7152, 0.0722));
	
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
	COLOR = vec4(selected_color, sampled.a);
}
