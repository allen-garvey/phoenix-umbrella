<template>
    <image-info-section
        heading="Info"
    >
        <dl>
            <dt>Master path</dt>
            <dd>
                <image-path 
                    :path="image.master_path"
                />
            </dd>
            <dt>Thumbnail path</dt>
            <dd>
                <image-path 
                    :path="image.thumbnail_path"
                />
            </dd>
            <dt>Date Taken</dt>
            <dd>{{image.creation_time.formatted.us_date}} {{image.creation_time.formatted.time}}</dd>
            <completion-date 
                :image="image"
                :update-image="updateImage"
            />
            <dt>Favorite</dt>
            <dd>{{image.is_favorite ? 'true' : 'false'}}</dd>
            <dt>Import</dt>
            <dd>
                <router-link 
                    :to="{name: 'importsShow', params: {id: image.import.id}}" 
                    class="preview-container"
                >
                    {{image.import.name}}
                </router-link>
            </dd>
            <template v-if="image.import.notes">
                <dt>Import notes</dt>
                <dd>{{ image.import.notes }}</dd>
            </template>
        </dl>
    </image-info-section>
</template>

<style lang="scss" module>

</style>

<script>
import ImageInfoSection from './image-info-section.vue';
import ImagePath from './image-info-image-path.vue';
import CompletionDate from './image-info-completion-date.vue';

export default {
    props: {
        image: {
            type: Object,
            required: true
        },
        updateImage: {
            type: Function,
            required: true,
        },
    },
    components: {
        ImageInfoSection,
        ImagePath,
        CompletionDate,
    },
    computed: {
    },
    methods: {
    }
};
</script>