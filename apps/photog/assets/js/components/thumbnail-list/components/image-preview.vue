<template>
    <div :class="containerClasses" v-if="imageSrc">
        <div :class="$style.imageContainer">
            <img :class="$style.image" :src="imageSrc" alt="" />
        </div>
        <div v-if="content" :class="$style.content">
            {{ content }}
        </div>
    </div>
</template>

<style lang="scss" module>
    .container {
        background-color: #fff;
        border: 2px solid #000;
        box-shadow: 2px 2px 5px rgba(63, 55, 55, 0.5);
        position: fixed;
        top: 20vh;
        z-index: 10;

        &.left {
            left: 100px;
        }

        &.right {
            right: 100px;
        }
    }

    .imageContainer, .content {
        // needs to be uppercase to not collide with Sass min()
        max-width: Min(600px, 35vw);
    }

    .imageContainer {
        height: 70vh;
    }

    .image {
        display: block;
        height: 100%;
        object-fit: cover;
        max-height: 100%;
        max-width: 100%;
    }

    .content {
        background-color: #fff;
        padding: 0.5em;
        white-space: pre-line;
    }
</style>

<script>
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
        contentCallback: {
            type: Function,
        },
        miniThumbnailUrlFor: {
            type: Function,
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
            return this.miniThumbnailUrlFor(image);
        },
        content(){
            try {
                return this.contentCallback ? this.contentCallback(this.item) : null;
            }
            catch {
                return null;
            }
        },
    },
    methods: {
    }
};
</script>