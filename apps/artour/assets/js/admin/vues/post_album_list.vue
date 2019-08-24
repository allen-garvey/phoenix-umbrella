<template>
    <div>
        <div class="post-album-image-list-controls" :class="{'list-group-item-info': haveImagesBeenReordered}">
            <button class="btn btn-primary" @click="saveImageOrder()" :style="{visibility: haveImagesBeenReordered ? 'visible' : 'hidden'}">Save Image Order</button>
        </div>
        <ol class="post-album-image-list">
            <li v-for="(postImage, index) in postImages" :key="postImage.id" draggable="true" :class="{'cover-image-container': postImage.image.id === coverImageId}" @dragstart="imageDragStart($event, index)" @dragover="imageDraggedOver($event, index)" @drop="imageDropped($event)">
                <div>
                    <a :href="postImage.image.url.self"><img :src="postImage.image.url.thumbnail" :alt="postImage.image.description"/></a>
                </div>
                <div class="image-title">
                    <a :href="postImage.image.url.self">{{postImage.image.title}}</a>
                    <p v-if="postImage.caption">{{postImage.caption}}</p>
                </div>
                <div class="image-buttons">
                    <a :href="postImage.url.edit" class="btn btn-default" target="_blank">Edit</a>
                    <button class=" btn btn-primary" v-show="postImage.image.id != coverImageId" @click="setCoverImage(postImage.image.id)">Make cover image</button>
                </div>
                <div class="list-item-dragger">&#9776;</div>
            </li>
        </ol>

    </div>
</template>

<script>
import Vue from 'vue';
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
    },
    data(){
        return {
            postImages: [],
            haveImagesBeenReordered: false,
            currentDragIndex: null,
        };
    },
    computed: {

    },
    watch: {
    },
    methods: {
        fetchImages(){
            return fetchJson(this.postImagesApiUrl).then((postImages)=>{
                this.postImages = postImages;
            });
        },
        setCoverImage(imageId){
            sendJson(this.editPostApiUrl, this.csrfToken, 'PATCH', {cover_image_id: imageId}).then((_response)=>{
                this.coverImageId = imageId;
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

