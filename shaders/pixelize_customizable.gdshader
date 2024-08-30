shader_type canvas_item;

// --- Uniforms --- //
uniform float pixel_size = 4.0;

// --- Functions --- //
void fragment() {
	vec2 resolution = 1.0 / TEXTURE_PIXEL_SIZE / pixel_size;
	COLOR = texture(TEXTURE, ( ( round(UV * resolution) + (1.0/resolution/0.5) ) / resolution) );
}