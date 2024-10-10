shader_type canvas_item;

uniform float size : hint_range(0.0, 6.0);
uniform float width : hint_range(0.0, 6.0);

uniform float screen_width;
uniform float screen_height;

uniform sampler2D noise_tex;

uniform vec4 brighter_color = vec4(1.0, 0.8, 0.0, 1.0);
uniform vec4 middle_color  = vec4(1.0, 0.56, 0.0, 1.0);
uniform vec4 darker_color  = vec4(0.64, 0.2, 0.05, 1.0);

uniform float spread : hint_range(0.0, 1.0) = 0.5;
uniform vec2 player_position;
uniform int pixel_amount = 40;

void fragment() {
	vec2 grid_uv = round(UV * float(pixel_amount)) / float(pixel_amount);

	float ratio = screen_width / screen_height;
	float dist = distance(player_position, vec2(mix(0.5, grid_uv.x, ratio), grid_uv.y));

	float noise_value = texture(noise_tex, dist + vec2(0.0, TIME)).x;
	// The .yx swizzle is when using the built in horizontal gradient texture. If you have a vertical gradient texture remove .yx
	float gradient_value=1.0;

	gradient_value -= smoothstep(spread, spread + 0.5, length(dist + vec2(-.5)) / spread);

	float step1 = step(noise_value, gradient_value);
	float step2 = step(noise_value, gradient_value - 0.2);
	float step3 = step(noise_value, gradient_value - 0.4);

	vec3 bd_color = mix(brighter_color.rgb, darker_color.rgb, step1 - step2);

	vec4 color = vec4(bd_color, step1);
	color.rgb = mix(color.rgb, middle_color.rgb, step2 - step3);
	COLOR = color;
	COLOR.a = 0.0;

	float d = dist;
	float h = size * 0.5;
	float l = h - (width * 0.5);
	if (d <= h && d > l) {

		COLOR.a = color.a;
		COLOR.rgb = color.rgb;
	}

}