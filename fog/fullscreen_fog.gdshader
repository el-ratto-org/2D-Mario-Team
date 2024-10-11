shader_type canvas_item;

#include "fog_util.gdshaderinc"

global uniform vec2 lantern_position;
global uniform float lantern_radius;
global uniform float lantern_opacity;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 col = texture(screen_texture, SCREEN_UV);
	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	float weight = linear_weight(distance(SCREEN_UV * vec2(1, aspect), lantern_position * vec2(1, aspect)), 0.0 * lantern_radius, 0.4 * lantern_radius);
	float interpolated = circular_smooth(weight, 1.1);
    COLOR = mix(col, mix(col, col * vec4(0.4, 0.4, 0.4, 1), (interpolated + rand(SCREEN_UV) * 0.05)), lantern_opacity);
}