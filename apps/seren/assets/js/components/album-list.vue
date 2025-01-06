<template>
    <items-table :onSortRequested="sortAlbums" :itemColumns="itemColumns">
        <tr v-for="album in albums" :key="album.id">
            <td>
                <router-link
                    :to="{ name: 'albumTracks', params: { id: album.id } }"
                >
                    {{ album.title }}
                </router-link>
            </td>
            <td>
                <router-link
                    :to="{
                        name: 'artistTracks',
                        params: { id: album.artist.id },
                    }"
                >
                    {{ album.artist.name }}
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
        artistsMap: {
            type: Map,
            required: true,
        },
    },
    components: {
        ItemsTable,
    },
    created() {
        this.loadAlbums();
    },
    watch: {
        $route(to, from) {
            this.albums = [];
            nextTick().then(() => {
                this.loadAlbums();
            });
        },
    },
    data() {
        return {
            albums: [],
        };
    },
    computed: {
        itemColumns() {
            return [
                { title: 'Title', sort: 'title' },
                { title: 'Artist', sort: 'artist' },
            ];
        },
    },
    methods: {
        loadAlbums() {
            this.albums = [];
            this.getItems('albums').then(albums => {
                this.albums = albums.map(album => ({
                    ...album,
                    artist: this.artistsMap.get(album.artist_id),
                }));
            });
        },
        sortAlbums(key, isAsc) {
            let sortFunction;

            if (key === 'title') {
                sortFunction = (a, b) => {
                    const compare = a.title.localeCompare(b.title);
                    if (compare !== 0) {
                        return compare;
                    }

                    return a.artist.name.localeCompare(b.artist.name);
                };
            } else {
                sortFunction = (a, b) => {
                    const compare = a.artist.name.localeCompare(b.artist.name);
                    if (compare !== 0) {
                        return compare;
                    }

                    return a.title.localeCompare(b.title);
                };
            }

            this.albums.sort(sortFunction);

            if (!isAsc) {
                this.albums.reverse();
            }
        },
    },
};
</script>
