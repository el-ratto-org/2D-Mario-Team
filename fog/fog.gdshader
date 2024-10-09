shader_type canvas_item;
render_mode blend_mix;

#include "fog_util.gdshaderinc"

global uniform vec2 lantern_position;
global uniform float lantern_radius;
global uniform float lantern_opacity;

varying vec4 modulate;

void vertex() {
	modulate = COLOR;
}

void fragment() {
	vec4 first = texture(TEXTURE, UV);
	vec4 second = texture(TEXTURE, UV + vec2(0, .5));

	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	float weight = linear_weight(distance(SCREEN_UV * vec2(1, aspect), lantern_position * vec2(1, aspect)), 0.1 * lantern_radius, 0.4 * lantern_radius);
	float interpolated = circular_smooth(weight, 3.0);
	COLOR = mix(second, first, interpolated) * modulate;
	//COLOR = mix(first, mix(second, first, interpolated), lantern_opacity);
}
