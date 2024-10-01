shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture;

uniform float surface_y;  // The Y position of the water surface (in screen coordinates)
uniform float reflection_strength : hint_range(0.0, 1.0) = 0.5; // How strong the reflection is

void fragment() {
    vec4 reflected_color = texture(screen_texture, vec2(SCREEN_UV.x, surface_y - UV.y));
    vec4 original_color = texture(screen_texture, SCREEN_UV);
    COLOR = mix(original_color, reflected_color, reflection_strength);
}
