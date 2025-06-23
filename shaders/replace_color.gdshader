shader_type canvas_item;

group_uniforms palettes;
uniform sampler2D team_palette;
uniform sampler2D skin_palette;
group_uniforms selectors;
uniform int team_index;

// uncomment if in godot 4.4 or above
// uniform int skin_index : hint_enum("Light", "Medium", "Dark");
uniform int skin_index;


vec2 idx_to_uv(ivec2 idx, ivec2 tex_size) {
	return vec2(
		(float(idx.x) + 0.5) / float(tex_size.x), 
		(float(idx.y) + 0.5) / float(tex_size.y)
	);
}

vec4 get_palette_color(vec4 original_color, sampler2D palette, int selection) {
	ivec2 palette_size_2d = textureSize(palette,0);
	
	vec4 result_color = original_color;
		
	for (int i = 0; i < palette_size_2d.x; i++) {
		vec4 palette_reference_color = texture(palette, idx_to_uv(ivec2(i, 0), palette_size_2d));
		if (palette_reference_color == original_color) {
			result_color = texture(palette, idx_to_uv(ivec2(i, selection), palette_size_2d));
		}
	}
		
	return result_color;
}

void fragment() {
	COLOR = get_palette_color(COLOR, team_palette, team_index);
	
	// avoid doing color swap if light bc it's the default
	if (skin_index > 0) {
		COLOR = get_palette_color(COLOR, skin_palette, skin_index);
	}
}