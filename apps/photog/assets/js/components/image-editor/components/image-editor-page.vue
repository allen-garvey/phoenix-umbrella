<template>
<div>
<loading-animation v-if="!isInitialLoadComplete" />
<div v-if="isInitialLoadComplete">
    <div>
        <image-title :image-id="imageId" :image-model="imageModel" />
        <div>
            <img :class="$style.image" :src="masterImageUrl" @load="imageLoaded" ref="image" v-show="shouldShowSourceImage" />
            <div :class="$style.canvasSuperContainer" :style="{width: `${imageWidth + polygonCropBorderSize}px`, height: `${imageHeight + polygonCropBorderSize}px`}">
                <canvas ref="outputCanvas" :class="$style.outputCanvas" :style="{top: `${polygonCropBorderSize / 2}px`, left: `${polygonCropBorderSize / 2}px`}"></canvas>
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
            <legend>Adaptive Threshold</legend>
            <label>Enable<input type="checkbox" v-model="isAdaptiveThresholdEnabled"></label>
            <label>
                Threshold
                <input type="range" min="0" :max="maxAdaptiveThreshold" v-model.number="adaptiveThreshold" class="form-range" />
                <input type="number" min="0" :max="maxAdaptiveThreshold" v-model.number="adaptiveThreshold" class="form-control" />
            </label>
        </fieldset>
        <fieldset class="form-group">
            <legend>Polygon Crop</legend>
            <label>Enable<input type="checkbox" v-model="isPolygonCropEnabled"></label>
            <button :disabled="!isPolygonCropInProgress" @click="clearPolygonCrop" class="btn btn-outline-dark">Clear polygon crop</button>
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
$controlsWidth: 454px;

.image {
    max-width: unset;
}
.controls {
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
import { renderCanvas2, loadTexture } from '../canvas2';
import { clearCanvas, drawLines, drawFill, saveCanvas } from '../canvas';
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
            shouldShowSourceImage: false,
            outputCanvasContext: null,
            offscreen2dContext: null,
            offscreenWebglContext: null,
            polygonCrop2dContext: null,
            imageWidth: 0,
            imageHeight: 0,
            adaptiveThresholdDrawFunc: null,
            shaders: null,
            polygonCropPoints: [],
            polygonCropState: PolygonCropState.NOT_STARTED,
            isPolygonCropEnabled: true,
            fillPoints: [],
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
            if(to.length >= 4){
                drawLines(this.polygonCrop2dContext, to);
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
    },
    methods: {
        setup(){
            this.isInitialLoadComplete = false;
            const imagePromise = this.getModel(`/images/${this.imageId}`).then(model => {
                this.imageModel = model;
            });

            // TODO: change shaders to be loaded on create, instead of each time
            const adaptiveThresholdPixelShaderPromise = this.getModel(`/shaders/adaptive-threshold-2.glsl`, {contentType: 'text'}, false);

            const vertextShaderPromise = this.getModel(`/shaders/vertex-2.glsl`, {contentType: 'text'}, false);

            Promise.all([imagePromise, adaptiveThresholdPixelShaderPromise, vertextShaderPromise]).then(([_, pixelShader, vertexShader]) => {
                this.isInitialLoadComplete = true;
                this.shaders = {
                    pixelShader,
                    vertexShader,
                };
            });
        },
        imageLoaded() {
            const image = this.$refs.image;
            this.imageWidth = image.naturalWidth;
            this.imageHeight = image.naturalHeight;

            this.exportImageName = extractFileName(this.imageModel.master_path).replace(/\.[^.]+$/, '') + '-adjusted';
            
            this.$refs.outputCanvas.width = this.imageWidth;
            this.$refs.outputCanvas.height = this.imageHeight;
            this.outputCanvasContext = this.$refs.outputCanvas.getContext('2d');
            
            this.offscreen2dContext = new OffscreenCanvas(this.imageWidth, this.imageHeight).getContext('2d');

            this.$refs.polygonCropCanvas.width = this.imageWidth + this.polygonCropBorderSize;
            this.$refs.polygonCropCanvas.height = this.imageHeight + this.polygonCropBorderSize;
            this.polygonCrop2dContext = this.$refs.polygonCropCanvas.getContext('2d');
            
            this.offscreenWebglContext = document.createElement('canvas').getContext('webgl2');
            this.offscreenWebglContext.canvas.width = this.imageWidth;
            this.offscreenWebglContext.canvas.height = this.imageHeight;
            loadTexture(this.offscreenWebglContext, image);
            this.adaptiveThresholdDrawFunc = renderCanvas2(this.offscreenWebglContext, this.shaders.vertexShader, this.shaders.pixelShader, image.width, image.height);

            this.renderOutput();
        },
        polygonCropCanvasClicked(e){
            if(this.polygonCropState === PolygonCropState.COMPLETE){
                return;
            }
            let x = e.offsetX;
            let y = e.offsetY;
            
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
            this.fillPoints = e.data.fillPoints;
        },
        renderOutput(){
            if(this.adaptiveThresholdDrawFunc && this.isAdaptiveThresholdEnabled){
                const thresholdPercent = (100 - Math.abs(this.adaptiveThreshold - this.maxAdaptiveThreshold)) / 100;
                this.adaptiveThresholdDrawFunc(thresholdPercent);
                this.outputCanvasContext.drawImage(this.offscreenWebglContext.canvas, 0, 0);
            }
            else {
                this.outputCanvasContext.drawImage(this.$refs.image, 0, 0, this.imageWidth, this.imageHeight);
            }
            if(this.isPolygonCropEnabled && this.fillPoints.length > 0){
                drawFill(this.outputCanvasContext, this.fillPoints);
            }
        },
        clearPolygonCrop(){
            this.fillPoints = [];
            this.polygonCropPoints = [];
            this.polygonCropState = PolygonCropState.NOT_STARTED;
            this.renderOutput();
        },
        exportImage(){
            saveCanvas(this.outputCanvasContext.canvas, this.exportImageName);
        },
    }
};
</script>