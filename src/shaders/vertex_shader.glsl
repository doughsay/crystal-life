#version 330 core

layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec3 aInstancePos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

out vec3 fragColor;

void main() {
   gl_Position = projection * view * model * vec4(aPos + aInstancePos, 1.0);
   fragColor = aColor;
}
