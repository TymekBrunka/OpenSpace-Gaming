shader_type canvas_item;

// --- Uniforms --- //
uniform sampler2D screen_texture:hint_screen_texture, repeat_disable, filter_nearest;
const float pixel_size = 2.0;

// --- Functions --- //
void fragment() {
	const vec2 resolution = 1.0 / SCREEN_PIXEL_SIZE / pixel_size;
	COLOR = texture(screen_texture, ( ( round(SCREEN_UV * resolution) ) / resolution) );
}