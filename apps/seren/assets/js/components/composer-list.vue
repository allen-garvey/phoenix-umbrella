<template>
    <items-table :onSortRequested="sortComposers" :itemColumns="itemColumns">
        <tr v-for="composer in composers" :key="composer.id">
            <td>
                <router-link
                    :to="{
                        name: 'composerTracks',
                        params: { id: composer.id },
                    }"
                >
                    {{ composer.name }}
                </router-link>
            </td>
        </tr>
    </items-table>
</template>

<style lang="scss" module></style>

<script>
import ItemsTable from './widgets/items-table.vue';

export default {
    props: {
        getItems: {
            type: Function,
            required: true,
        },
    },
    components: {
        ItemsTable,
    },
    created() {
        this.loadComposers();
    },
    watch: {
        $route(to, from) {
            this.composers = [];
            nextTick().then(() => {
                this.loadComposers();
            });
        },
    },
    data() {
        return {
            composers: [],
        };
    },
    computed: {
        itemColumns() {
            return [{ title: 'Name', sort: 'name' }];
        },
    },
    methods: {
        loadComposers() {
            this.composers = [];
            this.getItems('composers').then(composers => {
                this.composers = composers;
            });
        },
        sortComposers(key, isAsc) {
            let sortFunction;

            if (isAsc) {
                sortFunction = (a, b) => a.name.localeCompare(b.name);
            } else {
                sortFunction = (a, b) => b.name.localeCompare(a.name);
            }

            this.composers.sort(sortFunction);
        },
    },
};
</script>
