<template>
    <div>
        <div :class="$style.parentLinksContainer">
            <router-link
                :to="{
                    name: parent.parentRouteName,
                    params: { id: parent.id },
                }"
            >
                Back to {{ parentName }}
            </router-link>
            <router-link
                :to="parent.getSlideshowRoute(imageIndex)"
                v-if="parent.getSlideshowRoute"
            >
                Slideshow
            </router-link>
        </div>
        <div :class="$style.albumImageNav">
            <router-link
                :to="parent.showRouteFor(previousImage)"
                v-if="previousImage"
                >Previous</router-link
            >
            <div v-else></div>
            <router-link :to="parent.showRouteFor(nextImage)" v-if="nextImage"
                >Next</router-link
            >
        </div>
    </div>
</template>

<style lang="scss" module>
.parentLinksContainer {
    display: flex;
    justify-content: space-between;
}

.albumImageNav {
    display: flex;
    justify-content: space-between;
    margin: 0.5em 0;
}

@media (any-pointer: coarse) {
    .albumImageNav {
        margin: 2em 0;
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
        image: {
            type: Object,
            required: true,
        },
        previousImage: {
            type: Object,
        },
        nextImage: {
            type: Object,
        },
        imageIndex: {
            type: Number,
        },
    },
    computed: {
        parentName() {
            return this.parent.getName
                ? this.parent.getName(this.image)
                : this.parent.name;
        },
    },
};
</script>
