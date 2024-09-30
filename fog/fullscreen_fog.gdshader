shader_type canvas_item;

#include "fog_util.gdshaderinc"

global uniform vec2 lantern_position;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec4 col = texture(screen_texture, SCREEN_UV);
	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	float weight = linear_weight(distance(SCREEN_UV * vec2(1, aspect), lantern_position * vec2(1, aspect)), 0.1, 0.4);
	float interpolated = circular_smooth(weight, 1.5);
    COLOR = mix(col, col * vec4(0.7, 0.7, 0.7, 1), interpolated + rand(SCREEN_UV) * 0.05);
}