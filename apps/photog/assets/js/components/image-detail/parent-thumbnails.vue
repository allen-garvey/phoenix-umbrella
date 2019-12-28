<template>
    <div class="album-image-show-header">
            <router-link :to="{name: parent.parentRouteName, params: {id: model.id}}">Back to {{model.name}}</router-link>
            <div class="album-image-nav">
                <router-link :to="parent.showRouteFor(previousImage)" v-if="previousImage">Previous</router-link>
                <div v-else></div>
                <router-link :to="parent.showRouteFor(nextImage)" v-if="nextImage">Next</router-link>
            </div>
            <div class="album-image-nav-previews">
                <ul class="image-preview-list" v-scroll-to-selected-item="'.current-image'">
                    <li :class="{'current-image': image.id === imageId}" v-for="(image, i) in model.images" :key="i">
                        <router-link :to="parent.showRouteFor(image)" class="preview-container">
                            <img :src="thumbnailUrlFor(image.mini_thumbnail_path)">
                        </router-link>
                    </li>
                </ul>
            </div>
        </div>
</template>

<script>
export default {
    props: {
        parent: {
            type: Object,
            required: true,
        },
        model: {
            type: Object,
            required: true,
        },
        imageId: {
            type: Number,
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
    directives: {
        scrollToSelectedItem: {
            inserted(el, binding){
                const selectedItemSelector = binding.value;
                const currentItem = el.querySelector(selectedItemSelector);
                if(currentItem){
                    currentItem.scrollIntoView({behavior: 'instant'});
                }
            },
        },
    },
};
</script>