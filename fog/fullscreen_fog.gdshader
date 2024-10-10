shader_type canvas_item;

#include "fog_util.gdshaderinc"

global uniform vec2 lantern_position;
global uniform float lantern_radius;
global uniform float lantern_opacity;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 col = texture(screen_texture, SCREEN_UV);
	vec2 aspect = calculate_aspect(1.0 / SCREEN_PIXEL_SIZE);
	float weight = linear_weight(distance(SCREEN_UV * aspect, lantern_position * aspect), 0.0 * lantern_radius, 0.5 * lantern_radius);
	float interpolated = circular_smooth(weight, 1.1);
	COLOR = mix(col, mix(col, col * vec4(0.2, 0.2, 0.2, 1), (interpolated + rand(SCREEN_UV) * 0.05)), lantern_opacity);
}