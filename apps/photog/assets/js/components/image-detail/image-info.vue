<template>
    <image-info-section
        heading="Info"
    >
        <dl>
            <!-- ID -->
            <dt>ID</dt>
            <dd>{{ image.id }}</dd>
            
            <!-- Master path -->
            <dt>Master path</dt>
            <dd>
                <image-path 
                    :path="image.master_path"
                />
            </dd>

            <!-- Thumbnail path -->
            <dt>Thumbnail path</dt>
            <dd>
                <image-path 
                    :path="image.thumbnail_path"
                />
            </dd>

            <!-- Image date -->
            <dt>Date Taken</dt>
            <dd>{{image.creation_time.formatted.us_date}} {{image.creation_time.formatted.time}}</dd>
            
            <!-- Completion Date -->
            <image-info-form
                label="Completion Date"
                modelKey="completion_date"
                inputType="date"
                :image="image"
                :updateImage="updateImage"
            >
                <span>{{formatIsoDate(image.completion_date)}}</span>
            </image-info-form>
            
            <!-- Source Image -->
            <image-info-form
                label="Source Image"
                modelKey="source_image_id"
                inputType="number"
                :image="image"
                :updateImage="updateImage"
            >
                <router-link
                    :to="{ name: 'imagesShow', params: { id: image.source_image_id, image_id: image.source_image_id } }"
                    v-if="image.source_image_id"
                >
                    View source image
                </router-link>
            </image-info-form>
            
            <!-- Favorite -->
            <image-info-form
                label="Favorite"
                modelKey="is_favorite"
                inputType="checkbox"
                :image="image"
                :updateImage="updateImage"
            >
                <span>{{image.is_favorite ? 'true' : 'false'}}</span>
            </image-info-form>
            
            <!-- Import -->
            <dt>Import</dt>
            <dd>
                <router-link 
                    :to="{name: 'importsShow', params: {id: image.import.id}}" 
                    class="preview-container"
                >
                    {{image.import.name}}
                </router-link>
            </dd>

            <!-- Import Notes -->
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
import { isoFormattedDateToUs } from '../../date-helpers';

import ImageInfoSection from './image-info-section.vue';
import ImagePath from './image-info-image-path.vue';
import ImageInfoForm from './image-info-form.vue';

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
        ImageInfoForm,
    },
    computed: {
    },
    methods: {
        formatIsoDate(date){
            return isoFormattedDateToUs(date);
        },
    }
};
</script>