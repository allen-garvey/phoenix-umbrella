<template>
    <div>
        <div :class="controlsClasses">
            <button 
                class="btn btn-primary" 
                @click="saveImageOrder()" 
                :style="{visibility: haveImagesBeenReordered ? 'visible' : 'hidden'}"
            >
                Save Image Order
            </button>
        </div>
        <ol :class="$style['post-album-image-list']">
            <li 
                v-for="(postImage, index) in postImages" 
                :key="postImage.id" 
                draggable="true" 
                :class="{[$style['cover-image-container']]: postImage.image.id === coverImageIdModel}" 
                @dragstart="imageDragStart($event, index)" 
                @dragover="imageDraggedOver($event, index)" 
                @drop="imageDropped($event)"
            >
                <div>
                    <a :href="postImage.image.url.self">
                        <img :src="postImage.image.url.thumbnail" :alt="postImage.image.description"/>
                    </a>
                </div>
                <div :class="$style['image-title']">
                    <a :href="postImage.image.url.self">{{postImage.image.title}}</a>
                    <p v-if="postImage.caption">{{postImage.caption}}</p>
                </div>
                <div :class="$style['image-buttons']">
                    <a :href="postImage.url.edit" class="btn btn-primary btn-sm" target="_blank">Edit</a>
                    <button class=" btn btn-primary btn-sm" v-show="postImage.image.id != coverImageIdModel" @click="setCoverImage(postImage.image.id)">Make cover image</button>
                </div>
                <div :class="$style['list-item-dragger']">&#9776;</div>
            </li>
        </ol>
    </div>
</template>

<style lang="scss" module>
    @import '~artour-styles/admin/variables';

    .post-album-image-list-controls{
        display: flex;
        justify-content: flex-end;
        padding: 1em;
        border-radius: 3px;
        margin-top: 3em;
    }

    .post-album-image-list{
        padding: 0;
        list-style-type: none;
        margin-top: 10px;
        img{
            height: 114px;
        }
        li{
            width: 100%;
            display: flex;
            justify-content: space-between;
            border-bottom: 1px solid #ddd;
            &:last-of-type{
                border-bottom: none;
            }
            & > *{
                display: flex;
                align-items: center;
            }
            .image-title{
                width: 20em;
                flex-direction: column;
                justify-content: center;
            }
            .list-item-dragger{
                padding: 0 2em;
                font-size: 2em;
                cursor: move;
            }
        }
        .cover-image-container{
            background-color: $item_selected_color;
        }
        .image-buttons > *{
            margin-right: 1em;
            &:last-child{
                margin-right: 0;
            }
        } 
    }
</style>

<script>
import { fetchJson, sendJson } from 'umbrella-common-js/ajax.js';

export default {
    props: {
        csrfToken: {                        
            type: String,
            required: true,                                    
        },
        postImagesApiUrl: {
            type: String,                                      
            required: true,                                         
        },
        editPostApiUrl: {
            type: String,                                      
            required: true,
        },
        reorderImagesApiUrl: {
            type: String,                                      
            required: true,                                     
        },
        coverImageId: {
            type: String,
            required: true,                                      
        },
    },
    created(){
        this.fetchImages();
        this.coverImageIdModel = this.coverImageId;
    },
    data(){
        return {
            postImages: [],
            haveImagesBeenReordered: false,
            currentDragIndex: null,
            coverImageIdModel: '',
        };
    },
    computed: {
        controlsClasses(){
            return {
                [this.$style['post-album-image-list-controls']]: true,
                'list-group-item-info': this.haveImagesBeenReordered,
            };
        },
    },
    methods: {
        fetchImages(){
            return fetchJson(this.postImagesApiUrl).then((postImages)=>{
                this.postImages = postImages;
            });
        },
        setCoverImage(imageId){
            sendJson(this.editPostApiUrl, this.csrfToken, 'PATCH', {cover_image_id: imageId}).then((_response)=>{
                this.coverImageIdModel = imageId;
            });
        },
        saveImageOrder(){
            const postImageIds = this.postImages.map(postImage=>postImage.id);
            sendJson(this.reorderImagesApiUrl, this.csrfToken, 'PATCH', {post_images: postImageIds}).then((_response)=>{
                this.haveImagesBeenReordered = false;
            });
        },
        imageDragStart(e, index){
            this.currentDragIndex = index;
        },
        imageDropped(e){
            e.preventDefault();
        },
        //drag functions based on: https://www.w3schools.com/html/html5_draganddrop.asp
        //and dithermark color-dither.vue/handleColorDragover()
        imageDraggedOver(e, index){
            e.preventDefault();
            e.stopPropagation();

            if(this.currentDragIndex != index){
                let postImagesCopy = this.postImages.slice();
                const draggedImage = postImagesCopy.splice(this.currentDragIndex, 1)[0];
                postImagesCopy.splice(index, 0, draggedImage);
                this.postImages = postImagesCopy;
                this.currentDragIndex = index;
                this.haveImagesBeenReordered = true;
            }
        },
    },
}
</script>

