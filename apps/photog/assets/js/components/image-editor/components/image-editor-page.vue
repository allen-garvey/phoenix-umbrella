<template>
<div>
<loading-animation v-if="!isInitialLoadComplete" />
<div v-if="isInitialLoadComplete">
    <div>
        <image-title :image-id="imageId" :image-model="imageModel" />
        <div>
            <img :class="$style.image" :src="masterImageUrl" @load="imageLoaded" ref="image" v-show="shouldShowSourceImage" />
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
            <legend>Filters 2</legend>
            <label>
                Blur
                <input type="range" min="0" max="15" v-model.number="blur" class="form-range" />
                <input type="number" min="0" max="15" v-model.number="blur" class="form-control" />
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
import { getMasterUrl } from '../../../image.js';
import { createDrawFunc, loadTexture, createWebgl2Context } from '../canvas2';
import { clearCanvas, drawLines, drawFill, saveCanvas, drawFilters } from '../canvas';
import { extractFileName } from '../path';

const PolygonCropState = {
    NOT_STARTED: 1,
    IN_PROGRESS: 2,
    COMPLETE: 3,
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
            worker: null,
            exportImageName: '',
        };
    },
    computed: {
        masterImageUrl(){
            return getMasterUrl(this.imageModel);
        },
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
                this.renderOutput();
            }
        },
        isAdaptiveThresholdEnabled(){
            this.renderOutput();
        },
        polygonCropPoints(to){
            if(to.length === 0){
                clearCanvas(this.polygonCrop2dContext);
                return;
            }
            this.renderPolygonCropPoints();
            if(to.length >= 6){
                //check if shape is closed
                if(to[0] === to[to.length - 2] && to[1]=== to[to.length - 1]){
                    this.worker.postMessage({
                        imageWidth: this.imageWidth,
                        imageHeight: this.imageHeight,
                        polygonCropPoints: new Float32Array(to),
                        cropCanvasBorderSize: this.polygonCropBorderSize,
                    });
                }
            }
        },
        fillPoints(){
            if(this.isPolygonCropEnabled){
                this.renderOutput();
            }
        },
        isPolygonCropEnabled(){
            if(this.polygonCropState === PolygonCropState.COMPLETE){
                this.renderOutput();
            }
        },
        blur(){
            this.renderOutput();
        },
        isThresholdEnabled(){
            this.renderOutput();
        },
        threshold(){
            if(this.isThresholdEnabled){
                this.renderOutput();
            }
        },
        brightness(){
            this.renderOutput();
        },
        contrast(){
            this.renderOutput();
        },
        zoom(){
            this.displayOutput();
            this.$refs.polygonCropCanvas.width = this.polygonCropCanvasWidth;
            this.$refs.polygonCropCanvas.height = this.polygonCropCanvasHeight;
            this.renderPolygonCropPoints();
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

            this.exportImageName = extractFileName(this.imageModel.master_path).replace(/\.[^.]+$/, '') + '-adjusted';
            
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

            this.renderOutput();
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
                }
            }

            this.polygonCropPoints = this.polygonCropPoints.concat([x, y]);
        },
        onWorkerMessageReceived(e){
            if(this.polygonCropState !== PolygonCropState.COMPLETE){
                return;
            }
            this.fillPointsCrop = e.data.crop;
            this.fillPoints = e.data.fillPoints;
        },
        renderOutput(){
            this.outputSourceContext.drawImage(this.$refs.image, 0, 0, this.imageWidth, this.imageHeight);
            
            if(this.contrast !== 100 || this.brightness !== 100){
                drawFilters(this.outputSourceContext, `contrast(${this.contrast}%) brightness(${this.brightness}%)`);
            }
            if(this.adaptiveThresholdDrawFunc && this.isAdaptiveThresholdEnabled){
                // TODO: optimize so don't reload texture unless contrast or brightness changed
                loadTexture(this.adaptiveThresholdContext, this.outputSourceContext.canvas);
                const thresholdPercent = (100 - Math.abs(this.adaptiveThreshold - this.maxAdaptiveThreshold)) / 100;
                this.adaptiveThresholdDrawFunc(thresholdPercent);
                this.outputSourceContext.drawImage(this.adaptiveThresholdContext.canvas, 0, 0);
            }
            if(this.blur !== 0){
                drawFilters(this.outputSourceContext, `blur(${this.blur}px)`);
            }
            if(this.thresholdDrawFunc && this.isThresholdEnabled){
                // TODO: optimize so don't reload texture if just threshold has been changed
                loadTexture(this.thresholdContext, this.outputSourceContext.canvas);
                const threshold = this.threshold / 255;
                this.thresholdDrawFunc(threshold);
                this.outputSourceContext.drawImage(this.thresholdContext.canvas, 0, 0);
            }
            if(this.isPolygonCropEnabled && this.fillPoints.length > 0){
                drawFill(this.outputSourceContext, this.fillPoints);
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
            if(this.polygonCropPoints.length >= 4){
                drawLines(this.polygonCrop2dContext, this.polygonCropPoints, this.zoom / 100);
            }
        },
        zoomToFull(){
            this.zoom = 100;
        },
        clearPolygonCrop(){
            this.fillPoints = [];
            this.polygonCropPoints = [];
            this.polygonCropState = PolygonCropState.NOT_STARTED;
            this.renderOutput();
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