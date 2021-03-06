<template>
    <Form-Section :heading="headingText" :back-link="backLink" :save="save" v-if="isInitialLoadComplete">
        <template v-slot:inputs>
            <Form-Input :id="idForField('name')" label="Name" v-model="person.name" :errors="errors.name" />

            <Cover-Image-Form-Input :id="idForField('cover_image_id')" :errors="[errors.cover_image, errors.cover_image_id]" :images="imagesInModel" v-model="person.cover_image_id" />
        </template>
    </Form-Section>
</template>

<script>
import { formMixinBuilder } from './mixins/form-mixin.js';
import { albumAndPersonFormMixinBuilder } from './mixins/album-and-person-form-mixin.js';
import { toApiResource } from '../form-helpers.js';
import { API_URL_BASE } from '../request-helpers.js';

export default {
    name: 'Person-Form',
    props: {
        modelId: {
            type: Number,
        },
    },
    mixins: [formMixinBuilder(), albumAndPersonFormMixinBuilder()],
    data() {
        return {
            //person is for our edits, model is the immutable person response from the api
            person: {},
            resourceApiUrlBase: `${API_URL_BASE}/persons`,
            routeBase: 'persons',
        }
    },
    computed: {
        headingText(){
            if(this.isEditForm){
                return `Edit ${this.model.name}`;
            }
            return 'New Person';
        },
        backLink(){
            if(this.isEditForm){
                return {name: 'personsShow', params: {id: this.modelId}};
            }
            return {name: 'personsIndex'};
        },
    },
    methods: {
        setupModel(person=null){
            //edit form
            if(person){
                this.person = {
                    id: person.id,
                    name: person.name,
                    cover_image_id: person.cover_image.id,
                };
            }
            //new form
            else{
                const person = {};
                if(this.images){
                    person['cover_image_id'] = this.images[0].id;
                }
                this.person = person;
            }
        },
        idForField(fieldName){
            return `id_person_${fieldName}_input`;
        },
        getResourceForSave(){
            const data = {person: toApiResource(this.person)};
            if(this.isCreateForm && this.images){
                data['image_ids'] = this.images.map(image => image.id);
            }
            return data;
        },
        saveSuccessful(person){
            const modelId = person.id;
            const redirectPath = this.successRedirect ? this.successRedirect(modelId) : {name: 'personsShow', params: {id: modelId}};
            redirectPath.params.flashMessage = [`${person.name} ${this.isEditForm ? 'updated' : 'created'}`, 'info'];
            this.$router.push(redirectPath);
        },
    }
}
</script>
