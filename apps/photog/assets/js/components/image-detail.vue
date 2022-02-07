<template>
<div>
    <loading-animation v-if="!isModelLoaded" />
    <main class="main container" v-if="isModelLoaded">
        <Parent-Thumbnails
            :parent="parent"
            :images="images"
            :image="image"
            :thumbnailUrlFor="thumbnailUrlFor"
            :previousImage="previousImage"
            :nextImage="nextImage" 
            :imageIndex="modelIndex"
            v-if="parent && images"
        >
        </Parent-Thumbnails>
        <div :class="$style.imageShowThumbnailContainer">
            <a :href="masterUrl" target="_blank" rel="noreferrer">
                <img :src="thumbnailUrlFor(image.thumbnail_path)" />
            </a>
        </div>
        <div :class="$style.imageShowLinkContainer">
            <a :href="masterUrl" target="_blank" rel="noreferrer">View full-size</a>
            <a :href="amazonUrl" v-if="amazonUrl" target="_blank" rel="noreferrer">View in Amazon Photos</a>
        </div>
        <div>
            <button class="btn" :class="image.is_favorite ? 'btn-primary' : 'btn-outline-dark'" @click="toggleImageIsFavorite">{{image.is_favorite ? 'Favorited' : 'Click to favorite'}}</button>
        </div>
        <Image-Info
            :image="image"
            :updateImage="updateImage"
        />
        <Image-Versions
            :versions="image.versions"
            v-if="image.versions"
        />
        <Exif-Info 
            :imageExif="imageExif" 
            :shouldShowRequestButton="!imageExif && !hasExifBeenRequested"
            @exif-requested="loadExif"
        />
        <Image-Items-List 
            :imageId="image.id"
            :sendJson="sendJson" 
            heading="Albums" 
            itemRouteName="albumsShow" 
            :items="image.albums" 
            :unusedItemsApiUrl="`/images/${image.id}/albums/?unused=true`" 
            :addItemsApiUrl="`/images/${image.id}/albums`" 
            itemsApiName="albums" 
            removeItemApiUrlBase="/albums" 
            :itemsUpdatedCallback="imageItemsUpdatedBuilder('albums')" 
        />
        
        <Image-Items-List 
            :imageId="image.id"
            :sendJson="sendJson" 
            heading="Persons" 
            itemRouteName="personsShow"
            :items="image.persons" 
            :unusedItemsApiUrl="`/images/${image.id}/persons/?unused=true`" 
            :addItemsApiUrl="`/images/${image.id}/persons`" 
            itemsApiName="persons" 
            removeItemApiUrlBase="/persons" 
            :itemsUpdatedCallback="imageItemsUpdatedBuilder('persons')" 
        />
    </main>
</div>
</template>

<style lang="scss" module>
    .imageShowThumbnailContainer{
        display: flex;
        justify-content: center;
    }
    .imageShowLinkContainer{
        font-size: large;
        text-align: center;
        padding: 1em 0;
        display: flex;
        justify-content: center;
        flex-wrap: wrap;
        
        a{
            display: block;
            margin-left: 1em;
            &:first-of-type{
                margin-left: 0;
            }
        }
    }
    .infiniteObserver{
        padding-top: 20em;
    }
</style>

<script>
import { nextTick } from 'vue';

import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import ParentThumbnails from './image-detail/parent-thumbnails.vue';
import ImageInfo from './image-detail/image-info.vue';
import ImageVersions from './image-detail/image-versions.vue';
import ImageItemsList from './image-detail/image-items-list.vue';
import ExifInfo from './image-detail/exif-info.vue';
import { thumbnailUrlFor, getMasterUrl } from '../image';
import { API_URL_BASE } from '../request-helpers';

export default {
    name: 'Image-Detail',
    props: {
        sendJson: {
            type: Function,
            required: true,
        },
        getModel: {
            type: Function,
            required: true,
        },
        getExif: {
            type: Function,
            required: true,
        },
        imageId: {
            type: Number,
            required: true,
        },
        parent: {
            type: Object,
        },
    },
    components: {
        LoadingAnimation,
        ParentThumbnails,
        ImageInfo,
        ImageVersions,
        ImageItemsList,
        ExifInfo,
    },
    created(){
        this.setup();
    },
    data() {
        return {
            isModelLoaded: false,
            model: null,
            images: null, // for when is image in parent
            hasExifBeenRequested: false,
            imageExif: null,
        }
    },
    computed: {
        masterUrl(){
            return getMasterUrl(this.image);
        },
        amazonUrl(){
            if(!this.image.amazon_photos_id){
                return '';
            }
            return `https://www.amazon.com/photos/all/gallery/${this.image.amazon_photos_id}`;
        },
        image(){
            return this.model;
        },
        modelIndex(){
            if(!this.images){
                return -1;
            }
            for(let i=0;i<this.images.length;i++){
                const image = this.images[i];
                if(image.id === this.imageId){
                    return i;
                }
            }

        },
        previousImage(){
            if(!this.images || this.modelIndex < 0 || this.modelIndex === 0){
                return null;
            }
            return this.images[this.modelIndex-1];
        },
        nextImage(){
            if(!this.images || this.modelIndex < 0 || this.images.length <= this.modelIndex){
                return null;
            }
            return this.images[this.modelIndex+1];
        },
    },
    watch: {
        '$route'(to, from){
            nextTick().then(() => {
                this.setup();
            });
        }
    },
    methods: {
        setup(){
            this.isModelLoaded = false;
            this.hasExifBeenRequested = false;
            this.imageExif = null;
            this.loadModel(`/images/${this.imageId}`);
            this.loadExif(true);
        },
        loadModel(modelPath){
            const modelPromise = this.getModel(modelPath);
            const imagesPromise = this.parent?.imagesApiPath ? this.getModel(this.parent.imagesApiPath) : Promise.resolve(null);

            Promise.all([modelPromise, imagesPromise]).then(([model, images]) => {
                this.model = model;
                this.images = images;
                this.isModelLoaded = true;
            });
        },
        loadExif(onlyIfCached = false){
            if(!onlyIfCached){
                this.hasExifBeenRequested = true;
            }
            this.getExif(this.imageId, { onlyIfCached }).then((imageExif)=>{
                if(imageExif){
                    this.imageExif = imageExif.exif;
                }
            });
        },
        thumbnailUrlFor(thumbnailPath){
            return thumbnailUrlFor(thumbnailPath);
        },
        onKeyPressed(key){
            switch(key){
                case 'ArrowLeft':
                    this.keyLeftAction();
                    break;
                case 'ArrowRight':
                    this.keyRightAction();
                    break;
            }
        },
        keyLeftAction(){
            if(this.previousImage){
                this.$router.push(this.parent.showRouteFor(this.previousImage));
            }
        },
        keyRightAction(){
            if(this.nextImage){
                this.$router.push(this.parent.showRouteFor(this.nextImage));
            }
        },
        imageItemsUpdatedBuilder(itemsKey){
            //because image is cached should really have callback on app to update cache,
            //but just mutating it directly should be OK for now
            return (updatedItems)=>{
                this.image[itemsKey] = updatedItems; 
            };
        },
        updateImage(data){
            const apiUrl = `${API_URL_BASE}/images/${this.image.id}`;
            return this.sendJson(apiUrl, 'PATCH', data).then(() => this.loadModel(`/images/${this.imageId}`));
        },
        toggleImageIsFavorite(){
            const newIsFavorite = !this.image.is_favorite;

            const data = {
                image: {
                    id: this.image.id,
                    is_favorite: newIsFavorite,
                },
            };

            this.updateImage(data).then((response)=>{
                this.image.is_favorite = response.data.is_favorite;
            });
        },
    }
}
</script>
