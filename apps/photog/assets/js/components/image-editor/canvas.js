/**
 * @param {CanvasRenderingContext2D} context
 */
export const clearCanvas = (context) => {
    context.clearRect(0, 0, context.canvas.width, context.canvas.height);
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Array.<Number>} points - x,y points to draw lines between
 * @param {Number} scale
 */
export const drawLines = (context, points, scale=1) => {
    context.beginPath();
    context.moveTo(points[0] * scale, points[1] * scale);

    for(let i=2;i<points.length;i+=2){
        context.lineTo(points[i] * scale, points[i+1] * scale);
    }
    context.lineWidth = 1;
    context.strokeStyle = '#000';
    context.stroke();
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Number} x
 * @param {Number} y
 * @param {Number} scale
 */
export const drawPolygonCropOrigin = (context, x, y, scale=1) => {
    context.fillStyle = '#000';
    context.fillRect((x-9) * scale, (y-9) * scale,  19*scale, 19*scale);

    context.fillStyle = 'red';
    context.fillRect((x-7) * scale, (y-7) * scale,  15*scale, 15*scale);

    context.fillStyle = '#000';
    context.fillRect((x-5) * scale, (y-5) * scale,  11*scale, 11*scale);
    
    context.fillStyle = 'red';
    context.fillRect((x-3) * scale, (y-3) * scale,  7*scale, 7*scale);
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {Float32Array} points - x,y points to draw lines between
 */
export const drawFill = (context, points) => {
    context.fillStyle = '#fff';

    for(let i=0;i<points.length;i+=4){
        context.fillRect(points[i], points[i+1], points[i+2]-points[i], 1);
    }
};

/**
 * @param {CanvasRenderingContext2D} context
 * @param {String} filterString - matches filter values from https://developer.mozilla.org/en-US/docs/Web/API/CanvasRenderingContext2D/filter
 */
export const drawFilters = (context, filterString) => {
    context.filter = filterString;
    context.drawImage(context.canvas, 0, 0);
    context.filter = 'none';
};

/**
 * @returns {HTMLAnchorElement}
 */
function createSaveImageLink(){
    const link = document.createElement('a');
    //firefox needs the link attached to the body in order for downloads to work
    //so display none in order to hide it
    //https://stackoverflow.com/questions/38869328/unable-to-download-a-blob-file-with-firefox-but-it-works-in-chrome
    link.style.display = 'none';
    document.body.appendChild(link);
    return link;
}

/**
 * @param {HTMLCanvasElement} canvas
 * @param {String} fileName
 */
export const saveCanvas = (canvas, fileName) => {
    canvas.toBlob((blob)=>{
        const objectUrl = URL.createObjectURL(blob);

        const saveImageLink = createSaveImageLink();
        saveImageLink.href = objectUrl;
        saveImageLink.download = `${fileName}.webp`;
        saveImageLink.click();

        //add timeout before revoking for iOS
        //https://stackoverflow.com/questions/30694453/blob-createobjecturl-download-not-working-in-firefox-but-works-when-debugging
        setTimeout(()=>{
            URL.revokeObjectURL(objectUrl);
            saveImageLink.remove();
        }, 0);
    }, 'image/webp', 1);
};
