<template>
<div>
    <Form-Section :heading="headingText" :back-link="backLink" :save="save" v-if="isInitialLoadComplete">
        <template v-slot:inputs>
            <Form-Input :id="idForField('name')" label="Name" v-model="album.name" :errors="errors.name" />

            <Form-Input :id="idForField('description')" label="Description" v-model="album.description" :errors="errors.description" input-type="textarea" :textarea-rows="4" />

            <Cover-Image-Form-Input :id="idForField('cover_image_id')" :errors="[errors.cover_image, errors.cover_image_id]" :images="imagesInModel" v-model="album.cover_image_id" />
        </template>
    </Form-Section>
    <div class="album-form-tags-container container" v-if="isEditForm && this.tags.length > 0">
        <h2>Tags</h2>
        <div class="form-group">
            <ul class="spread-content">
                <li v-for="tag in tags" :key="tag.id">
                    <input type="checkbox" :id="idForTag(tag)" :checked="tagsActive[tag.id]" @change="tagChecked(tag.id)" />
                    <label :for="idForTag(tag)">{{tag.name}}</label>
                </li>
            </ul>
            <div class="pull-right btn-container"><button class="btn btn-success" @click="updateTags()">Update tags</button></div>
        </div>
    </div>
</div>
</template>

<script>
import Vue from 'vue';

import { formMixinBuilder } from './mixins/form-mixin.js';
import { albumAndPersonFormMixinBuilder } from './mixins/album-and-person-form-mixin.js';
import { toApiResource } from '../form-helpers.js';
import { API_URL_BASE } from '../request-helpers.js';

export default {
    name: 'Album-Form',
    props: {
        modelId: {
            type: Number,
        },
        getModel: {
            type: Function,
            required: true,
        },
    },
    mixins: [formMixinBuilder(), albumAndPersonFormMixinBuilder()],
    data() {
        return {
            //album is for our edits, model is the immutable album response from the api
            album: {},
            tags: [],
            tagsActive: {},
            resourceApiUrlBase: `${API_URL_BASE}/albums`,
        }
    },
    computed: {
        headingText(){
            if(this.isEditForm){
                return `Edit ${this.model.name}`;
            }
            return 'New Album';
        },
        backLink(){
            if(this.isEditForm){
                return {name: 'albumsShow', params: {id: this.modelId}};
            }
            return {name: 'albumsIndex'};
        },
    },
    methods: {
        idForTag(tag){
            return `album_tag_${tag.id}_checkbox_id`;
        },
        tagChecked(tagId){
            Vue.set(this.tagsActive, tagId, !this.tagsActive[tagId]);
        },
        updateTags(){
            const tag_ids = this.tags.reduce((tagIds, tag)=>{
                if(this.tagsActive[tag.id]){
                    tagIds.push(tag.id);
                }
                return tagIds;
            }, [])
            this.sendJson(`${API_URL_BASE}/albums/${this.album.id}/tags`, 'PUT', {tag_ids}).then((res)=>{
                if(!res.error){
                    this.saveSuccessful(this.album);
                }
            });
        },
        setupModel(album=null){
            //edit form
            if(album){
                this.getModel('/tags').then((tags)=>{
                    this.tags = tags;
                });

                this.album = {
                    id: album.id,
                    name: album.name,
                    description: album.description,
                    cover_image_id: album.cover_image.id,
                };

                this.tagsActive = album.tags.reduce((tagsActive, tag)=>{
                    tagsActive[tag.id] = true;
                    return tagsActive;
                }, {});
            }
            //new form
            else{
                const album = {};
                if(this.images){
                    album['cover_image_id'] = this.images[0].id;
                }
                this.album = album;
            }
        },
        idForField(fieldName){
            return `id_album_${fieldName}_input`;
        },
        getResourceForSave(){
            const data = {album: toApiResource(this.album)};
            if(this.isCreateForm && this.images){
                data['image_ids'] = this.images.map(image => image.id);
            }
            return data;
        },
        saveSuccessful(album){
            const modelId = album.id;
            const redirectPath = this.successRedirect ? this.successRedirect(modelId) : {name: 'albumsShow', params: {id: modelId}};
            redirectPath.params.flashMessage = [`${album.name} ${this.isEditForm ? 'updated' : 'created'}`, 'info'];
            this.$router.push(redirectPath);
        },
    }
}
</script>
