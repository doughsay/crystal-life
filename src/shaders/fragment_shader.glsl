#version 330 core

in vec3 fragColor;
in vec2 texCoord;
out vec4 outColor;

void main() {
  if (texCoord.x > 1.0f || texCoord.y > 1.0f) {
    discard;
  } else {
    outColor = vec4(fragColor, 1.0f);
  }
}
