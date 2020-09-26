<template>
    <form accept-charset="UTF-8" :action="formUrl" method="post">
        <input name="_csrf_token" type="hidden" :value="csrfToken">
        <input name="_utf8" type="hidden" value="✓">
        <div class="button-container-right">
            <button type="button" @click="toggleSelectAllImages" class="btn btn-default" v-show="images.length > 0">{{this.selectAllButtonText}}</button>
            <button type="button" @click="toggleUnusedImages" class="btn btn-default">{{this.unusedImagesButtonText}}</button>
            <button type="submit" class="btn btn-primary" :disabled="areAllImagesUnchecked">Save</button>
        </div>
        <ul :class="$style['post-add-images-list']">
            <li 
                v-for="(image, index) in images" 
                :key="index" 
                :class="{[$style['item-selected']]: imagesSelected[index]}"
            >
                <div>
                    <label>
                        <input type="checkbox" @change="imageChecked(index)" :checked="imagesSelected[index]" name="images[]" :value="image.id"/>
                        <img :src="image.url.thumbnail" :alt="image.description"/>
                    </label>
                </div>

                <div>
                    <a :href="image.url.self" target="_blank">{{image.title}}</a>
                </div>
            </li>
        </ul>
    </form>
</template>

<style lang="scss" module>
    @import '~artour-styles/admin/variables';
    
    .post-add-images-list{
        $post_add_images_item_margin: 10px;
        list-style-type: none;
        padding-left: 0;
        li{
            display: flex;
            align-items: center;
            padding: 5px 8px;
            & > *{
                margin-right: $post_add_images_item_margin;
            }
            &.item-selected{
                background-color: $item_selected_color;
            }
        }
        img{
            width: 115px;
            cursor: pointer;
        }
        input[type="checkbox"]{
            margin-right: $post_add_images_item_margin;
        }
    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';

export default {
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        formUrl: {
            type: String,
            required: true,
        },
        imagesApiUrl: {
            type: String,
            required: true,
        },
    },
    created(){
        this.fetchImages();
    },
    data(){
        return {
            //whether or not to show images that have not been used with any other posts 
            unusedImagesOnly: true,
            images: [],
            imagesSelected: [],
        };
    },
    computed: {
        //save button is disabled if every image is unchecked
        areAllImagesUnchecked(){
            return !this.imagesSelected.some((value)=>{
                return value;
            });
        },
        areAllImagesChecked(){
            return !this.imagesSelected.some((value)=>{
                return !value;
            });
        },
        ImageApiUrlFull(){
            const queryParams = this.unusedImagesOnly ? '?unused=true' : '';
            return this.imagesApiUrl + queryParams;
        },
        unusedImagesButtonText(){
            if(this.unusedImagesOnly){
                return 'All images';
            }
            return 'Unused images';
        },
        selectAllButtonText(){
            if(this.areAllImagesChecked){
                return 'Deselect all';
            }
            return 'Select all';
        },
    },
    watch: {
        unusedImagesOnly(){
            this.fetchImages();
        }
    },
    methods: {
        imageChecked(index){
            this.imagesSelected[index] = !this.imagesSelected[index];
        },
        toggleSelectAllImages(){
            if(this.areAllImagesChecked){
                this.imagesSelected = this.imagesSelected.map(() => false);
            }
            else{
                this.imagesSelected = this.imagesSelected.map(() => true);
            }
        },
        toggleUnusedImages(){
            this.unusedImagesOnly = !this.unusedImagesOnly;
        },
        fetchImages(){
            return fetchJson(this.ImageApiUrlFull).then((images)=>{
                this.images = images;
                //uncheck all images initially
                this.imagesSelected = images.map(()=>{return false;});
            });
        }
    },
}
</script>

