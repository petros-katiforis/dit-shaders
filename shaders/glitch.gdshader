shader_type canvas_item;

uniform float glitch_chance : hint_range(0.0, 1.0) = 0.2;
// Speed of glitch state changes
uniform float glitch_speed = 7.0;
uniform float slice_density = 14.0;
uniform float slice_strength = 0.38;
uniform float shake_strength = 0.02;
// Chromatic color separation amount
uniform float chroma_offset = 0.01;
uniform float noise_strength = 0.2;
uniform float color_flash_strength = 0.2;
uniform float local_warp_strength = 0.14;
uniform float flip_chance : hint_range(0.0,1.0) = 0.15;

// Both randomness algorithms are described here: https://thebookofshaders.com/10/
// There's nothing fancy about those numbers (except that 5453123 is easy to type)
// The number shall be large enough so that small variations in the input result
// in significant changes on the output (non-predictability)
//
// Conventional randomness algorithms are defined through persistent. mutating state
// That's just not possible on a GPU, parallelism is a bottleneck (requires synchronization)
// Regardless, memory access is depressingly slow
float rand(float x) {
	return fract(sin(x) * 43758.5453123);
}

float rand2(vec2 p) {
	// Pretty much the same, but we need to convert the 2D coordinates into an integer first
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment() {
	vec2 uv = UV;

	// This is the master switch. If it's zero, everything cancels out and the shader
	// is practically not applied. We use floor so that the animation is applied
	// in a granuality of seconds.
	float glitch = step(1.0 - glitch_chance, rand(floor(TIME * glitch_speed)));
	// Assign to each pixel a slice ID
	float slice_id = floor(uv.y * slice_density + rand(floor(TIME)));
	// Decide if the slice shall remain normal or glitch
	float slice_rand = rand(slice_id + floor(TIME * glitch_speed));
	float slice_mask = step(0.5, slice_rand) * glitch;

	// Randomly flip some slices horizontally
	if (rand(slice_id * TIME) < flip_chance) {
		uv.x = 1.0 - uv.x;
	}

	// Apply horizontal displacement if the slice is activated (slice_mask)
	// We use multiplication instead of if-statements. Zero is viral and collapsing
	uv.x += (slice_rand - 0.5) * slice_strength * slice_mask;

	// About 35% of slices will be locally warped
	float warp_zone = step(0.65, rand2(vec2(slice_id, TIME)));
	// We sample with a unique per-pixel offset
	uv += (vec2(rand2(uv + TIME), rand2(uv - TIME)) - 0.5) * local_warp_strength * warp_zone * glitch;

	// Shake globally on both directions
	// Slightly disrupting both axes so that they don't move in sync
	// This is completely arbitrary by the way
	uv += vec2(
		rand(TIME * 1.3) - 0.5,
		rand(TIME * 1.7) - 0.5
	) * shake_strength * glitch;

	vec4 base = texture(TEXTURE, uv);
	// Sample the texture two more times, the red and blue channels will be
	// extracted from neighboring pixels. This is a classic 3D glasses effect
	float r = texture(TEXTURE, uv + vec2(chroma_offset * glitch, 0.0)).r;
	float b = texture(TEXTURE, uv - vec2(chroma_offset * glitch, 0.0)).b;
	vec3 color = vec3(r, base.g, b);

	// Create some independent noise
	color += (rand2(uv * TIME * 1.5) - 0.5) * noise_strength * glitch;

	// Create a random normalized (pure) color
	vec3 flash_color = vec3(
		step(0.5, rand(TIME + 0.1)),
		step(0.5, rand(TIME + 3.1)),
		step(0.5, rand(TIME + 6.1))
	);
	// Violently transition to that specific value, with an intensity mediated by randomness
	color = mix(color, flash_color, rand(TIME * 4.0) * color_flash_strength * glitch);

	COLOR = vec4(color, base.a);
}