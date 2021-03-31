<template>
    <div :class="containerClasses">
        <img :class="$style.image" :src="imageSrc" alt="" />
    </div>
</template>

<style lang="scss" module>
    .container {
        // background-color: white;
        height: 500px;
        width: 500px;
        position: fixed;
        z-index: 10;

        &.left {
            left: 100px;
        }

        &.right {
            right: 100px;
        }
    }

    .image {
        height: 100%;
        object-fit: contain;
        max-height: 100%;
        max-width: 100%;
    }
</style>

<script>
import { getMasterUrl } from '../../../image';

export default {
    props: {
        item: {
            type: Object,
            required: true,
        },
        mousePosition: {
            type: Object,
            required: true,
        },
    },
    computed: {
        containerClasses(){
            const width = window.innerWidth;
            const widthHalf = width / 2;
            const mouseX = this.mousePosition.x;

            return {
                [this.$style.container]: true,
                [this.$style.left]: mouseX > widthHalf,
                [this.$style.right]: mouseX < widthHalf,
            };
        },
        imageSrc(){
            const item = this.item;
            const image = item.cover_image ? item.cover_image : item;
            return getMasterUrl(image);
        },
    },
    methods: {
    }
};
</script>