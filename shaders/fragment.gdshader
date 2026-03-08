shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.

	// The y-axis grows downwards and starts from the top-left corner
	// VERTEX.xy is described in pixels and is relative to the object's origin (offset).
	VERTEX.x += VERTEX.y * sin(2.0 * PI * 0.5 * TIME);
}

void fragment() {
	// Called for every pixel the material is visible on.
	COLOR = vec4(UV.x, UV.y, 0.0, 1.0);
}
