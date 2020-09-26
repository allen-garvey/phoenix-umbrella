<template>
    <div>
        <router-link :to="{name: parent.parentRouteName, params: {id: model.id}}">Back to {{model.name}}</router-link>
        <div :class="$style['album-image-nav']">
            <router-link :to="parent.showRouteFor(previousImage)" v-if="previousImage">Previous</router-link>
            <div v-else></div>
            <router-link :to="parent.showRouteFor(nextImage)" v-if="nextImage">Next</router-link>
        </div>
        <div :class="$style['album-image-nav-previews']">
            <ul 
                :class="$style['image-preview-list']" v-scroll-to-selected-item="'.current-image'"
            >
                <li 
                    :class="{[$style['current-image']]: image.id === imageId}" 
                    v-for="(image, i) in model.images" 
                    :key="i"
                >
                    <router-link :to="parent.showRouteFor(image)">
                        <img :src="thumbnailUrlFor(image.mini_thumbnail_path)">
                    </router-link>
                </li>
            </ul>
        </div>
    </div>
</template>

<style lang="scss" module>
    .album-image-nav{
        display: flex;
        justify-content: space-between;
        margin: 0.5em 0;
    }

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
                    border: 3px solid magenta;
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