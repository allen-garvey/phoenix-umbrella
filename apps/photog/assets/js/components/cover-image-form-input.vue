<template>
    <div>
        <Form-Input :id="id" label="Cover image id" v-model="coverImageId" :errors="errors" input-type="number" v-if="shouldShowCoverImageInput" />

        <!-- thumbnail radio buttons based on: https://stackoverflow.com/questions/17541614/use-images-instead-of-radio-buttons -->
        <fieldset 
            class="form-group" 
            :class="$style['thumbnail-radio-container']"
            v-if="!shouldShowCoverImageInput"
        >
            <legend>Cover Image</legend>
            <label v-for="image in images" :key="image.id">
                <input type="radio" v-model="coverImageId" :value="image.id">
                <img :src="thumbnailUrlFor(image)" />
            </label>
            <Form-Field-Errors :errors="errors" />
        </fieldset>
    </div>
</template>

<style lang="scss" module>
    @import '~photog-styles/site/variables';

    //thumbnail radio buttons based on: https://stackoverflow.com/questions/17541614/use-images-instead-of-radio-buttons
    .thumbnail-radio-container{
        //hide radio
        [type=radio] { 
            position: absolute;
            opacity: 0;
            width: 0;
            height: 0;
        }

        img{
            width: 100px;
            height: 100px;
            object-fit: cover;
        }

        [type=radio] + img {
            cursor: pointer;
        }

        //checked styles
        [type=radio]:checked + img {
            border: 5px solid $photog_selected_highlight_color;
            border-radius: 4px;
        }
    }
</style>

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
        modelValue: {
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
        this.coverImageId = this.modelValue;
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
            this.$emit('update:modelValue', newValue);
        },
    },
    methods: {
        thumbnailUrlFor(image){
            return thumbnailUrlFor(image.mini_thumbnail_path);
        },
    },
}
</script>

