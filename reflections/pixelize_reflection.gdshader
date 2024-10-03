shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture;

uniform int NumDivisions = 180;

void fragment() {
	float aspect = SCREEN_PIXEL_SIZE.x / SCREEN_PIXEL_SIZE.y;
	vec2 st = (vec2(ivec2( SCREEN_UV * vec2(float(NumDivisions), float(NumDivisions)) ))+0.5)/float(NumDivisions);
	vec4 tex_col = textureLod(screen_texture, st, 0);
	COLOR = tex_col;
}