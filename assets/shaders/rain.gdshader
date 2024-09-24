shader_type canvas_item;

uniform float time : hint_range(0, 100); // Time variable to animate the rain
uniform vec2 rain_direction = vec2(-0.5, -1.0); // Windy direction of the rain (streaky)
uniform float rain_speed = 300.0; // Speed of the rain falling
uniform float rain_density = 0.5; // Controls the density of raindrops
uniform float drop_length = 0.5; // Length of the raindrops
uniform float drop_width = 0.05; // Width of the raindrops
uniform vec4 rain_color = vec4(0.1, 0.2, 0.3, 0.6); // Dark, moody color for the raindrops

void fragment() {
    // Get the UV coordinates (screen coordinates)
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE;
    
    // Calculate rain position based on time and speed
    uv += rain_direction * time * rain_speed;

    // Create a random seed using the UV coordinates to vary raindrops
    float random_val = fract(sin(dot(uv * 10.0, vec2(12.9898, 78.233))) * 43758.5453);
    
    // Create streaky raindrop pattern (elongated lines)
    float drop = smoothstep(0.0, drop_length, random_val) * step(random_val, drop_width);
    
    // Apply a distortion effect to give a more realistic feel
    float distortion = sin(uv.y * 20.0 + time * 5.0) * 0.02;
    uv.x += distortion; // Distort the x coordinate for a streaky effect
    
    // Use the distorted UV to sample the base color
    vec4 base_color = texture(TEXTURE, uv);
    
    // Combine the base color with the rain color based on density
    COLOR = mix(base_color, rain_color, drop * rain_density);
}
