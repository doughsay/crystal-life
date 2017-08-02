#version 330 core

// vertex attributes
layout (location = 0) in vec3 vertex_model_position;
layout (location = 1) in vec3 vertex_normal;
layout (location = 2) in vec3 instance_position;

// uniforms
uniform mat4 model, view, projection;

// oputputs
out vec3 fragment_position; // in world-space
out vec3 fragment_normal;

// program
void main() {
  vec3 vertex_position = vertex_model_position + instance_position;
  vec4 vertex_vec4 = vec4(vertex_position, 1.0);

  // set final vertex position
  gl_Position = projection * view * model * vertex_vec4;

  // send outputs
  fragment_position = vec3(model * vertex_vec4);
  fragment_normal = vertex_normal;
}
