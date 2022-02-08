<template>
    <image-info-form
        label="Completion Date"
        modelKey="completion_date"
        inputType="date"
        :image="image"
        :updateImage="updateImage"
    >
        <div>{{formatIsoDate(image.completion_date)}}</div>
    </image-info-form>
</template>

<style lang="scss" module>
</style>

<script>
import { isoFormattedDateToUs } from '../../date-helpers';
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
        formatIsoDate(date){
            return isoFormattedDateToUs(date);
        },
    }
};
</script>