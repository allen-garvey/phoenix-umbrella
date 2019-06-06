<template>
    <div>
        <Form-Input :id="id" label="Cover image id" v-model="coverImageId" :errors="errors" input-type="number" v-if="shouldShowCoverImageInput" />

        <!-- thumbnail radio buttons based on: https://stackoverflow.com/questions/17541614/use-images-instead-of-radio-buttons -->
        <fieldset class="form-group thumbnail-radio-container" v-if="!shouldShowCoverImageInput">
            <legend>Cover Image</legend>
            <label v-for="image in images" :key="image.id">
                <input type="radio" v-model="coverImageId" :value="image.id">
                <img :src="thumbnailUrlFor(image)" />
            </label>
            <Form-Field-Errors :errors="errors" />
        </fieldset>
    </div>
</template>

<script>
import { thumbnailUrlFor } from '../image.js';
import FormInput from './form-input.vue';
import FormFieldErrors from './form-field-errors.vue';

export default {
    name: 'Cover-Image-Form-Input',
    props: {
        id: {
            type: String,
            required: true,
        },
        //should be number, but can't specify it or we get 
        //all kinds of problems
        value: {
            required: true,
        },
        errors: {
            type: Array
        },
        images: {
            type: Array,
            required: true,
        },
    },
    components: {
        'Form-Field-Errors': FormFieldErrors,
        'Form-Input': FormInput,
    },
    created(){
        this.coverImageId = this.value;
    },
    data(){
        return {
            coverImageId: 0,
        };
    },
    computed: {
        shouldShowCoverImageInput(){
            return this.images.length === 0;
        },
    },
    watch: {
        coverImageId(newValue){
            this.$emit('input', newValue);
        },
    },
    methods: {
        thumbnailUrlFor(image){
            return thumbnailUrlFor(image.mini_thumbnail_path);
        },
    },
}
</script>

