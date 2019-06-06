<template>
    <main class="main container" v-if="isModelLoaded">
        <div class="album-image-show-header" v-if="parent">
            <router-link :to="{name: parent.parentRouteName, params: {id: model.id}}">Back to {{model.name}}</router-link>
            <div class="album-image-nav">
                <router-link :to="parent.showRouteFor(previousImage)" v-if="previousImage">Previous</router-link>
                <div v-if="!previousImage"></div>
                <router-link :to="parent.showRouteFor(nextImage)" v-if="nextImage">Next</router-link>
            </div>
            <div class="album-image-nav-previews">
                <ul class="image-preview-list" v-scroll-to-selected-item="'.current-image'">
                    <li :class="{'current-image': image.id === imageId}" v-for="(image, i) in model.images" :key="i">
                        <router-link :to="parent.showRouteFor(image)" class="preview-container">
                            <img :src="thumbnailUrlFor(image.mini_thumbnail_path)">
                        </router-link>
                    </li>
                </ul>
            </div>
        </div>
        <div class="image-show-thumbnail-container">
            <a :href="masterUrl">
                <img :src="thumbnailUrlFor(image.thumbnail_path)"/>
            </a>
        </div>
        <div class="image-show-link-container">
            <a :href="masterUrl">View full-size</a>
        </div>
        <div>
            <button class="btn" :class="image.is_favorite ? 'btn-primary' : 'btn-outline-dark'" @click="toggleImageIsFavorite">{{image.is_favorite ? 'Favorited' : 'Click to favorite'}}</button>
        </div>
        <div class="image-show-info-section">
            <h3 class="image-info-section-heading">Info</h3>
            <dl>
                <dt>Date Taken</dt>
                <dd>{{image.creation_time.formatted.us_date}} {{image.creation_time.formatted.time}}</dd>
                <dt>Favorite</dt>
                <dd>{{image.is_favorite ? 'true' : 'false'}}</dd>
                <template v-if="image.import">
                    <dt>Import</dt>
                    <dd>
                        <router-link :to="{name: 'importsShow', params: {id: image.import.id}}" class="preview-container">
                             {{image.import.name}}
                        </router-link>
                    </dd>
                </template>
            </dl>
        </div>
        <div class="image-show-info-section" v-if="imageExif">
            <h3 class="image-info-section-heading">Exif</h3>
                <template v-for="sectionKey in Object.keys(imageExif).sort()">
                    <h4 :key="sectionKey+'_heading'" class="image-exif-heading">{{formatExifPropertyName(sectionKey)}}</h4>
                    <dl :key="sectionKey+'_list'">
                        <template v-for="sectionPropertyKey in Object.keys(imageExif[sectionKey]).sort()">
                            <dt :key="`${sectionKey}_${sectionPropertyKey}_dt`" v-if="imageExif[sectionKey][sectionPropertyKey]">{{formatExifPropertyName(sectionPropertyKey)}}</dt>
                            <dd :key="`${sectionKey}_${sectionPropertyKey}_dd`" v-if="imageExif[sectionKey][sectionPropertyKey]">{{imageExif[sectionKey][sectionPropertyKey]}}</dd>
                        </template>
                    </dl>
                </template>
        </div>
        <Image-Items-List :send-json="sendJson" heading="Albums" item-route-name="albumsShow" :items="image.albums" :unused-items-api-url="`/images/${image.id}/albums/?unused=true`" :add-items-api-url="`/images/${image.id}/albums`" items-api-name="albums" :remove-item-api-url-base="`/images/${image.id}/albums/`" :items-updated-callback="imageItemsUpdatedBuilder('albums')" />
        
        <Image-Items-List :send-json="sendJson" heading="Persons" item-route-name="personsShow" :items="image.persons" :unused-items-api-url="`/images/${image.id}/persons/?unused=true`" :add-items-api-url="`/images/${image.id}/persons`" items-api-name="persons" :remove-item-api-url-base="`/images/${image.id}/persons/`" :items-updated-callback="imageItemsUpdatedBuilder('persons')" />
    </main>
</template>

<script>
import ImageItemsList from './image-items-list.vue';
import { API_URL_BASE } from '../request-helpers';

//from: https://stackoverflow.com/questions/1026069/how-do-i-make-the-first-letter-of-a-string-uppercase-in-javascript
function capitalizeFirstLetter(string){
    return string.charAt(0).toUpperCase() + string.slice(1);
}


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
        'Image-Items-List': ImageItemsList,
    },
    directives: {
        scrollToSelectedItem: {
            inserted(el, binding){
                const selectedItemSelector = binding.value;
                const currentItem = el.querySelector(selectedItemSelector);
                if(currentItem){
                    currentItem.scrollIntoView({behavior: 'instant'});
                }
            },
        },
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
        formatExifPropertyName(s){
            return capitalizeFirstLetter(s).replace(/_/g, ' ');
        },
        imageItemsUpdatedBuilder(itemsKey){
            //because image is cached should really have callback on app to update cache,
            //but just mutating it directly should be OK for now
            return (updatedItems)=>{
                this.image[itemsKey] = updatedItems; 
            };
        },
        toggleImageIsFavorite(){
            const newIsFavorite = !this.image.is_favorite;

            const apiUrl = `${API_URL_BASE}/images/${this.image.id}`;

            const data = {
                image: {
                    id: this.image.id,
                    is_favorite: newIsFavorite,
                },
            };

            this.sendJson(apiUrl, 'PATCH', data).then((response)=>{
                this.image.is_favorite = response.data.is_favorite;
            });


        },
    }
}
</script>
