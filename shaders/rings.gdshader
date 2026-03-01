shader_type canvas_item;

uniform vec2 circle_position = vec2(0.5);

uniform vec3 background_color : source_color = vec3(0.05, 0.5, 0.9);
uniform vec3 secondary_color : source_color = vec3(0.0, 0.5, 1.0);

uniform float ring_density : hint_range(1.0, 50.0) = 10.0;
uniform float ring_speed : hint_range(-5.0, 5.0) = 2.0;

void fragment() {
	float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;

	// Aspect dependant distance of pixel from center of vortex. Defined in pixels.
	float dist = length((SCREEN_UV - circle_position) * vec2(aspect, 1.0));
    
	// Why are we multiplying? Think of the pigeonhole principle. You're stretching out the range,
	// but the segments of the normalized [0, 1] buckets considered by fract() remain intact.
	// Critically, dist is *continuous*.  It's like stretching a jelly all the way to [0, 50], 
	// cutting it into segments of [0, 1], [1, 2], [2, 3] etc. Place these segments vertical one 
	// on top of the other. Look from above and see that the color biases are naturally formed.
	//  We shift by a time-dependent quantity to emulate 'movement'.
	float color_bias = fract(dist * ring_density - TIME * ring_speed);
    vec3 final_color = mix(background_color, secondary_color, color_bias);
    
    COLOR = vec4(final_color, 1.0);
}