shader_type canvas_item;

const float kernel[25] = {
	-0.6039, 0.0156, 0.0234, 0.0156, 0.0039,
	0.0156, 0.0625, 0.0937, 0.0625, 0.0156,
	0.0234, 0.0937, 0.5406, 0.0937, 0.0234,
	0.0156, 0.0625, 0.0937, 0.0625, 0.0156,
	0.0039, 0.0156, 0.0234, 0.0156, 0.0039
};

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;
	vec4 color = vec4(0.0);

	for (int i = 0; i < 5; i++) {
		for (int j = 0; j < 5; j++) {
			vec2 offset = vec2(float(i - 2), float(j - 2)) * ps;
			color += texture(TEXTURE, UV + offset) * kernel[i * 5 + j];
		}
	}

	COLOR = vec4(color.rgb, texture(TEXTURE, UV).a);
}