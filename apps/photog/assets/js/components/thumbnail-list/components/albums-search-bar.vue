<template>
    <form :class="$style.form" @submit.prevent="submit()">
        <input
            type="search"
            name="q"
            class="form-control"
            :class="$style.searchInput"
            placeholder="Search albums"
            v-model="query"
            v-focus
        />
        <input
            class="btn btn-success"
            type="submit"
            value="Search"
            :disabled="!query"
        />
    </form>
</template>

<style lang="scss" module>
.form {
    display: flex;
    flex-wrap: wrap;
    gap: 1em;
    margin-bottom: 1em;

    .searchInput {
        width: auto;
        flex-grow: 1;
    }
}
</style>

<script>
import focus from 'umbrella-common-js/vue/directives/focus.js';

const SEARCH_QUERY_PARAM_KEY = 'q';

export default {
    directives: {
        focus,
    },
    created() {
        const query = this.$route.query[SEARCH_QUERY_PARAM_KEY];
        if (query) {
            this.query = query;
        }
    },
    data() {
        return {
            query: '',
        };
    },
    watch: {
        $route(to) {
            const query = to.query[SEARCH_QUERY_PARAM_KEY];
            if (query) {
                this.query = query;
            }
        },
    },
    methods: {
        submit() {
            if (!this.query) {
                return;
            }
            this.$router.push({
                name: 'albumsSearch',
                query: { q: this.query },
            });
        },
    },
};
</script>
