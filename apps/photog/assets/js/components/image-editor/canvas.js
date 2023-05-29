import m4 from './webgl-m4.js';

export const createAndLoadTexture = (gl, canvas) => {
    const texture = gl.createTexture();
    
    gl.bindTexture(gl.TEXTURE_2D, texture);
    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, canvas);

    // let's assume all images are not a power of 2
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    
    return texture;
};

/*
* Shader and program creation
*/
//based on: https://webglfundamentals.org/webgl/lessons/webgl-fundamentals.html
function createShader(gl, type, source) {
    const shader = gl.createShader(type);
    gl.shaderSource(shader, source);
    gl.compileShader(shader);
    const success = gl.getShaderParameter(shader, gl.COMPILE_STATUS);
    if(success){
        return shader;
    }
    //something went wrong
    console.log(gl.getShaderInfoLog(shader));
    gl.deleteShader(shader);
}

function createVertexShader(gl, vertexShaderSource){
    return createShader(gl, gl.VERTEX_SHADER, vertexShaderSource);
}

function createFragmentShader(gl, fragmentShaderSource){
    return createShader(gl, gl.FRAGMENT_SHADER, fragmentShaderSource);
}

function createProgram(gl, vertexShader, fragmentShader) {
    const program = gl.createProgram();
    gl.attachShader(program, vertexShader);
    gl.attachShader(program, fragmentShader);
    gl.linkProgram(program);
    const success = gl.getProgramParameter(program, gl.LINK_STATUS);
    if(success){
        return program;
    }
    //something went wrong
    console.log(gl.getProgramInfoLog(program));
    gl.deleteProgram(program);
}

export const createAdaptiveThresholdDrawFunc = (gl, vertexShader, pixelShader) => {
    // setup GLSL program
    const program = createProgram(gl, createVertexShader(gl, vertexShader), createFragmentShader(gl, pixelShader));
    //if program is string, that means there was an error compiling
    if(typeof program === 'string'){
        console.log(program);
        return;
    }
    
    // look up where the vertex data needs to go.
    const positionLocation = gl.getAttribLocation(program, 'a_position');
    const texcoordLocation = gl.getAttribLocation(program, 'a_texcoord');
    
    // lookup uniforms
    const matrixLocation = gl.getUniformLocation(program, 'u_matrix');
    const textureLocation = gl.getUniformLocation(program, 'u_texture');
    const thresholdLocation = gl.getUniformLocation(program, 'u_threshold');
    const imageDimensionsLocation = gl.getUniformLocation(program, 'u_image_dimensions');
    
    // Create a buffer.
    const positionBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
    
    const unitQuad = [
        0, 0,
        0, 1,
        1, 0,
        1, 0,
        0, 1,
        1, 1,
    ];

    // Put a unit quad in the buffer
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(unitQuad), gl.STATIC_DRAW);
    
    // Create a buffer for texture coords
    const texcoordBuffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
    
    // Put texcoords in the buffer
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(unitQuad), gl.STATIC_DRAW);

    return (gl, tex, texWidth, texHeight, threshold) => {
        gl.viewport(0, 0, gl.canvas.width, gl.canvas.height);
        gl.bindTexture(gl.TEXTURE_2D, tex);
        
        // Tell WebGL to use our shader program pair
        gl.useProgram(program);
        
        // Setup the attributes to pull data from our buffers
        gl.bindBuffer(gl.ARRAY_BUFFER, positionBuffer);
        gl.enableVertexAttribArray(positionLocation);
        gl.vertexAttribPointer(positionLocation, 2, gl.FLOAT, false, 0, 0);
        gl.bindBuffer(gl.ARRAY_BUFFER, texcoordBuffer);
        gl.enableVertexAttribArray(texcoordLocation);
        gl.vertexAttribPointer(texcoordLocation, 2, gl.FLOAT, false, 0, 0);
        
        // this matrix will convert from pixels to clip space
        let matrix = m4.orthographic(0, gl.canvas.width, gl.canvas.height, 0, -1, 1);
        
        // this matrix will translate our quad to dstX, dstY
        const dstX = 0; 
        const dstY = 0;
        matrix = m4.translate(matrix, dstX, dstY, 0);
        
        // this matrix will scale our 1 unit quad
        // from 1 unit to texWidth, texHeight units
        matrix = m4.scale(matrix, texWidth, texHeight, 1);
        
        // Set the matrix.
        gl.uniformMatrix4fv(matrixLocation, false, matrix);
        
        // Tell the shader to get the texture from texture unit 0
        gl.uniform1i(textureLocation, 0);
        gl.activeTexture(gl.TEXTURE0);
        gl.bindTexture(gl.TEXTURE_2D, tex);

        gl.uniform1f(thresholdLocation, threshold);
        gl.uniform2f(imageDimensionsLocation, texWidth, texHeight);
        
        // draw the quad (2 triangles, 6 vertices)
        gl.drawArrays(gl.TRIANGLES, 0, 6);
    };
};