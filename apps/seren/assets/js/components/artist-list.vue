<template>
    <items-table :onSortRequested="sortArtists" :itemColumns="itemColumns">
        <tr v-for="artist in artists" :key="artist.id">
            <td>
                <router-link
                    :to="{ name: 'artistTracks', params: { id: artist.id } }"
                >
                    {{ artist.name }}
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
        this.loadArtists();
    },
    watch: {
        $route(to, from) {
            this.artists = [];
            nextTick().then(() => {
                this.loadArtists();
            });
        },
    },
    data() {
        return {
            artists: [],
        };
    },
    computed: {
        itemColumns() {
            return [{ title: 'Name', sort: 'name' }];
        },
    },
    methods: {
        loadArtists() {
            this.artists = [];
            this.getItems('artists').then(artists => {
                this.artists = artists;
            });
        },
        sortArtists(key, isAsc) {
            let sortFunction;

            if (isAsc) {
                sortFunction = (a, b) => a.name.localeCompare(b.name);
            } else {
                sortFunction = (a, b) => b.name.localeCompare(a.name);
            }

            this.artists.sort(sortFunction);
        },
    },
};
</script>
