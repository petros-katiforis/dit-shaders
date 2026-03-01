shader_type canvas_item;

uniform float speed : hint_range(0.1, 10.0, 0.1) = 2.0;
uniform float intensity : hint_range(0.0, 50.0, 0.1) = 10.0;

void vertex() {
	// MODEL_MATRIX: local space to world space transform
	// The third row will contain the translation (it's homogenous, remember)
	vec2 world_pos = MODEL_MATRIX[3].xy;

	// Create a unique time offset by combining the X and Y positions
	float time_offset = (world_pos.x * 0.1) + (world_pos.y * 0.1);
	float wave = sin(TIME * speed + time_offset);

	// We'd like it so that points of a considerable height relative to the object's origin
	// are more shaky compared to the ground. UV.y is maximazied at the bottomand minimized at the top
	// We request the square of that number so that it feels more natural
	float weight = pow(1.0 - UV.y, 2.0);

	VERTEX.x += wave * intensity * weight;
}