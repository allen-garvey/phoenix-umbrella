<template>
<div>
<loading-animation v-if="!isInitialLoadComplete" />
<div v-if="isInitialLoadComplete">
    <div>
        <image-title :image-id="imageId" :image-model="imageModel" />
        <div>
            <img :class="$style.image" :src="masterUrlFor(imageModel)" @load="imageLoaded" ref="image" v-show="shouldShowSourceImage" />
            <div :class="$style.canvasSuperContainer" :style="{width: `${polygonCropCanvasWidth}px`, height: `${polygonCropCanvasHeight}px`}">
                <canvas ref="outputCanvas" :class="$style.outputCanvas" :style="{top: `${polygonCropBorderSize * zoom / 200}px`, left: `${polygonCropBorderSize * zoom / 200}px`}"></canvas>
                <canvas ref="polygonCropCanvas" :class="$style.polygonCropCanvas" @click="polygonCropCanvasClicked"></canvas>
            </div>
        </div>
    </div>
    <div :class="$style.controls">
        <fieldset class="form-group">
            <legend>Display</legend>
            <label>Show source image<input type="checkbox" v-model="shouldShowSourceImage"></label>
        </fieldset>
        <fieldset class="form-group">
            <legend>Filters</legend>
            <label>
                Brightness
                <input type="range" min="0" max="200" v-model.number="brightness" class="form-range" />
                <input type="number" min="0" max="200" v-model.number="brightness" class="form-control" />
            </label>
            <label>
                Contrast
                <input type="range" min="0" max="200" v-model.number="contrast" class="form-range" />
                <input type="number" min="0" max="200" v-model.number="contrast" class="form-control" />
            </label>
            <label>
                Blur
                <input type="range" min="0" max="15" v-model.number="blur" class="form-range" />
                <input type="number" min="0" max="15" v-model.number="blur" class="form-control" />
            </label>
        </fieldset>
        <fieldset class="form-group">
            <legend>Adaptive Threshold</legend>
            <label>Enable<input type="checkbox" v-model="isAdaptiveThresholdEnabled"></label>
            <label>
                Threshold
                <input type="range" min="0" :max="maxAdaptiveThreshold" v-model.number="adaptiveThreshold" class="form-range" />
                <input type="number" min="0" :max="maxAdaptiveThreshold" v-model.number="adaptiveThreshold" class="form-control" />
            </label>
        </fieldset>
        <fieldset class="form-group">
            <legend>Threshold</legend>
            <label>Enable<input type="checkbox" v-model="isThresholdEnabled"></label>
            <label>
                Threshold
                <input type="range" min="0" max="255" v-model.number="threshold" class="form-range" />
                <input type="number" min="0" max="255" v-model.number="threshold" class="form-control" />
            </label>
        </fieldset>
        <fieldset class="form-group">
            <legend>Polygon Crop</legend>
            <label>Enable<input type="checkbox" v-model="isPolygonCropEnabled"></label>
            <button :disabled="!isPolygonCropInProgress" @click="clearPolygonCrop" class="btn btn-outline-dark">Clear polygon crop</button>
        </fieldset>
        <fieldset class="form-group">
            <legend>Zoom</legend>
            <label>
                Zoom
                <input type="range" min="10" max="400" v-model.number="zoom" class="form-range" />
                <input type="number" min="10" max="400" v-model.number="zoom" class="form-control" />
            </label>
            <button v-if="zoom !== 100" @click="zoomToFull" class="btn btn-outline-dark">Full</button>
            <button @click="zoomToFit" class="btn btn-outline-dark">Fit</button>
        </fieldset>
        <fieldset class="form-group">
            <legend>Export</legend>
            <input v-model="exportImageName" class="form-control" />.webp
            <button @click="exportImage" class="btn btn-success">Save</button>
        </fieldset>
    </div>
</div>
</div>
</template>

<style lang="scss" module>
canvas {
    image-rendering: pixelated;
}
$controlsWidth: 454px;

.image {
    max-width: unset;
}
.controls {
    overflow-y: scroll;
    position: fixed;
    top: 0;
    right: 0;
    height: 100%;
    background-color: #fff;
    width: $controlsWidth;
    border-left: 1px solid rgba(0,0,0,0.1);
    padding: 1rem;
}
.canvasSuperContainer {
    position: relative;
    box-sizing: content-box;
    padding-right: $controlsWidth + 100px;
}
.polygonCropCanvas {
    position: absolute;
}
.outputCanvas {
    position: absolute;
}
</style>
<script>
import { nextTick } from 'vue';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import ImageTitle from './image-title.vue';
import { createDrawFunc, loadTexture, createWebgl2Context } from '../canvas2';
import { clearCanvas, drawLines, drawFill, saveCanvas, drawFilters, drawPolygonCropOrigin } from '../canvas';
import { extractFileName } from '../path';

const PolygonCropState = {
    NOT_STARTED: 1,
    IN_PROGRESS: 2,
    COMPLETE: 3,
};

const OutputDrawLevel = {
    INITIAL: 0,
    FILTER_1: 1,
    ADAPTIVE_THRESHOLD: 2,
    THRESHOLD: 3,
    CROP: 4,
};

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
        imageId: {
            type: Number,
            required: true,
        },
        masterUrlFor: {
            type: Function,
            required: true,
        },
    },
    components: {
        LoadingAnimation,
        ImageTitle,
    },
    created(){
        this.worker = new Worker(/* webpackChunkName: "photog-editor-worker" */ new URL('../worker/worker.js', import.meta.url));
        this.worker.onmessage = this.onWorkerMessageReceived;
    },
    mounted(){
        this.setup();
    },
    data(){
        return {
            isInitialLoadComplete: false,
            imageModel: null,
            adaptiveThreshold: 15,
            isAdaptiveThresholdEnabled: false,
            threshold: 127,
            isThresholdEnabled: false,
            shouldShowSourceImage: false,
            outputSourceContext: null,
            displayContext: null,
            adaptiveThresholdContext: null,
            thresholdContext: null,
            polygonCrop2dContext: null,
            exportContext: null,
            imageWidth: 0,
            imageHeight: 0,
            adaptiveThresholdDrawFunc: null,
            thresholdDrawFunc: null,
            shaders: null,
            brightness: 100,
            contrast: 100,
            blur: 0,
            polygonCropPoints: [],
            polygonCropState: PolygonCropState.NOT_STARTED,
            isPolygonCropEnabled: true,
            fillPoints: [],
            fillPointsCrop: null,
            zoom: 100,
            zoomThrottle: false,
            worker: null,
            exportImageName: '',
            resizePolygonCropCanvasTimeout: null,
        };
    },
    computed: {
        maxAdaptiveThreshold(){
            return 25;
        },
        polygonCropBorderSize(){
            return 200;
        },
        minDistanceToCompletePolygonCrop(){
            const smallestDimension = Math.min(this.imageHeight, this.imageWidth);
            return Math.min(Math.floor((smallestDimension - 500) / 10) + 10, 50);
        },
        isPolygonCropInProgress(){
            return this.polygonCropState !== PolygonCropState.NOT_STARTED;
        },
        polygonCropCanvasHeight(){
            return (this.imageHeight + this.polygonCropBorderSize) * (this.zoom / 100);
        },
        polygonCropCanvasWidth(){
            return (this.imageWidth + this.polygonCropBorderSize) * (this.zoom / 100);
        },
    },
    watch: {
        '$route'(to, from){
            nextTick().then(() => {
                this.setup();
            });
        },
        adaptiveThreshold(){
            if(this.adaptiveThresholdDrawFunc && this.isAdaptiveThresholdEnabled){
                this.renderOutput(OutputDrawLevel.ADAPTIVE_THRESHOLD);
            }
        },
        isAdaptiveThresholdEnabled(){
            this.renderOutput(OutputDrawLevel.INITIAL);
        },
        polygonCropPoints(to){
            if(to.length === 0){
                clearCanvas(this.polygonCrop2dContext);
                return;
            }
            this.renderPolygonCropPoints();
        },
        fillPoints(){
            if(this.isPolygonCropEnabled){
                this.renderOutput(OutputDrawLevel.CROP);
            }
        },
        isPolygonCropEnabled(){
            if(this.polygonCropState === PolygonCropState.COMPLETE){
                this.renderOutput(OutputDrawLevel.INITIAL);
            }
        },
        blur(){
            this.renderOutput(OutputDrawLevel.BLUR);
        },
        isThresholdEnabled(){
            this.renderOutput(OutputDrawLevel.INITIAL);
        },
        threshold(){
            if(this.isThresholdEnabled){
                this.renderOutput(OutputDrawLevel.THRESHOLD);
            }
        },
        brightness(){
            this.renderOutput(OutputDrawLevel.FILTER_1);
        },
        contrast(){
            this.renderOutput(OutputDrawLevel.FILTER_1);
        },
        zoom(){
            if(!this.zoomThrottle){
                this.zoomThrottle = true;
                setTimeout(() => {
                    this.displayOutput();
                    this.zoomThrottle = false;
                }, 150);
            }

            if(this.resizePolygonCropCanvasTimeout === null){
                clearCanvas(this.polygonCrop2dContext);
            }

            clearTimeout(this.resizePolygonCropCanvasTimeout);
            this.resizePolygonCropCanvasTimeout = setTimeout(() => {
                this.$refs.polygonCropCanvas.width = this.polygonCropCanvasWidth;
                this.$refs.polygonCropCanvas.height = this.polygonCropCanvasHeight;
                this.renderPolygonCropPoints();
                this.resizePolygonCropCanvasTimeout = null;
            }, 400);
        },
    },
    methods: {
        setup(){
            this.isInitialLoadComplete = false;
            const imagePromise = this.getModel(`/images/${this.imageId}`).then(model => {
                this.imageModel = model;
            });

            // TODO: change shaders to be loaded on create, instead of each time
            const adaptiveThresholdPixelShaderPromise = this.getModel(`/shaders/adaptive-threshold-2.glsl`, {contentType: 'text'}, false);

            const thresholdPixelShaderPromise = this.getModel(`/shaders/threshold-2.glsl`, {contentType: 'text'}, false);

            const vertextShaderPromise = this.getModel(`/shaders/vertex-2.glsl`, {contentType: 'text'}, false);

            Promise.all([imagePromise, adaptiveThresholdPixelShaderPromise, vertextShaderPromise, thresholdPixelShaderPromise]).then(([_, pixelShader, vertexShader, thresholdPixelShader]) => {
                this.isInitialLoadComplete = true;
                this.shaders = {
                    pixelShader,
                    vertexShader,
                    thresholdPixelShader,
                };
            });

            this.exportContext = document.createElement('canvas').getContext('2d');
        },
        imageLoaded() {
            const image = this.$refs.image;
            this.imageWidth = image.naturalWidth;
            this.imageHeight = image.naturalHeight;

            this.exportImageName = extractFileName(this.imageModel.master_path).replace(/\.[^.]+$/, '') + '-bw';
            
            this.$refs.outputCanvas.width = this.imageWidth;
            this.$refs.outputCanvas.height = this.imageHeight;
            this.displayContext = this.$refs.outputCanvas.getContext('2d');
            
            this.outputSourceContext = document.createElement('canvas').getContext('2d');
            this.outputSourceContext.canvas.width = this.imageWidth;
            this.outputSourceContext.canvas.height = this.imageHeight;

            this.$refs.polygonCropCanvas.width = this.polygonCropCanvasWidth;
            this.$refs.polygonCropCanvas.height = this.polygonCropCanvasHeight;
            this.polygonCrop2dContext = this.$refs.polygonCropCanvas.getContext('2d');
            
            this.adaptiveThresholdContext = createWebgl2Context(this.imageWidth, this.imageHeight);
            this.adaptiveThresholdDrawFunc = createDrawFunc(this.adaptiveThresholdContext, this.shaders.vertexShader, this.shaders.pixelShader, image.width, image.height);

            this.thresholdContext = createWebgl2Context(this.imageWidth, this.imageHeight);
            this.thresholdDrawFunc = createDrawFunc(this.thresholdContext, this.shaders.vertexShader, this.shaders.thresholdPixelShader, image.width, image.height);

            this.renderOutput(OutputDrawLevel.INITIAL);
        },
        polygonCropCanvasClicked(e){
            if(this.polygonCropState === PolygonCropState.COMPLETE){
                return;
            }
            const scale = 100 / this.zoom;
            let x = e.offsetX * scale;
            let y = e.offsetY * scale;
            
            this.polygonCropState = PolygonCropState.IN_PROGRESS;

            // if polygon has at least 2 sides already, and so can be closed,
            // and point clicked is close enough, close the polygon
            if(this.polygonCropPoints.length >= 4){
                const firstX = this.polygonCropPoints[0];
                const firstY = this.polygonCropPoints[1]
                const xDistance = x - firstX;
                const yDistance = y - firstY;
                const distance = Math.sqrt(xDistance * xDistance + yDistance * yDistance);

                if(distance < this.minDistanceToCompletePolygonCrop) {
                    x = firstX;
                    y = firstY;
                    this.polygonCropState = PolygonCropState.COMPLETE;
                    this.isPolygonCropEnabled = true;
                    // clear origin point indicator
                    clearCanvas(this.polygonCrop2dContext);
                }
            }

            this.polygonCropPoints = this.polygonCropPoints.concat([x, y]);

            if(this.polygonCropState === PolygonCropState.COMPLETE){
                this.worker.postMessage({
                    imageWidth: this.imageWidth,
                    imageHeight: this.imageHeight,
                    polygonCropPoints: new Float32Array(this.polygonCropPoints),
                    cropCanvasBorderSize: this.polygonCropBorderSize,
                });
            }
        },
        onWorkerMessageReceived(e){
            if(this.polygonCropState !== PolygonCropState.COMPLETE){
                return;
            }
            this.fillPointsCrop = e.data.crop;
            this.fillPoints = e.data.fillPoints;
        },
        renderOutput(outputDrawLevel=OutputDrawLevel.INITIAL){
            const drawOriginal = () => {
                this.outputSourceContext.drawImage(this.$refs.image, 0, 0, this.imageWidth, this.imageHeight);
            };
            let hasDrawn = false;
            const isAdaptiveThresholdUsed = this.adaptiveThresholdDrawFunc && this.isAdaptiveThresholdEnabled;
            const areFiltersUsed = this.contrast !== 100 || this.brightness !== 100 || this.blur !== 0;
            
            if(outputDrawLevel <= OutputDrawLevel.FILTER_1 && areFiltersUsed){
                drawOriginal();
                drawFilters(this.outputSourceContext, `contrast(${this.contrast}%) brightness(${this.brightness}%) blur(${this.blur}px)`);
                hasDrawn = true;
            }
            if(outputDrawLevel <= OutputDrawLevel.ADAPTIVE_THRESHOLD && isAdaptiveThresholdUsed){
                if(outputDrawLevel < OutputDrawLevel.ADAPTIVE_THRESHOLD){
                    if(!hasDrawn){
                        drawOriginal();
                        hasDrawn = true;
                    }
                    loadTexture(this.adaptiveThresholdContext, this.outputSourceContext.canvas);
                }
                const thresholdPercent = (100 - Math.abs(this.adaptiveThreshold - this.maxAdaptiveThreshold)) / 100;
                this.adaptiveThresholdDrawFunc(thresholdPercent);
                this.outputSourceContext.drawImage(this.adaptiveThresholdContext.canvas, 0, 0);
                hasDrawn = true;
            }
            if(outputDrawLevel <= OutputDrawLevel.THRESHOLD && this.thresholdDrawFunc && this.isThresholdEnabled){
                if(outputDrawLevel < OutputDrawLevel.THRESHOLD){
                    if(!hasDrawn){
                        drawOriginal();
                        hasDrawn = true;
                    }
                    loadTexture(this.thresholdContext, this.outputSourceContext.canvas);
                }
                const threshold = this.threshold / 255;
                this.thresholdDrawFunc(threshold);
                this.outputSourceContext.drawImage(this.thresholdContext.canvas, 0, 0);
                hasDrawn = true;
            }
            if(outputDrawLevel <= OutputDrawLevel.CROP && this.isPolygonCropEnabled && this.fillPoints.length > 0){
                drawFill(this.outputSourceContext, this.fillPoints);
                hasDrawn = true;
            }
            if(!hasDrawn){
                drawOriginal();
                hasDrawn = true;
            }
            this.displayOutput();
        },
        displayOutput(){
            const zoomPercentage = this.zoom / 100;
            const outputWidth = this.imageWidth * zoomPercentage;
            const outputHeight = this.imageHeight * zoomPercentage;
            this.displayContext.canvas.width = outputWidth;
            this.displayContext.canvas.height = outputHeight;

            this.displayContext.drawImage(this.outputSourceContext.canvas, 0, 0, this.imageWidth, this.imageHeight, 0, 0, outputWidth, outputHeight);
        },
        renderPolygonCropPoints(){
            const scale = this.zoom / 100;
            if(this.polygonCropState !== PolygonCropState.COMPLETE && this.polygonCropPoints.length >= 2){
                drawPolygonCropOrigin(this.polygonCrop2dContext, this.polygonCropPoints[0], this.polygonCropPoints[1], scale);
            }
            if(this.polygonCropPoints.length >= 4){
                drawLines(this.polygonCrop2dContext, this.polygonCropPoints, scale);
            }
        },
        zoomToFull(){
            this.zoom = 100;
        },
        zoomToFit(){
            const clientHeight = window.innerHeight;
            const clientWidth = window.innerWidth - 455; // controls width + border
            const imageHeight = this.fillPointsCrop?.height || this.imageHeight;
            const imageWidth = this.fillPointsCrop?.width || this.imageWidth

            this.zoom = Math.floor(Math.min(clientHeight / imageHeight, clientWidth / imageWidth) * 100);
        },
        clearPolygonCrop(){
            this.fillPoints = [];
            this.fillPointsCrop = null;
            this.polygonCropPoints = [];
            this.polygonCropState = PolygonCropState.NOT_STARTED;
            this.renderOutput(OutputDrawLevel.INITIAL);
        },
        exportImage(){
            let canvas = this.outputSourceContext.canvas;

            if(this.fillPointsCrop){
                canvas = this.exportContext.canvas;
                canvas.width = this.fillPointsCrop.width;
                canvas.height = this.fillPointsCrop.height;
                this.exportContext.drawImage(this.outputSourceContext.canvas, this.fillPointsCrop.x, this.fillPointsCrop.y, this.fillPointsCrop.width, this.fillPointsCrop.height, 0, 0, this.fillPointsCrop.width, this.fillPointsCrop.height)
            }

            saveCanvas(canvas, this.exportImageName);
        },
    }
};
</script>