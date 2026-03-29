shader_type canvas_item;

uniform int iterations = 50;
uniform float zoom = 2.0;
uniform vec2 offset = vec2(0.0, 0.0);

const float SOL_THRESHOLD = 0.001;

vec2 complex_mul(vec2 a, vec2 b) {
    return vec2(a.x * b.x - a.y * b.y, a.x * b.y + a.y * b.x);
}

vec2 complex_div(vec2 a, vec2 b) {
    float denom = dot(b, b);
	// Multiply by the conjugate and you'll get the formula
    return vec2(dot(a, b), a.y * b.x - a.x * b.y) / denom;
}

void fragment() {
    // Interpret as complex plane coordinates
	vec2 z = (UV - 0.5) * zoom + offset;

    int reached_iter = iterations;
    vec3 color = vec3(0.0);

    for (int i = 0; i < iterations; i++) {
        // TODO: This can implement any arbitrary complex function
		vec2 z2 = complex_mul(z, z);
        vec2 f_z = complex_mul(z2, z) - vec2(1.0, 0.0);
        vec2 df_z = 3.0 * z2;

        z -= complex_div(f_z, df_z);

        // Check which root we are approaching
        if (length(z - vec2(1.0, 0.0)) < SOL_THRESHOLD) {
            color = vec3(1.0, 0.3, 0.3);
            reached_iter = i;
            break;
        }

        if (length(z - vec2(-0.5, 0.866)) < SOL_THRESHOLD) {
            color = vec3(0.3, 1.0, 0.3);
            reached_iter = i;
            break;
        }

        if (length(z - vec2(-0.5, -0.866)) < SOL_THRESHOLD) {
            color = vec3(0.3, 0.3, 1.0);
            reached_iter = i;
            break;
        }
    }

	// If it requires more iterators, it should be darker
    float brightness = 1.0 - (float(reached_iter) / float(iterations));
    COLOR = vec4(color * brightness, 1.0);
}