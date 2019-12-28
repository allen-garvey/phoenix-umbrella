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
            <a :href="masterUrl" target="_blank" rel="noreferrer">
                <img :src="thumbnailUrlFor(image.thumbnail_path)"/>
            </a>
        </div>
        <div class="image-show-link-container">
            <a :href="masterUrl" target="_blank" rel="noreferrer">View full-size</a>
            <a :href="amazonUrl" v-if="amazonUrl" target="_blank" rel="noreferrer">View in Amazon Photos</a>
        </div>
        <div>
            <button class="btn" :class="image.is_favorite ? 'btn-primary' : 'btn-outline-dark'" @click="toggleImageIsFavorite">{{image.is_favorite ? 'Favorited' : 'Click to favorite'}}</button>
        </div>
        <div class="image-show-info-section">
            <h3 class="image-info-section-heading">Info</h3>
            <dl>
                <dt>Master path</dt>
                <dd class="image-info-master-path">
                    <template v-for="(part, i) in masterPathSplit">
                        <span :key="i">{{part}}</span><strong :key="`${i}-slash`" class="image-info-master-path-slash">/</strong>
                    </template>
                </dd>
                <dt>Date Taken</dt>
                <dd>{{image.creation_time.formatted.us_date}} {{image.creation_time.formatted.time}}</dd>
                <dt class="image-info-completion-date">Completion Date</dt>
                <dd>
                    <div v-show="!isEditingCompletionDate">{{formatIsoDate(image.completion_date)}}</div>
                    <div v-if="isEditingCompletionDate" class="image-info-edit-container">
                        <div class="form-group"><input type="date" class="form-control" v-model="completionDateModel"/></div>
                        <div>
                            <button @click="cancelEditCompletionDate()" class="btn btn-outline-secondary btn-sm">Cancel</button>
                            <button @click="updateImageCompletionDate()" class="btn btn-success btn-sm">Save</button>
                        </div>
                    </div>
                    <div v-show="!isEditingCompletionDate">
                        <button @click="enableEditCompletionDate()" class="btn btn-outline-primary btn-sm">Edit</button>
                    </div>
                </dd>
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
        <Exif-Info :image-exif="imageExif" v-if="imageExif"></Exif-Info>
        <Image-Items-List :send-json="sendJson" heading="Albums" item-route-name="albumsShow" :items="image.albums" :unused-items-api-url="`/images/${image.id}/albums/?unused=true`" :add-items-api-url="`/images/${image.id}/albums`" items-api-name="albums" :remove-item-api-url-base="`/images/${image.id}/albums/`" :items-updated-callback="imageItemsUpdatedBuilder('albums')" />
        
        <Image-Items-List :send-json="sendJson" heading="Persons" item-route-name="personsShow" :items="image.persons" :unused-items-api-url="`/images/${image.id}/persons/?unused=true`" :add-items-api-url="`/images/${image.id}/persons`" items-api-name="persons" :remove-item-api-url-base="`/images/${image.id}/persons/`" :items-updated-callback="imageItemsUpdatedBuilder('persons')" />
    </main>
</template>

<script>
import ImageItemsList from './image-items-list.vue';
import ExifInfo from './image-detail/exif-info.vue';
import { API_URL_BASE } from '../request-helpers';
import { isoFormattedDateToUs } from '../date-helpers';

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
        'Exif-Info': ExifInfo,
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
            //following for completion date editing
            completionDateModel: null, //used for editing image completion date
            isEditingCompletionDate: false,
        }
    },
    computed: {
        isModelLoaded(){
            return this.model && this.image;
        },
        masterPathSplit(){
            return this.image.master_path.split('/');
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
            this.completionDateModel = null;
            this.isEditingCompletionDate = false;
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
                this.completionDateModel = this.image.completion_date;
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
        updateImageCompletionDate(){
            const data = {
                image: {
                    id: this.image.id,
                    completion_date: this.completionDateModel,
                },
            };
            this.updateImage(data).then((response)=>{
                this.image.completion_date = response.data.completion_date;
                this.isEditingCompletionDate = false;
            });
        },
        enableEditCompletionDate(){
            this.isEditingCompletionDate = true;
        },
        cancelEditCompletionDate(){
            this.isEditingCompletionDate = false;
        },
        formatIsoDate(date){
            return isoFormattedDateToUs(date);
        }
    }
}
</script>
