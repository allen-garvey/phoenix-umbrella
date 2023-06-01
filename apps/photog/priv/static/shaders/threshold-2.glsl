#version 300 es

// fragment shaders don't have a default precision so we need
// to pick one. highp is a good default. It means "high precision"
precision highp float;

// our texture
uniform sampler2D u_image;
uniform float u_threshold;
uniform vec2 u_image_dimensions;

// the texCoords passed in from the vertex shader.
in vec2 v_texCoord;

// we need to declare an output for the fragment shader
out vec4 outColor;

float lightness(vec3 pixel){
  float maxVal = max(max(pixel.r, pixel.g), pixel.b);
  float minVal = min(min(pixel.r, pixel.g), pixel.b);
  return (maxVal + minVal) / 2.0;
}

void main() {
  vec4 pixel = texture(u_image, v_texCoord);
  float pixelLightness = lightness(pixel.rgb);

  bool shouldUseBlackPixel = pixelLightness < u_threshold;

  if(shouldUseBlackPixel){
    outColor = vec4(0.0, 0.0, 0.0, pixel.a);
  }
  else{
    outColor = vec4(1.0, 1.0, 1.0, pixel.a);
  }
}