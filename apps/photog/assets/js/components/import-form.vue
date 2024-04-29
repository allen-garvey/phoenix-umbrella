<template>
    <Form-Section :heading="headingText" :back-link="backLink" :save="save" v-if="isInitialLoadComplete">
        <template v-slot:inputs>
            <Form-Input 
                :id="idForField('notes')" 
                label="Notes" 
                v-model="importModel.notes" 
                :errors="errors.notes" 
                input-type="textarea" 
                :textarea-rows="4" 
            />
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
        miniThumbnailUrlFor: {
            type: Function,
            required: true,
        },
    },
    mixins: [formMixinBuilder()],
    data() {
        return {
            //importModel is for our edits, model is the immutable album response from the api
            importModel: {},
            resourceApiUrlBase: '/imports',
            routeBase: 'imports',
        }
    },
    computed: {
        headingText(){
            if(this.isEditForm){
                return `Edit ${this.model.name}`;
            }
            return 'New Import';
        },
        backLink(){
            if(this.isEditForm){
                return {name: 'importsShow', params: {id: this.modelId}};
            }
            return {name: 'importsIndex'};
        },
    },
    methods: {
        setupModel(importModel=null){
            //edit form
            if(importModel){
                this.importModel = {
                    notes: importModel.notes,
                    cover_image_id: importModel.cover_image.id,
                };
            }
            //new form
            else{
                this.importModel = {};
            }
        },
        idForField(fieldName){
            return `id_import_${fieldName}_input`;
        },
        getResourceForSave(){
            // only want to send notes
            const importModel = {
                notes: this.importModel.notes,
                cover_image_id: this.importModel.cover_image_id,
            };

            return {import: toApiResource(importModel)};
        },
        saveSuccessful(importModel){
            const flashMessage = JSON.stringify([`${importModel.name} ${this.isEditForm ? 'updated' : 'created'}`, 'info']);
            this.$router.push({
                name: 'importsShow', 
                params: {
                    id: importModel.id,
                },
                state: {
                    flashMessage,
                }
            });
        },
    }
}
</script>
