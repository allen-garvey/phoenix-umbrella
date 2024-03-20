<template>
    <div class="main container">
        <loading-animation v-if="!areImagesLoaded" />
        <template v-else>
            <div :class="$style.imageContainer" ref="imageContainer">
                <img :src="thumbnailUrlFor(image)" @click="goFullScreen" />
            </div>
            <div :class="$style.linksContainer">
                <router-link :to="parentRoute">Go to {{ parentName }}</router-link>
                <span>{{ currentImageIndex + 1 }} / {{ images.length }}</span>
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

    .linksContainer {
        margin-top: 2em;
        display: flex;
        justify-content: space-between;
    }
</style>

<script>
import { nextTick } from 'vue';

import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';

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
        },
        thumbnailUrlFor: {
            type: Function,
            required: true,
        },
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
    },
    watch: {
        apiPath(){
            this.setup();
        },
    },
    methods: {
        setup(){
            const imageIndexFromUrl = parseInt(window.location.hash.replace(/^#/, ''));

            this.areImagesLoaded = false;
            this.currentImageIndex = isNaN(imageIndexFromUrl) || imageIndexFromUrl < 0 ? 0 : imageIndexFromUrl;
            this.images = [];

            this.getModel(this.apiPath).then((images) => {
                if(this.currentImageIndex >= images.length){
                    this.currentImageIndex = images.length - 1;
                }
                
                this.images = images;
                this.areImagesLoaded = true;

                nextTick().then(() => {
                    this.goFullScreen();
                });
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