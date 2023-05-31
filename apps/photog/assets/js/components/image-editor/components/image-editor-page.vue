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
        <fieldset>
            <legend>Display</legend>
            <label>Show source image<input type="checkbox" v-model="shouldShowSourceImage"></label>
        </fieldset>
        <fieldset>
            <legend>Adaptive Threshold</legend>
            <label>Enable<input type="checkbox" v-model="isAdaptiveThresholdEnabled"></label>
            <label>
                Threshold
                <input type="range" min="0" :max="maxAdaptiveThreshold" v-model.number="adaptiveThreshold" />
                <input type="number" min="0" :max="maxAdaptiveThreshold" v-model.number="adaptiveThreshold" />
            </label>
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
import { clearCanvas, drawLines } from '../canvas';

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
    mounted(){
        this.setup();
    },
    data(){
        return {
            isInitialLoadComplete: false,
            imageModel: null,
            adaptiveThreshold: 15,
            isAdaptiveThresholdEnabled: false,
            shouldShowSourceImage: true,
            outputCanvasContext: null,
            offscreen2dContext: null,
            offscreenWebglContext: null,
            polygonCrop2dContext: null,
            imageWidth: 0,
            imageHeight: 0,
            adaptiveThresholdDrawFunc: null,
            shaders: null,
            polygonCropPoints: [],
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
            let x = e.offsetX;
            let y = e.offsetY;

            // if polygon has at least 2 sides already, and so can be closed,
            // and point clicked is close enough, close the polygon
            if(this.polygonCropPoints.length >= 4){
                const firstX = this.polygonCropPoints[0];
                const firstY = this.polygonCropPoints[1]
                const xDistance = x - firstX;
                const yDistance = y - firstY;
                const distance = Math.sqrt(xDistance * xDistance + yDistance * yDistance);

                if(distance < 10) {
                    x = firstX;
                    y = firstY;
                }
            }

            this.polygonCropPoints = this.polygonCropPoints.concat([x, y]);
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
        },
    }
};
</script>