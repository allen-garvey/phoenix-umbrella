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
                <router-link 
                    :to="pathForYear(year)"
                    :class="$style.yearNameContainer"
                >
                    {{ year.year }}
                    <span :class="$style.count">({{ year.count }})</span>
                </router-link>
                <div 
                    :class="$style.yearContentContainer"
                    v-if="year.year !== yearBeingEdited?.year"
                >
                    <div :class="$style.coverImageGrid">
                        <router-link 
                            :to="pathForYear(year)" 
                            :class="$style.coverImageContainer"
                            v-for="image in year.images"
                        >
                            <img :src="miniThumbnailUrlFor(image)" :class="$style.coverImage" />
                        </router-link>
                    </div>
                    <router-link 
                        :to="pathForYear(year)" 
                        :class="$style.description"
                        v-if="year.description"
                    >
                        {{ year.description }}
                    </router-link>
                </div>
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
                    <div>
                        <label for="descriptionInputId" :class="$style.label">Description</label>
                        <input 
                            id="descriptionInputId"
                            class="form-control" 
                            :class="$style.descriptionInput" 
                            v-model="yearBeingEditedTemp.description" 
                            v-focus 
                        />
                    </div>
                    <div>
                        <label for="albumIdInputId" :class="$style.label">Album ID</label>
                        <input 
                            id="albumIdInputId"
                            class="form-control" 
                            :class="$style.numberInput" 
                            v-model="yearBeingEditedTemp.album_id" 
                            type="number"
                        />
                    </div>
                    <button 
                        class="btn btn-outline-dark" 
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
        margin-bottom: 0.5rem;

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

    .yearNameContainer {
        min-width: 4em;
    }

    .yearContentContainer {
        display: flex;
        flex-direction: column;
    }

    .description {
        font-size: 1rem;
        margin-top: 0.5rem;
    }

    .count {
        display: inline-block;
        color: #aaa;
        font-size: 1.2rem;
        margin-left: 0.2em;
        margin: 0 1rem 0 -4px;
        min-width: 2em;
    }

    .coverImageGrid {
        display: flex;
        flex-wrap: wrap;
        gap: 0.5rem;
    }

    .coverImageContainer {
        width: 175px;
        height: 175px;
    }

    .coverImage {
        width: 100%;
        height: 100%;
        object-fit: cover;
        border-radius: 4px;
    }

    .editContainer {
        display: inline-flex;
        flex-wrap: wrap;
        align-items: flex-end;
        gap: 1rem;
        margin: 2rem 0;
    }

    .label {
        font-size: 0.8rem;
    }

    .descriptionInput {
        width: 20em;
    }

    .numberInput {
        width: 6em;
    }
</style>

<script>
import { nextTick } from 'vue';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import focus from 'umbrella-common-js/vue/directives/focus.js';
import { API_URL_BASE } from '../request-helpers.js';

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
        miniThumbnailUrlFor: {
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
                album_id: this.yearBeingEditedTemp.album_id || null,
            };
            if(!params.description && !params.album_id){
                this.sendJson(`${API_URL_BASE}/years/${this.yearBeingEdited.year}`, 'DELETE');
            }
            else {
                const forceRefresh = params.album_id !== this.yearBeingEdited.album_id;
                this.sendJson(
                    `${API_URL_BASE}/years/${this.yearBeingEdited.year}`, 
                    'PUT', 
                    {
                        description: this.yearBeingEditedTemp.description || null,
                        album_id: this.yearBeingEditedTemp.album_id || null,
                    }
                ).then(() => { 
                    if(forceRefresh){
                        this.setup(true);
                    }
                });
            }

            this.yearBeingEdited.description = params.description;
            this.yearBeingEdited.album_id = params.album_id;
            this.yearBeingEdited = null;
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