shader_type canvas_item;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
    float size = TEXTURE_PIXEL_SIZE.x;
    // An outline pixel will be drawn if ANY of the four, cross-neighbors is non-transparent
	float nei_alpha = texture(TEXTURE, UV + vec2(size, 0)).a
					+ texture(TEXTURE, UV - vec2(size, 0)).a
				  	+ texture(TEXTURE, UV + vec2(0, size)).a
					+ texture(TEXTURE, UV - vec2(0, size)).a;
    
	// Outline if (neighbors have a non-trivial collective alpha) AND NOT (pixel is solid)
    float is_outline = step(0.001, nei_alpha) * (1.0 - step(0.001, tex_color.a));
    
    COLOR = mix(tex_color, vec4(1.0), is_outline);
}