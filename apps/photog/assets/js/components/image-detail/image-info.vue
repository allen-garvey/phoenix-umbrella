<template>
    <image-info-section heading="Info">
        <dl>
            <!-- ID -->
            <dt>ID</dt>
            <dd v-if="!hasParent">{{ image.id }}</dd>
            <dd v-else>
                <router-link
                    :to="{ name: 'imagesShow', params: { id: image.id } }"
                >
                    {{ image.id }}
                </router-link>
            </dd>

            <!-- Master path -->
            <dt>Master path</dt>
            <dd>
                <image-path :path="image.master_path" />
            </dd>

            <!-- Thumbnail path -->
            <dt>Thumbnail path</dt>
            <dd>
                <image-path :path="image.thumbnail_path" />
            </dd>

            <!-- Image date -->
            <image-info-form
                label="Date Taken"
                type="datetime"
                :imageId="image.id"
                modelKey="creation_time"
                :value="image.creation_time.raw"
                :updateImage="updateImage"
            >
                <span
                    >{{ image.creation_time.formatted.us_date }}
                    {{ image.creation_time.formatted.time }}</span
                >
            </image-info-form>

            <!-- Source Image -->
            <image-info-form
                label="Source Image"
                type="number"
                :imageId="image.id"
                modelKey="source_image_id"
                :value="image.source_image_id"
                :updateImage="updateImage"
            >
                <router-link
                    :to="{
                        name: 'imagesShow',
                        params: { id: image.source_image_id },
                    }"
                    v-if="image.source_image_id"
                >
                    View source image
                </router-link>
            </image-info-form>

            <!-- Import -->
            <dt>Import</dt>
            <dd>
                <router-link
                    :to="{
                        name: 'importsShow',
                        params: { id: image.import.id },
                    }"
                    class="preview-container"
                >
                    {{ image.import.name }}
                </router-link>
            </dd>

            <!-- Import Notes -->
            <template v-if="image.import.notes">
                <dt>Import notes</dt>
                <dd>{{ image.import.notes }}</dd>
            </template>

            <!-- Notes -->
            <image-info-form
                label="Notes"
                :imageId="image.id"
                modelKey="notes"
                :value="image.notes"
                :updateImage="updateImage"
            >
                <span v-if="image.notes">{{ image.notes }}</span>
            </image-info-form>
        </dl>
    </image-info-section>
</template>

<style lang="scss" module></style>

<script>
import { isoFormattedDateToUs } from '../../date-helpers';

import ImageInfoSection from './image-info-section.vue';
import ImagePath from './image-info-image-path.vue';
import ImageInfoForm from './image-info-form.vue';

export default {
    props: {
        image: {
            type: Object,
            required: true,
        },
        updateImage: {
            type: Function,
            required: true,
        },
        hasParent: {
            type: Boolean,
            required: true,
        },
    },
    components: {
        ImageInfoSection,
        ImagePath,
        ImageInfoForm,
    },
    computed: {},
    methods: {
        formatIsoDate(date) {
            return isoFormattedDateToUs(date);
        },
    },
};
</script>
