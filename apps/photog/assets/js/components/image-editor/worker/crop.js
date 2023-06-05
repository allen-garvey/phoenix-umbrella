/**
 * @param {Float32Array} cropPoints - x,y points to draw lines between
 * @param {Number} width
 * @param {Number} height
 * @param {Number} border
 * @returns {Object}
 */
export const calculateCrop = (cropPoints, width, height, border) => {
    let minX = Infinity;
    let maxX = 0;
    let minY = Infinity;
    let maxY = 0;

    for(let i=0;i<cropPoints.length;i+=2){
        const x = cropPoints[i];
        const y = cropPoints[i+1];

        minX = Math.min(minX, x);
        maxX = Math.max(maxX, x);

        minY = Math.min(minY, y);
        maxY = Math.max(maxY, y);
    }

    minX = Math.max(Math.floor(minX) - border, 0);
    maxX = Math.min(Math.ceil(maxX) - border, width);
    minY = Math.max(Math.floor(minY) - border, 0);
    maxY = Math.min(Math.ceil(maxY) - border, height);

    return {
        x: minX,
        y: minY,
        width: Math.min(maxX - minX, width),
        height: Math.min(maxY - minY, height),
    };
};