import { drawLines } from '../canvas';

onmessage = (e) => {
    console.log('Message received from main script');
    const startTime = performance.now();
    
    const { imageWidth, imageHeight, polygonCropPoints, cropCanvasBorderSize } = e.data;
    const cropCanvasWidth = imageWidth+cropCanvasBorderSize;
    const cropCanvasHeight = imageHeight+cropCanvasBorderSize;
    
    const canvas = new OffscreenCanvas(cropCanvasWidth, cropCanvasHeight);
    const context = canvas.getContext('2d');
    drawLines(context, polygonCropPoints);

    const cropImageData = context.getImageData(0, 0, cropCanvasWidth, cropCanvasHeight);
    const cropRowLength = cropCanvasWidth * 4;
    const halfBorder = cropCanvasBorderSize / 2;
    const negativeHalfBorder = -1 * halfBorder;

    const fillPoints = [];

    for(let i=halfBorder*cropRowLength,y=0;y<imageHeight+1;i+=cropRowLength,y++){
        const endXIndex = i + cropRowLength;
        let alphaFound = false;
        let foundX = 0;

        for(let j=i,x=negativeHalfBorder;j<endXIndex;j+=4,x++){
            const alpha = cropImageData.data[j+3];
            if(alpha > 0){
                alphaFound = true;
                foundX = x;

                if(x >= 0 && x <= imageWidth){
                    fillPoints.push(0);
                    fillPoints.push(y);
                    fillPoints.push(x);
                    fillPoints.push(y);
                }
                break;
            }
        }

        if(!alphaFound){
            fillPoints.push(0);
            fillPoints.push(y);
            fillPoints.push(imageWidth);
            fillPoints.push(y);
            continue;
        }

        for(let j=endXIndex-4,x=imageWidth+halfBorder;x>foundX;j-=4,x--){
            const alpha = cropImageData.data[j+3];
            if(alpha > 0){
                if(x > foundX && x <= imageWidth){
                    fillPoints.push(x);
                    fillPoints.push(y);
                    fillPoints.push(imageWidth);
                    fillPoints.push(y);
                }
                break;
            }
        }
    }
    const timeElapsed = (performance.now() - startTime) / 1000;
    const megapixels = (cropCanvasWidth - halfBorder) * cropCanvasHeight / 1_000_000;
    console.log(`Worker fill computation: ${timeElapsed}s ${megapixels / timeElapsed} megapixels per second`);

    self.postMessage({
        fillPoints: new Float32Array(fillPoints),
    });
};