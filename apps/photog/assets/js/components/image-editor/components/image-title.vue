<template>
    <h2>
        <router-link :to="{name: 'imagesShow', params: {id: imageId}}">Editing {{ imageFileName }}</router-link>
    </h2>
</template>

<style lang="scss" module>

</style>

<script>
import { extractFileName } from '../path';

export default {
    props: {
        imageModel: {
            type: Object,
            required: true,
        },
        imageId: {
            type: Number,
            required: true,
        },
    },
    computed: {
        imageFileName(){
            return extractFileName(this.imageModel.master_path);
        },
    },
};
</script>