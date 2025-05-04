<template>
    <div>
        <Form-Section
            :heading="headingText"
            :backLink="backLink"
            :save="save"
            :isSaving="isSaving"
            v-if="isInitialLoadComplete"
        >
            <template v-slot:inputs>
                <Form-Input
                    :id="idForField('name')"
                    label="Name"
                    :focus="true"
                    v-model="clan.name"
                    :errors="errors.name"
                />
            </template>
        </Form-Section>
        <div
            class="container"
            :class="$style.personsContainer"
            v-if="this.persons.length > 0"
        >
            <h2>Persons</h2>
            <div class="form-group">
                <ul class="spread-content">
                    <li v-for="person in persons" :key="person.id">
                        <input
                            type="checkbox"
                            :id="idForPerson(person)"
                            :checked="personsActive[person.id]"
                            @change="personChecked(person.id)"
                        />
                        <label :for="idForPerson(person)">{{
                            person.name
                        }}</label>
                    </li>
                </ul>
                <div
                    class="pull-right"
                    :class="$style.btnContainer"
                    v-if="isEditForm"
                >
                    <spinner-button
                        :isLoading="isSaving"
                        :buttonClasses="['btn-success']"
                        buttonType="submit"
                        buttonText="Update persons"
                        spinnerText="Saving..."
                        @buttonClick="updatePersons()"
                    />
                </div>
            </div>
        </div>
    </div>
</template>

<style lang="scss" module>
.personsContainer {
    padding-bottom: 4rem;
}
.btnContainer {
    margin-top: 3rem;
}
</style>

<script>
import { formMixinBuilder } from './mixins/form-mixin.js';
import { albumAndPersonFormMixinBuilder } from './mixins/album-and-person-form-mixin.js';
import { toApiResource } from '../form-helpers.js';
import { API_URL_BASE } from '../request-helpers.js';

import SpinnerButton from './spinner-button.vue';

export default {
    props: {
        modelId: {
            type: Number,
        },
        getModel: {
            type: Function,
            required: true,
        },
    },
    components: {
        SpinnerButton,
    },
    mixins: [formMixinBuilder(), albumAndPersonFormMixinBuilder()],
    beforeRouteEnter(to, from, next) {
        //unfortunately has to be duplicated here
        //since beforeRouteEnter can't be added via mixin
        next(self => {
            self.previousRoute = from;
        });
    },
    data() {
        return {
            //clan is for our edits, model is the immutable clan response from the api
            clan: {},
            persons: [],
            personsActive: {},
            resourceApiUrlBase: `/clans`,
            routeBase: 'clans',
        };
    },
    computed: {
        headingText() {
            if (this.isEditForm) {
                return `Edit ${this.model.name}`;
            }
            return 'New Clan';
        },
        backLink() {
            if (this.isEditForm) {
                return { name: 'clansShow', params: { id: this.modelId } };
            }
            return { name: 'clansIndex' };
        },
    },
    methods: {
        idForPerson(person) {
            return `clan_person_${person.id}_checkbox_id`;
        },
        personChecked(personId) {
            this.personsActive[personId] = !this.personsActive[personId];
        },
        getPersonIdsForSave() {
            return this.persons.reduce((personIds, person) => {
                if (this.personsActive[person.id]) {
                    personIds.push(person.id);
                }
                return personIds;
            }, []);
        },
        updatePersons() {
            this.isSaving = true;
            const person_ids = this.getPersonIdsForSave();
            this.sendJson(
                `${API_URL_BASE}/clans/${this.clan.id}/persons`,
                'PUT',
                { person_ids }
            ).then(res => {
                this.isSaving = false;
                if (!res.error) {
                    this.saveSuccessful(this.clan);
                }
            });
        },
        setupModel(clan = null) {
            this.getModel('/persons').then(persons => {
                this.persons = persons;
            });

            //edit form
            if (clan) {
                this.clan = {
                    id: clan.id,
                    name: clan.name,
                };

                this.personsActive = clan.person_ids.reduce(
                    (personsActive, personId) => {
                        personsActive[personId] = true;
                        return personsActive;
                    },
                    {}
                );
            }
            //new form
            else {
                const clan = {
                    name: '',
                };
                this.clan = clan;
            }
        },
        idForField(fieldName) {
            return `id_clan_${fieldName}_input`;
        },
        getResourceForSave() {
            const data = { clan: toApiResource(this.clan) };
            if (this.isCreateForm) {
                const person_ids = this.getPersonIdsForSave();
                if (person_ids.length > 0) {
                    data.person_ids = person_ids;
                }
            }
            return data;
        },
        saveSuccessful(clan) {
            const modelId = clan.id;
            const redirectPath =
                this.successRedirect === '1'
                    ? this.previousRoute
                    : { name: 'clansShow', params: { id: modelId } };
            redirectPath.state = {
                flashMessage: JSON.stringify([
                    `${clan.name} ${this.isEditForm ? 'updated' : 'created'}`,
                    'info',
                ]),
            };
            this.$router.push(redirectPath);
        },
    },
};
</script>
