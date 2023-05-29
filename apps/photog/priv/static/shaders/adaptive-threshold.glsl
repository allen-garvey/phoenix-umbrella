precision mediump float;
    
varying vec2 v_texcoord;
uniform sampler2D u_texture;
uniform float u_threshold;
uniform vec2 u_image_dimensions;


float lightness(vec3 pixel){
    float maxVal = max(max(pixel.r, pixel.g), pixel.b);
    float minVal = min(min(pixel.r, pixel.g), pixel.b);
    return (maxVal + minVal) / 2.0;
}

void main(){
    vec4 pixel = texture2D(u_texture, v_texcoord);
    float pixelLightness = lightness(pixel.rgb);
    
    vec2 dx = vec2(1.0 / u_image_dimensions.x, 0.0);
    vec2 dy = vec2(0.0, 1.0 / u_image_dimensions.y);
    float sum = 0.0;
    float total = 0.0;

    for (float x = -4.0; x <= 4.0; x += 1.0) {
        for (float y = -4.0; y <= 4.0; y += 1.0) {
            vec3 sample = texture2D(u_texture, v_texcoord + dx * x + dy * y).rgb;
            sum += lightness(sample);
            total++;
        }
    }
    float average = sum / total;

    bool shouldUseBlackPixel = pixelLightness < u_threshold * average;

    // if(shouldUseBlackPixel){
    //     gl_FragColor = vec4(0.0, 0.0, 0.0, pixel.a);
    // }
    // else{
    //     gl_FragColor = vec4(1.0, 1.0, 1.0, pixel.a);
    // }
    gl_FragColor = vec4(0.0, 0.0, 0.0, pixel.a);
}