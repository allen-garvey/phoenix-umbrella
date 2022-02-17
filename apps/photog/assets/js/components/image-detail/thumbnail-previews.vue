<template>
    <div :class="$style['album-image-nav-previews']">
        <ul 
            :class="$style['image-preview-list']" v-scroll-to-selected-item="'.current-image'"
        >
            <li 
                :class="{[$style['current-image']]: image.id === imageId}" 
                v-for="(image, i) in images" 
                :key="i"
            >
                <router-link :to="parent.showRouteFor(image)">
                    <img :src="thumbnailUrlFor(image.mini_thumbnail_path)" loading="lazy">
                </router-link>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    @import '~photog-styles/site/variables';  
    $preview_size: 50px;

    .album-image-nav-previews{
        .image-preview-list{
            display: flex;
            overflow-x: scroll;
            overflow-y: hidden;
            li{
                box-sizing: border-box;
                height: $preview_size;
                width: $preview_size;
                flex-shrink: 0; //so horizontal scrolling works
                &.current-image{
                    border: 3px solid $photog_cover_image_color;
                }
                img{
                    height: 100%;
                    width: 100%;
                    max-width: none;
                    object-fit: cover;
                }
            }
        }
    }
</style>

<script>
export default {
    props: {
        parent: {
            type: Object,
            required: true,
        },
        imageId: {
            type: Number,
            required: true,
        },
        images: {
            type: Array,
            required: true,
        },
        thumbnailUrlFor: {
            type: Function,
            required: true,
        },
    },
    directives: {
        scrollToSelectedItem: {
            mounted(el, binding){
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