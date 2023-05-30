<template>
<div>
<loading-animation v-if="!isInitialLoadComplete" />
<div v-if="isInitialLoadComplete">
    <div>
        <image-title :image-id="imageId" :image-model="imageModel" />
        <div>
            <img :class="$style.image" :src="masterImageUrl" @load="imageLoaded" ref="image" v-show="shouldShowSourceImage" />
            <canvas ref="outputCanvas"></canvas>
        </div>
    </div>
    <div :class="$style.controls">
        <label>Show source image<input type="checkbox" v-model="shouldShowSourceImage"></label>
        <label>
            Threshold
            <input type="range" min="0" :max="maxThreshold" v-model.number="threshold" />
            <input type="number" min="0" :max="maxThreshold" v-model.number="threshold" />
        </label>
    </div>
</div>
</div>
</template>

<style lang="scss" module>
.image {
    max-width: unset;
}
.controls {
    position: fixed;
    top: 0;
    right: 0;
    height: 100%;
    background-color: #fff;
    width: 454px;
    border-left: 1px solid rgba(0,0,0,0.1);
    padding: 1rem;
}
</style>
<script>
import { nextTick } from 'vue';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import ImageTitle from './image-title.vue';
import { getMasterUrl } from '../../../image.js';
import { renderCanvas2, loadTexture } from '../canvas2';

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
            threshold: 0,
            shouldShowSourceImage: true,
            outputCanvasContext: null,
            offscreen2dContext: null,
            offscreenWebglContext: null,
            imageWidth: 0,
            imageHeight: 0,
            adaptiveThresholdDrawFunc: null,
            shaders: null,
        };
    },
    computed: {
        masterImageUrl(){
            return getMasterUrl(this.imageModel);
        },
        maxThreshold(){
            return 25;
        },
    },
    watch: {
        '$route'(to, from){
            nextTick().then(() => {
                this.setup();
            });
        },
        threshold(to){
            if(!this.adaptiveThresholdDrawFunc){
                return;
            }
            console.log('threshold');
            const thresholdPercent = (100 - Math.abs(to - this.maxThreshold)) / 100;
            this.adaptiveThresholdDrawFunc(thresholdPercent);
            this.outputCanvasContext.drawImage(this.offscreenWebglContext.canvas, 0, 0);
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
            this.imagWidth = image.naturalWidth;
            this.imageHeight = image.naturalHeight;
            
            this.$refs.outputCanvas.width = this.imagWidth;
            this.$refs.outputCanvas.height = this.imageHeight;
            this.outputCanvasContext = this.$refs.outputCanvas.getContext('2d');
            this.outputCanvasContext.drawImage(image, 0, 0, this.imagWidth, this.imageHeight);
            
            this.offscreen2dContext = new OffscreenCanvas(this.imagWidth, this.imageHeight).getContext('2d');
            
            this.offscreenWebglContext = document.createElement('canvas').getContext('webgl2');
            this.offscreenWebglContext.canvas.width = this.imagWidth;
            this.offscreenWebglContext.canvas.height = this.imageHeight;
            loadTexture(this.offscreenWebglContext, image);
            this.adaptiveThresholdDrawFunc = renderCanvas2(this.offscreenWebglContext, this.shaders.vertexShader, this.shaders.pixelShader, image.width, image.height);
        }
    }
};
</script>