shader_type canvas_item;

uniform vec2 player_position;

float linear_weight(float dist, float start, float end) {
	//  ⎧            x-S⎫
	//  ⎨x<S:0,x>E:1,───⎬
	//  ⎩            E-S⎭
	// where x=dist, S=start, E=end
	return min(max((dist - start) / (end - start), 0), 1); // rewritten the piecewise into min/max
}

float circular_smooth(float dist, float smoothing) {
	// Simple value clamping
	if (dist < 0.0) return 0.0;
	if (dist > 1.0) return 1.0;
	
	//      2ʲ
	//  (2x)
	//  ────
	//   2
	// where x=dist, j=smoothing
	if (dist < 0.5) return pow(2.0 * dist, pow(2.0, smoothing)) / 2.0;
	
	//          2ʲ
	//  2-(2-2x)
	//  ──────────
	//      2
	// where x=dist, j=smoothing
	return (2.0 - pow(2.0 - 2.0 * dist, pow(2.0, smoothing))) / 2.0;
}

void fragment() {
	vec4 first = texture(TEXTURE, UV);
	vec4 second = texture(TEXTURE, UV + vec2(0, .5));
	//first = vec4(1);
	//second = vec4(0, 0, 0, 1);
	//vec4 second = vec4(1, 0, 1, 1);
	
	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	float weight = linear_weight(distance(SCREEN_UV * vec2(1, aspect), player_position * vec2(1, aspect)), 0.1, 0.2);
	float interpolated = circular_smooth(weight, 2.0);
	COLOR = mix(second, first, interpolated);
}
