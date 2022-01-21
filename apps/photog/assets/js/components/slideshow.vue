<template>
    <div class="main container">
        <loading-animation v-if="!areImagesLoaded" />
        <template v-else>
            <div :class="$style.imageContainer" ref="imageContainer">
                <img :src="thumbnailUrl" @click="goFullScreen" />
            </div>
            <div>
                <router-link :to="parentRoute">Go to {{ parentName }}</router-link>
                <router-link :to="getImageShowRoute(image)">Go to image</router-link>
            </div>
        </template>
    </div>
</template>

<style lang="scss" module>
    .imageContainer {
        display: flex;
        justify-content: center;

        img {
            cursor: pointer;
        }
    }

    :-webkit-full-screen {
        img {
            cursor: auto;
            height: 100%;
            object-fit: contain;
        }
    }

    :fullscreen {
        img {
            cursor: auto;
            height: 100%;
            object-fit: contain;
        }
    }
</style>

<script>
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';

import { thumbnailUrlFor, getMasterUrl } from '../image';
import { API_URL_BASE } from '../request-helpers';

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
        apiPath: {
            type: String,
            required: true,
        },
        getImageShowRoute: {
            type: Function,
            required: true,
        },
        parentRoute: {
            type: Object,
            required: true,
        },
        parentName: {
            type: String,
            required: true,
        }
    },
    components: {
        LoadingAnimation,
    },
    created(){
        this.setup();
    },
    data(){
        return {
            areImagesLoaded: false,
            currentImageIndex: 0,
            images: [],
        };
    },
    computed: {
        image(){
            return this.images[this.currentImageIndex];
        },
        thumbnailUrl(){
            return thumbnailUrlFor(this.image.thumbnail_path);
        },
        masterUrl(){
            return getMasterUrl(this.image);
        },
    },
    watch: {
        apiPath(){
            this.setup();
        },
    },
    methods: {
        setup(){
            this.areImagesLoaded = false;
            this.currentImageIndex = 0;
            this.images = [];

            this.getModel(this.apiPath).then((images) => {
                this.images = images;
                this.areImagesLoaded = true;
            });
        },
        onKeyPressed(key){
            if(!this.areImagesLoaded){
                return;
            }
            switch(key){
                case 'ArrowLeft':
                    if(this.currentImageIndex > 0){
                        this.currentImageIndex--;
                    }
                    break;
                case 'ArrowRight':
                    if(this.currentImageIndex < this.images.length - 1){
                        this.currentImageIndex++;
                    }
                    break;
            }
        },
        goFullScreen(){
            if(document.fullscreenElement){
                return;
            }
            const imageContainer = this.$refs.imageContainer;

            if(imageContainer.requestFullscreen){
                imageContainer.requestFullscreen();
            }
            else if(imageContainer.webkitRequestFullscreen){
                imageContainer.webkitRequestFullscreen();
            }
        },
    }
};
</script>