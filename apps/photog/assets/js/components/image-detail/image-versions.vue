<template>
    <image-info-section
        heading="Versions"
    >
        <ul>
            <li
                v-for="image_id in versions"
                :key="image_id"
            >
                 <router-link
                    :to="{ name: 'imagesShow', params: { id: image_id } }"
                >
                    Image {{ image_id }}
                </router-link>
            </li>
        </ul>
    </image-info-section>
</template>

<style lang="scss" module>

</style>

<script>
import ImageInfoSection from './image-info-section.vue';

export default {
    props: {
        versions: {
            type: Array,
            required: true
        },
    },
    components: {
        ImageInfoSection,
    },
    computed: {
    },
    methods: {
    }
};
</script>