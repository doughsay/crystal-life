#version 330 core

// uniforms
uniform vec3 camera_position;

// inputs
in vec3 fragment_position; // in world-space
in vec3 vertex_normal;
in vec2 texture_coords;

// outputs
out vec4 fragment_color;

// program
void main() {
  if (texture_coords.x > 1.0f || texture_coords.y > 1.0f) {
    // discard any fragments outside 0.0 -> 1.0 texture coords
    discard;
  }

  // if (texture_coords.x >= 0.1f && texture_coords.x <= 0.9f && texture_coords.y >= 0.1f && texture_coords.y <= 0.9f) {
  //   // "wireframe" mode
  //   discard;
  // }

  // for now, the light position will be the camera position
  // vec3 light_position = camera_position;
  vec3 light_position = vec3(20.0f, 128.0f, 60.0f);

  // base colors
  vec3 object_color = vec3(0.9f, 0.4f, 0.0f);
  vec3 light_color = vec3(1.0f, 1.0f, 1.0f);

  // ambient light
  float ambient_strength = 0.1f;
  vec3 ambient = ambient_strength * light_color;

  // diffuse light
  vec3 normal = normalize(vertex_normal);
  vec3 light_direction = normalize(light_position - fragment_position);
  float diff = max(dot(normal, light_direction), 0.0f);
  vec3 diffuse = diff * light_color;

  // specular
  float specular_strength = 0.5f;
  vec3 view_direction = normalize(camera_position - fragment_position);
  vec3 reflect_direction = reflect(-light_direction, normal);
  float spec = pow(max(dot(view_direction, reflect_direction), 0.0f), 32);
  vec3 specular = specular_strength * spec * light_color;

  // lighting result
  vec3 result = (ambient + diffuse + specular) * object_color;

  // send out final fragment color
  fragment_color = vec4(result, 1.0f);
}
