<template>
    <h2>
        <router-link :to="{name: 'imagesShow', params: {id: imageId}}">Editing {{ imageFileName }}</router-link>
    </h2>
</template>

<style lang="scss" module>

</style>

<script>
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
            const fileSplit = this.imageModel.master_path.split('/');
            return fileSplit[fileSplit.length - 1];
        },
    },
};
</script>