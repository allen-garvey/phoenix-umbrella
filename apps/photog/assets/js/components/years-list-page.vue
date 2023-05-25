<template>
    <div class="main container">
        <h2>{{ title }}</h2>
        <ul 
            :class="{
                [$style.list]: true, 
                [$style.editMode]: yearBeingEdited !== null,
            }"
            v-if="isInitialLoadComplete"
        >
            <li 
                v-for="year in years" 
                :key="year.year" 
                :class="{
                    [$style.item]: true,
                    [$style.edit]: year.year == yearBeingEdited?.year,
                }"
            >
                <router-link :to="pathForYear(year)">
                    {{ year.year }}
                    <span :class="$style.count">({{ year.count }})</span>
                </router-link>
                <router-link :to="pathForYear(year)" v-if="year.mini_thumbnail_path">
                    <img :src="thumbnailUrlFor(year.mini_thumbnail_path)" :class="$style.coverImage" />
                </router-link>
                <router-link 
                    :to="pathForYear(year)" 
                    :class="$style.description"
                    v-if="year.year !== yearBeingEdited?.year"
                >
                    {{ year.description }}
                </router-link>
                <button 
                    class="btn btn-primary" 
                    @click="editYear(year)" 
                    :class="$style.editButton"
                >
                    Edit
                </button>
                <form 
                    :class="$style.editContainer"
                    v-if="year.year == yearBeingEdited?.year"
                    @submit.prevent="save()"
                >
                    <input 
                        class="form-control" 
                        :class="$style.descriptionInput" 
                        v-model="yearBeingEditedTemp.description" 
                        v-focus 
                    />
                    <input 
                        class="form-control" 
                        :class="$style.numberInput" 
                        v-model="yearBeingEditedTemp.cover_image_id" 
                        type="number"
                    />
                    <button 
                        class="btn btn-outline-dark" 
                        :class="$style.cancelButton" 
                        @click="cancelEdit()" 
                        type="button"
                    >
                        Cancel
                    </button>
                    <button class="btn btn-success" type="submit">Save</button>
                </form>
            </li>
        </ul>
        <loading-animation v-if="!isInitialLoadComplete" />
    </div>
</template>

<style lang="scss" module>
    .list {
        margin-top: 1rem;
        font-size: 2.1rem;
    }

    .item {
        display: flex;
        align-items: center;
        min-height: 4rem;

        &:hover {
            .editButton {
                visibility: visible;
            }
        }

        .editButton {
            visibility: hidden;
            margin-left: 0.5rem;
        }

        .editMode & .editButton {
            display: none;
        }
    }

    .description {
        font-size: 1.2rem;
        margin-left: 1em;
    }

    .count {
        display: inline-block;
        color: #aaa;
        font-size: 1.2rem;
        margin-left: 0.2em;
        margin: 0 1rem 0 -4px;
        min-width: 2em;
    }

    .coverImage {
        width: 175px;
        height: 175px;
        object-fit: cover;
        border-radius: 4px;
    }

    .editContainer {
        display: inline-flex;
    }

    .cancelButton {
        margin: 0 0.5rem 0;
    }

    .descriptionInput {
        margin-left: 1rem;
        width: 350px;
    }

    .numberInput {
        width: 7em;
        margin-left: 1rem;
    }
</style>

<script>
import { nextTick } from 'vue';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import focus from 'umbrella-common-js/vue/directives/focus.js';
import { API_URL_BASE } from '../request-helpers.js';
import { thumbnailUrlFor } from '../image.js';

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
        sendJson: {
            type: Function,
            required: true,
        },
    },
    components: {
        LoadingAnimation,
    },
    directives: {
        focus,
    },
    data() {
        return {
            isInitialLoadComplete: false,
            years: [],
            yearBeingEdited: null,
            yearBeingEditedTemp: null,
        }
    },
    created(){
        this.setup();
    },
    watch: {
        '$route'(to, from){
            nextTick().then(() => {
                this.setup();
            });
        }
    },
    computed: {
        title(){
            return 'Albums for Year';
        },
    },
    methods: {
        setup(forceRefresh=false){
            this.isInitialLoadComplete = false;
            this.years = [];

            this.getModel('/albums/years/index', { forceRefresh }).then(years => {
                this.years = years;
                this.isInitialLoadComplete = true;
            });
        },
        editYear(year){
            this.yearBeingEdited = year;
            this.yearBeingEditedTemp = { ...year };
        },
        cancelEdit(){
            this.yearBeingEdited = null;
        },
        save(){
            const params = {
                description: this.yearBeingEditedTemp.description || null,
                cover_image_id: this.yearBeingEditedTemp.cover_image_id || null,
            };
            if(!params.description && !params.cover_image_id){
                this.sendJson(`${API_URL_BASE}/years/${this.yearBeingEdited.year}`, 'DELETE');
            }
            else {
                const forceRefresh = params.cover_image_id !== this.yearBeingEdited.cover_image_id;
                this.sendJson(
                    `${API_URL_BASE}/years/${this.yearBeingEdited.year}`, 
                    'PUT', 
                    {
                        description: this.yearBeingEditedTemp.description || null,
                        cover_image_id: this.yearBeingEditedTemp.cover_image_id || null,
                    }
                ).then(() => { 
                    if(forceRefresh){
                        this.setup(true);
                    }
                });
            }

            this.yearBeingEdited.description = params.description;
            this.yearBeingEdited.cover_image_id = params.cover_image_id;
            this.yearBeingEdited = null;
        },
        thumbnailUrlFor(mini_thumbnail_path){
            return thumbnailUrlFor(mini_thumbnail_path);
        },
        pathForYear(year){
            return {
                name: 'albumsForYear',
                params: { year: year.year }
            };
        },
    },
};
</script>