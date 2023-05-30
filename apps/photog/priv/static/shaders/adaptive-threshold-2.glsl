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
  
  vec2 dx = vec2(1.0 / u_image_dimensions.x, 0.0);
  vec2 dy = vec2(0.0, 1.0 / u_image_dimensions.y);
  float sum = 0.0;
  float total = 0.0;

  for (float x = -4.0; x <= 4.0; x += 1.0) {
      for (float y = -4.0; y <= 4.0; y += 1.0) {
          vec3 pixelSample = texture(u_image, v_texCoord + dx * x + dy * y).rgb;
          sum += lightness(pixelSample);
          total++;
      }
  }
  float average = sum / total;

  bool shouldUseBlackPixel = pixelLightness < u_threshold * average;

  if(shouldUseBlackPixel){
    outColor = vec4(0.0, 0.0, 0.0, pixel.a);
  }
  else{
    outColor = vec4(1.0, 1.0, 1.0, pixel.a);
  }
}