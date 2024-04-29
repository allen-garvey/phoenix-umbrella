<template>
    <Form-Section :heading="headingText" :back-link="backLink" :save="save" v-if="isInitialLoadComplete">
        <template v-slot:inputs>
            <Form-Input :id="idForField('name')" label="Name" v-model="person.name" :errors="errors.name" />

            <Form-Input :id="idForField('is_favorite')" label="Is Favorite" v-model="person.is_favorite" :errors="errors.is_favorite" input-type="checkbox" />

            <Cover-Image-Form-Input 
                :id="idForField('cover_image_id')" 
                :errors="[errors.cover_image, errors.cover_image_id]" :images="imagesInModel" v-model="person.cover_image_id" 
                :miniThumbnailUrlFor="miniThumbnailUrlFor"
            />
        </template>
    </Form-Section>
</template>

<script>
import { formMixinBuilder } from './mixins/form-mixin.js';
import { albumAndPersonFormMixinBuilder } from './mixins/album-and-person-form-mixin.js';
import { toApiResource } from '../form-helpers.js';

export default {
    name: 'Person-Form',
    props: {
        modelId: {
            type: Number,
        },
    },
    mixins: [formMixinBuilder(), albumAndPersonFormMixinBuilder()],
    beforeRouteEnter(to, from, next){
        //unfortunately has to be duplicated here
        //since beforeRouteEnter can't be added via mixin
        next((self) => {
            self.previousRoute = from;
        });
    },
    data() {
        return {
            //person is for our edits, model is the immutable person response from the api
            person: {},
            resourceApiUrlBase: `/persons`,
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
                    is_favorite: person.is_favorite,
                };
            }
            //new form
            else{
                const person = {
                    is_favorite: false,
                };
                if(this.hasImages){
                    person['cover_image_id'] = this.imagesInModel[0].id;
                }
                this.person = person;
            }
        },
        idForField(fieldName){
            return `id_person_${fieldName}_input`;
        },
        getResourceForSave(){
            const data = {person: toApiResource(this.person)};
            if(this.isCreateForm && this.hasImages){
                data['image_ids'] = this.imagesInModel.map(image => image.id);
            }
            return data;
        },
        saveSuccessful(person){
            const modelId = person.id;
            const redirectPath = this.successRedirect === '1' ? this.previousRoute : {name: 'personsShow', params: {id: modelId}};
            redirectPath.state = {
                flashMessage: JSON.stringify([`${person.name} ${this.isEditForm ? 'updated' : 'created'}`, 'info']),
            };
            this.$router.push(redirectPath);
        },
    }
}
</script>
