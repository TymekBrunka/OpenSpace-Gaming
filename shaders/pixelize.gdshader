shader_type canvas_item;

// --- Uniforms --- //
const float resolution = 16.0;

// --- Functions --- //
void fragment() {
	COLOR = texture(TEXTURE, round(UV * (resolution + 1.0) - (UV - 0.5)) / (resolution + 1.0));
}