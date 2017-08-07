#version 330 core

// uniforms
uniform vec3 camera_position;

// inputs
in vec3 fragment_position; // in world-space
in vec3 fragment_normal;

// outputs
out vec4 fragment_color;

// program
void main() {
  // for now, the light position will be the camera position
  // vec3 light_position = camera_position;
  vec3 light_position = vec3(20.0f, 128.0f, 60.0f);

  // light color
  vec3 light_color = vec3(1.0f, 1.0f, 1.0f);

  // ambient light
  float ambient_strength = 0.1f;
  vec3 ambient = ambient_strength * light_color;

  // diffuse light
  vec3 normal = normalize(fragment_normal);
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
  vec3 result = (ambient + diffuse + specular) * vec3(0.9, 0.5, 0.3);

  // send out final fragment color
  fragment_color = vec4(result, 1.0f);
}
