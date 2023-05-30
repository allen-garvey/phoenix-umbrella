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