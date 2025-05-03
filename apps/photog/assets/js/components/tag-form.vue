<template>
    <Form-Section
        :heading="headingText"
        :back-link="backLink"
        :save="save"
        :isSaving="isSaving"
        v-if="isInitialLoadComplete"
    >
        <template v-slot:inputs>
            <Form-Input
                :id="idForField('name')"
                label="Name"
                :focus="true"
                v-model="tag.name"
                :errors="errors.name"
            />

            <Form-Input
                :id="idForField('is_favorite')"
                label="Is Favorite"
                v-model="tag.is_favorite"
                :errors="errors.is_favorite"
                input-type="checkbox"
            />

            <div class="form-group" v-if="albums.length > 0">
                <label for="cover_album_id_input">Cover Album</label>
                <select
                    class="form-control"
                    v-model="tag.cover_album_id"
                    id="cover_album_id_input"
                    v-if="isEditForm"
                >
                    <option value=""></option>
                    <option
                        v-for="album in albums"
                        :key="album.id"
                        :value="album.id"
                    >
                        {{ album.name }}
                    </option>
                </select>
            </div>
        </template>
    </Form-Section>
</template>

<script>
import { formMixinBuilder } from './mixins/form-mixin.js';
import { toApiResource } from '../form-helpers.js';

export default {
    props: {
        modelId: {
            type: Number,
        },
    },
    mixins: [formMixinBuilder()],
    data() {
        return {
            //tag is for our edits, model is the immutable album response from the api
            tag: {},
            resourceApiUrlBase: '/tags',
            routeBase: 'tags',
        };
    },
    computed: {
        headingText() {
            if (this.isEditForm) {
                return `Edit ${this.model.name}`;
            }
            return 'New Tag';
        },
        backLink() {
            if (this.isEditForm) {
                return { name: 'tagsShow', params: { id: this.modelId } };
            }
            return { name: 'tagsIndex' };
        },
        albums() {
            return this.items.sort((albumA, albumB) =>
                albumA.name.localeCompare(albumB.name)
            );
        },
    },
    methods: {
        setupModel(tag = null) {
            //edit form
            if (tag) {
                this.tag = tag;
            }
            //new form
            else {
                this.tag = {};
            }
        },
        idForField(fieldName) {
            return `id_tag_${fieldName}_input`;
        },
        getResourceForSave() {
            // don't want to send albums
            const tag = {
                name: this.tag.name,
                is_favorite: !!this.tag.is_favorite,
                cover_album_id: this.tag.cover_album_id,
            };

            return { tag: toApiResource(tag) };
        },
        saveSuccessful(tag) {
            const flashMessage = JSON.stringify([
                `${tag.name} ${this.isEditForm ? 'updated' : 'created'}`,
                'info',
            ]);
            this.$router.push({
                name: 'tagsShow',
                params: {
                    id: tag.id,
                },
                state: {
                    flashMessage,
                },
            });
        },
    },
};
</script>
