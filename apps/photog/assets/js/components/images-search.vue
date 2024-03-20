<template>
    <div class="main container">
        <h2 :class="$style.sectionHeading">Image Search</h2>
        <form @submit.prevent="onSearchSubmit" :class="$style.form">
            <label :class="$style.label">File name <input type="search" class="form-control" v-model="query" /></label>
            <button type="submit" class="btn btn-success" :class="$style.submitButton" :disabled="!isSearchEnabled">Search</button>
        </form>
        <template v-if="!isLoading && lastQuery">
            <template v-if="images.length > 0">
                <ResourceHeader :title="`Results for ${lastQuery}`" :count="images.length" />
                <thumbnail-items-list
                    :items="images"
                    :showRouteFor="showRouteForImage"
                    :miniThumbnailUrlFor="miniThumbnailUrlFor"
                />
            </template>
            <p v-else>No results found for {{ lastQuery }}</p>
        </template>
        <LoadingAnimation v-if="isLoading" />
    </div>
</template>

<style lang="scss" module>
    .sectionHeading {
        margin: 0 0 0.5rem;
    }

    .form {
        display: flex;
    }

    .label {
        flex-grow: 1;
    }

    .submitButton {
        align-self: end;
        margin-left: 1em;
    }

</style>

<script>
import { API_URL_BASE } from '../request-helpers.js';
import { fetchJson } from 'umbrella-common-js/ajax.js';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';
import ResourceHeader from './resource-header.vue';
import ThumbnailItemsList from './thumbnail-list/components/thumbnail-items-list.vue';

export default {
    props: {
        miniThumbnailUrlFor: {
            type: Function,
            required: true,
        },
    },
    components: {
        ResourceHeader,
        ThumbnailItemsList,
        LoadingAnimation,
    },
    data(){
        return {
            query: '',
            images: [],
            isLoading: false,
            lastQuery: '',
        };
    },
    computed: {
        isSearchEnabled(){
            return this.query.length > 2;
        },
    },
    methods: {
        showRouteForImage(item, _model) {
            return {
                name: 'imagesShow',
                params: {
                    id: item.id,
                },
            };
        },
        onSearchSubmit(){
            if(!this.isSearchEnabled){
                return;
            }
            this.isLoading = true;
            this.lastQuery = this.query;
            fetchJson(`${API_URL_BASE}/images/search?q=${encodeURIComponent(this.query)}`).then((images) => {
                this.images = images;
                this.isLoading = false;
            });
        },
    }
};
</script>