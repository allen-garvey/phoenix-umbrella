<template>
    <Form-Section :heading="headingText" :back-link="backLink" :save="save" v-if="isInitialLoadComplete">
        <template v-slot:inputs>
            <Form-Input :id="idForField('name')" label="Name" v-model="tag.name" :errors="errors.name" />
            <select class="form-control" v-model="tag.cover_album_id">
                <option value=""></option>
                <option 
                    v-for="album in tag.albums"
                    :key="album.id"
                    :value="album.id"
                >{{album.name}}</option>
            </select>
        </template>
    </Form-Section>
</template>

<script>
import { formMixinBuilder } from './mixins/form-mixin.js';
import { toApiResource } from '../form-helpers.js';
import { API_URL_BASE } from '../request-helpers.js';

export default {
    name: 'Tag-Form',
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
            resourceApiUrlBase: `${API_URL_BASE}/tags`,
            routeBase: 'tags',
        }
    },
    computed: {
        headingText(){
            if(this.isEditForm){
                return `Edit ${this.model.name}`;
            }
            return 'New Tag';
        },
        backLink(){
            if(this.isEditForm){
                return {name: 'tagsShow', params: {id: this.modelId}};
            }
            return {name: 'tagsIndex'};
        },
    },
    methods: {
        setupModel(tag=null){
            //edit form
            if(tag){
                this.tag = tag;
            }
            //new form
            else{
                this.tag = {};
            }
        },
        idForField(fieldName){
            return `id_tag_${fieldName}_input`;
        },
        getResourceForSave(){
            // don't want to send albums
            const tag = {
                id: this.tag.id,
                name: this.tag.name,
                cover_album_id: this.tag.cover_album_id,
            };

            return {tag: toApiResource(tag)};
        },
        saveSuccessful(tag){
            const flashMessage = [`${tag.name} ${this.isEditForm ? 'updated' : 'created'}`, 'info'];
            this.$router.push({
                name: 'tagsShow', 
                params: {
                    id: tag.id,
                    flashMessage: flashMessage
                }
            });
        },
    }
}
</script>
