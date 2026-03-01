shader_type canvas_item;

// The editor shall not be allowed to exceed [0, 1]
uniform float progress : hint_range(0.0, 1.0) = 0.5;
uniform vec2 circle_position = vec2(0.5);
// This 3D vector shall have color semantics
uniform vec3 background_color : source_color = vec3(0.0, 0.0, 0.0);

void fragment() {
  // This only works in-game and for a full-scale rectangle
  float aspect = SCREEN_PIXEL_SIZE.y / SCREEN_PIXEL_SIZE.x;
  vec2 center = circle_position * vec2(aspect, 1.0);
  // SCREEN_UV: Screen UV coordinate of the current pixel
  vec2 new_uv = SCREEN_UV * vec2(aspect, 1.0);

  // First, we need to calculate the maximum radius so that the entire screen is initially covered
  // This must be minimal so that the animation's speed is consistent across different computers
    
  // We need to eliminate unnecessary branching.
  vec2 far_corner = step(circle_position, vec2(0.5)) * vec2(aspect, 1.0);
  float max_radius = distance(center, far_corner);
    
  float current_radius = max_radius * (1.0 - progress);
  float mask = step(current_radius, distance(new_uv, center));
    
  COLOR = vec4(background_color, mask);
}
