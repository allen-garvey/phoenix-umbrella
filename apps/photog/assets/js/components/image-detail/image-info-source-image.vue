<template>
    <image-info-form
        label="Source Image"
        modelKey="source_image_id"
        inputType="number"
        :image="image"
        :updateImage="updateImage"
    >
        <router-link
            :to="{ name: 'imagesShow', params: { id: image.source_image_id, image_id: image.source_image_id } }"
            v-if="image.source_image_id"
        >
            View source image
        </router-link>
    </image-info-form>
</template>

<style lang="scss" module>
</style>

<script>
import ImageInfoForm from './image-info-form.vue';

export default {
    props: {
        image: {
            type: Object,
            required: true,
        },
        updateImage: {
            type: Function,
            required: true,
        },
    },
    components: {
        ImageInfoForm,
    },
    computed: {
    },
    methods: {
    }
};
</script>