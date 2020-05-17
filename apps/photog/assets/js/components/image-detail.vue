<template>
    <main class="main container" v-if="isModelLoaded">
        <Parent-Thumbnails
            :parent="parent"
            :model="model"
            :image-id="imageId"
            :thumbnail-url-for="thumbnailUrlFor"
            :previous-image="previousImage"
            :next-image="nextImage" 
            v-if="parent"
        >
        </Parent-Thumbnails>
        <div :class="$style['image-show-thumbnail-container']">
            <a :href="masterUrl" target="_blank" rel="noreferrer">
                <img :src="thumbnailUrlFor(image.thumbnail_path)"/>
            </a>
        </div>
        <div :class="$style['image-show-link-container']">
            <a :href="masterUrl" target="_blank" rel="noreferrer">View full-size</a>
            <a :href="amazonUrl" v-if="amazonUrl" target="_blank" rel="noreferrer">View in Amazon Photos</a>
        </div>
        <div>
            <button class="btn" :class="image.is_favorite ? 'btn-primary' : 'btn-outline-dark'" @click="toggleImageIsFavorite">{{image.is_favorite ? 'Favorited' : 'Click to favorite'}}</button>
        </div>
        <Image-Info
            :image="image"
            :update-image="updateImage"
        >
        </Image-Info>
        <Exif-Info :image-exif="imageExif" v-if="imageExif"></Exif-Info>
        <Image-Items-List :send-json="sendJson" heading="Albums" item-route-name="albumsShow" :items="image.albums" :unused-items-api-url="`/images/${image.id}/albums/?unused=true`" :add-items-api-url="`/images/${image.id}/albums`" items-api-name="albums" :remove-item-api-url-base="`/images/${image.id}/albums/`" :items-updated-callback="imageItemsUpdatedBuilder('albums')" />
        
        <Image-Items-List :send-json="sendJson" heading="Persons" item-route-name="personsShow" :items="image.persons" :unused-items-api-url="`/images/${image.id}/persons/?unused=true`" :add-items-api-url="`/images/${image.id}/persons`" items-api-name="persons" :remove-item-api-url-base="`/images/${image.id}/persons/`" :items-updated-callback="imageItemsUpdatedBuilder('persons')" />
    </main>
</template>

<style lang="scss" module>
    .image-show-thumbnail-container{
        display: flex;
        justify-content: center;
    }
    .image-show-link-container{
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
</style>

<script>
import ParentThumbnails from './image-detail/parent-thumbnails.vue';
import ImageInfo from './image-detail/image-info.vue';
import ImageItemsList from './image-detail/image-items-list.vue';
import ExifInfo from './image-detail/exif-info.vue';
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
        modelApiPath: {
            type: String,
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
        'Parent-Thumbnails': ParentThumbnails,
        'Image-Info': ImageInfo,
        'Image-Items-List': ImageItemsList,
        'Exif-Info': ExifInfo,
    },
    created(){
        this.setup();
    },
    data() {
        return {
            model: null,
            imageModel: null, //for when the model is the parent of the image
            modelIndex: -1, //when model is parent, the index of the current image in the image array
            imageExif: null,
        }
    },
    computed: {
        isModelLoaded(){
            return this.model && this.image;
        },
        masterUrl(){
            return this.generateImageUrl(this.image.master_path);
        },
        amazonUrl(){
            if(!this.image.amazon_photos_id){
                return '';
            }
            return `https://www.amazon.com/photos/all/gallery/${this.image.amazon_photos_id}`;
        },
        image(){
            if(this.parent){
                return this.imageModel;
            }
            return this.model;
        },
        previousImage(){
            if(!this.parent || this.modelIndex < 0 || this.modelIndex === 0){
                return null;
            }
            return this.model.images[this.modelIndex-1];
        },
        nextImage(){
            if(!this.parent || this.modelIndex < 0 || this.model.images.length <= this.modelIndex){
                return null;
            }
            return this.model.images[this.modelIndex+1];
        },
    },
    watch: {
        '$route'(to, from){
            this.setup();
        }
    },
    methods: {
        setup(){
            this.loadModel(this.modelApiPath);
        },
        loadModel(modelPath){
            this.imageModel = null;
            this.modelIndex = -1;

            this.imageExif = null;

            this.getModel(modelPath).then((itemsJson)=>{
                this.model = itemsJson;
                
                //if parent, lookup image in parent images
                if(this.parent){
                    const imageId = this.imageId;
                    for(let i=0;i<this.model.images.length;i++){
                        const image = this.model.images[i];
                        if(image.id === imageId){
                            this.imageModel = image;
                            this.modelIndex = i;
                            break;
                        }
                    }
                }
            });

            this.getExif(this.imageId).then((imageExif)=>{
                this.imageExif = imageExif.exif;
            });
        },
        thumbnailUrlFor(thumbnailPath){
            return `/media/thumbnails/${encodeURI(thumbnailPath)}`;
        },
        generateImageUrl(rawUrl){
            return `/media/images/${encodeURI(rawUrl)}`;
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
            return this.sendJson(apiUrl, 'PATCH', data);
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
