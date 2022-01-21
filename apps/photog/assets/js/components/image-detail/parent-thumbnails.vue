<template>
    <div>
        <router-link :to="{name: parent.parentRouteName, params: {id: parent.id}}">Back to {{parentName}}</router-link>
        <div :class="$style['album-image-nav']">
            <router-link :to="parent.showRouteFor(previousImage)" v-if="previousImage">Previous</router-link>
            <div v-else></div>
            <router-link :to="parent.showRouteFor(nextImage)" v-if="nextImage">Next</router-link>
        </div>
        <!-- <thumbnail-previews 
            :parent="parent"
            :images="images"
            :imageId="image.id"
            :thumbnailUrlFor="thumbnailUrlFor"
        /> -->
    </div>
</template>

<style lang="scss" module>
    .album-image-nav{
        display: flex;
        justify-content: space-between;
        margin: 0.5em 0;
    }
</style>

<script>
// import thumbnailPreviews from './thumbnail-previews.vue';

export default {
    props: {
        parent: {
            type: Object,
            required: true,
        },
        images: {
            type: Array,
            required: true,
        },
        image: {
            type: Object,
            required: true,
        },
        thumbnailUrlFor: {
            type: Function,
            required: true,
        },
        previousImage: {
            type: Object,
        },
        nextImage: {
            type: Object,
        },
    },
    components: {
        // thumbnailPreviews,
    },
    computed: {
        parentName(){
            return this.parent.getName ? this.parent.getName(this.image) : this.parent.name;
        },
    },
};
</script>