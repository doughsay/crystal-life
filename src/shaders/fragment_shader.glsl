#version 330 core

in vec3 fragColor;
in vec2 texCoord;
out vec4 outColor;

void main() {
  if (texCoord.x > 0.5 || texCoord.y > 0.5) {
    outColor = vec4(1.0f, 0.0f, 0.0f, 1.0f);
  } else {
    outColor = vec4(fragColor, 1.0f);
  }
}
