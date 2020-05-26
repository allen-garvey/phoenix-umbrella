<template>
<div>
    <div v-if="isInitialLoadComplete && formats.length === 0">Add some formats first</div>
    <div v-if="isInitialLoadComplete && formats.length > 0">
        <file-input
            v-if="imageFiles.length < 1"
            :files-uploaded="imageFilesReplaced"
        >
        </file-input>
        <files-display
            v-if="imageFiles.length > 0"
            :images="images"
            :image-files="imageFiles"
            :formats="formats"
            :errors="errors"
            :value-changed="valueChanged"
            :save="save"
        >
        </files-display>
    </div>
</div>
</template>

<script>
import Vue from 'vue';
import FileInput from './import_images/file_input.vue';
import FilesDisplay from './import_images/files_display.vue';
import { extractImages } from '../import_images.js';
import { fetchJson, sendJson } from 'umbrella-common-js/ajax.js';

export default {
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        apiFormatIndexUrl: {
            type: String,
            required: true,
        },
        apiCreateImagesUrl: {
            type: String,
            required: true,
        },
        imagesIndexUrl: {
            type: String,
            required: true,
        },
    },
    components: {
        FileInput,
        FilesDisplay,
    },
    created(){
        fetchJson(this.apiFormatIndexUrl).then((formats)=>{
            this.formats = formats;
            this.isInitialLoadComplete = true;
        });
    },
    data(){
        return {
            isInitialLoadComplete: false,
            formats: [],
            imageFiles: [],
            images: [],
            errors: null,
        };
    },
    methods: {
        imageFilesReplaced(files){
            this.imageFiles = extractImages(files);
            this.images = this.imageFiles.map((imageFile, i)=>{
                //preview image based on: https://stackoverflow.com/questions/5802580/html-input-type-file-get-the-image-before-submitting-the-form
                const reader = new FileReader();
                reader.onload = (e)=>{
                    imageFile.src = e.target.result;
                    Vue.set(this.imageFiles, i, imageFile);
                };
                reader.readAsDataURL(imageFile.file);
                return {
                    title: imageFile.title,
                    slug: imageFile.slug,
                    format_id: this.formats[0].id,
                    description: null,
                    completion_date: null,
                    filename_large: imageFile.lg || imageFile.med,
                    filename_medium: imageFile.med,
                    filename_small: imageFile.sm,
                    filename_thumbnail: imageFile.thumb,
                };
            });
        },
        valueChanged(event, index, key){
            const newValue = event.target.value;
            const image = this.images[index];
            image[key] = newValue;
            Vue.set(this.images, index, image);
        },
        save(){
            const data = {images: this.images};
            sendJson(this.apiCreateImagesUrl, this.csrfToken, 'POST', data).then((response)=>{
                if(response.errors){
                    this.errors = response.errors.map(item=>item.errors);
                    setTimeout(()=>{
                        this.$refs.errorAlert.scrollIntoView({behavior: 'smooth'});
                    }, 0);
                    return;
                }
                //success, so navigate to images index page
                window.location.href = this.imagesIndexUrl;
            });
        },
    }
};
</script>