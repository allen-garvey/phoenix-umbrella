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
                    :to="{
                        name: 'albumsForYear',
                        params: { year: year.year }
                    }"
                >
                    {{ year.year }}
                    <span :class="$style.count">({{ year.count }})</span>
                </router-link>
                <span :class="$style.description" v-if="year.year !== yearBeingEdited?.year">{{ year.description }}</span>
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
                    <input class="form-control" :class="$style.descriptionInput" v-model="yearBeingEditedDescription" v-focus />
                    <button class="btn btn-outline-dark" :class="$style.cancelButton" @click="cancelEdit()" type="button">Cancel</button>
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
    }

    .count {
        color: #aaa;
        font-size: 1.2rem;
        margin-left: 0.2em;
        margin: 0 1rem 0 0.2em;
    }

    .editContainer {
        display: inline-flex;
    }

    .cancelButton {
        margin: 0 0.5rem 0;
    }

    .descriptionInput {
        width: 350px;
    }
</style>

<script>
import { nextTick } from 'vue';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import focus from 'umbrella-common-js/vue/directives/focus.js';

export default {
    props: {
        getModel: {
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
            yearBeingEditedDescription: '',
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
        setup(){
            this.isInitialLoadComplete = false;
            this.years = [];

            this.getModel('/albums/years/index').then(years => {
                this.years = years;
                this.isInitialLoadComplete = true;
            });
        },
        editYear(year){
            this.yearBeingEdited = year;
            this.yearBeingEditedDescription = year.description;
        },
        cancelEdit(){
            this.yearBeingEdited = null;
        },
        save(){
            this.yearBeingEdited.description = this.yearBeingEditedDescription;
            this.yearBeingEdited = null;
        },
    },
};
</script>