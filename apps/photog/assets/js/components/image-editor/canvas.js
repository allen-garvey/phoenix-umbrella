/**
 * @param {CanvasRenderingContext2D} context
 */
export const clearCanvas = (context) => {
    context.clearRect(0, 0, context.canvas.width, context.canvas.height);
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Array.<Number>} points - x,y points to draw lines between
 */
export const drawLines = (context, points) => {
    context.beginPath();
    context.moveTo(points[0], points[1]);

    for(let i=2;i<points.length;i+=2){
        context.lineTo(points[i], points[i+1]);
    }
    context.lineWidth = 1;
    context.strokeStyle = '#000';
    context.stroke();
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Float32Array} points - x,y points to draw lines between
 */
export const drawFill = (context, points) => {
    context.fillStyle = '#fff';

    for(let i=0;i<points.length;i+=4){
        // context.rect(points[i], points[i+1], points[i+2]-points[i+1], 1);
        context.fillRect(points[i], points[i+1], points[i+2]-points[i], 1);
    }

    // context.fill();
};
