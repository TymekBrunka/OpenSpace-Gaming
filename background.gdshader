shader_type canvas_item;

uniform sampler2D bg1;
uniform sampler2D bg2;
uniform sampler2D bg3;
uniform sampler2D bg4;
uniform vec2 player_position;

uniform float scale = 1;

varying vec2 tile_uv;

void vertex() {
	// Called for every vertex the material is visible on.
}

vec4 debug(vec2 val, vec4 color, float ofs){
	if (val.x >= (ofs + -0.1) && val.x <= (ofs + 0.1) && val.y >= (ofs + -0.1) && val.y <= (ofs + 0.1)){
		return color;	
	}
	return texture(bg1, tile_uv / scale);
}

vec2 wta(vec2 vec){
	return vec2(vec.x > 0. ? mod(vec.x, 1) : 1. - mod(vec.x, 1),
				vec.y > 0. ? mod(vec.y, 1) : 1. - mod(vec.y, 1));
}

void fragment() {
	// Called for every pixel the material is visible on.
	//vec2 var = vec2(textureSize(TEXTURE, 1)) / vec2(textureSize(bg1, 1));
	vec2 ppos = vec2(0.8);
	tile_uv = mod(UV, vec2(textureSize(bg1, 1)) * TEXTURE_PIXEL_SIZE / 0.5 * scale);
	//vec2 ppos = player_position * SCREEN_PIXEL_SIZE;
	//vec2 poz = (UV / vec2(textureSize(bg1, 1)) * TEXTURE_PIXEL_SIZE / 0.5) - tile_uv;
	COLOR = texture(bg1, tile_uv);
	
	//COLOR = debug(UV, vec4(1,1,1,1), 2);
	//COLOR = texture(TEXTURE, UV);
	if (floor(UV / scale) == vec2(2.)){
		COLOR = texture(bg4, tile_uv / scale);
	}
}
