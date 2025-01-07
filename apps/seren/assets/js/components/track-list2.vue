<template>
    <items-table :onSortRequested="sortTracks" :itemColumns="itemColumns">
        <tr v-for="(track, i) in tracks" :key="track.id" :class="$style.row">
            <td
                @click="rowPlayButtonClicked(track, i)"
                :class="{
                    [$style.colPlayBtn]: true,
                    [$style.isPlaying]: isTrackPlaying(track),
                }"
            >
                <button :class="$style.playButton">
                    <svg>
                        <use href="#icon-pause" v-if="isTrackPlaying(track)" />
                        <use href="#icon-play" v-else />
                    </svg>
                </button>
            </td>
            <td>
                {{ track.title }}
            </td>
            <td>
                <router-link
                    :to="{
                        name: 'artistTracks',
                        params: { id: track.artist.id },
                    }"
                >
                    {{ track.artist.name }}
                </router-link>
            </td>
            <td>
                <router-link
                    :to="{
                        name: 'albumTracks',
                        params: { id: track.album.id },
                    }"
                    v-if="track.album"
                >
                    {{ track.album.title }}
                </router-link>
            </td>
            <td>
                {{ formatTrackLength(track.length) }}
            </td>
            <td>
                <router-link
                    :to="{
                        name: 'composerTracks',
                        params: { id: track.composer.id },
                    }"
                    v-if="track.composer"
                >
                    {{ track.composer.name }}
                </router-link>
            </td>
            <td>
                {{ track.bit_rate }}
            </td>
            <td>
                {{ track.play_count }}
            </td>
            <td>
                {{ formatUtcDateToUs(track.date_added) }}
            </td>
        </tr>
    </items-table>
</template>

<style lang="scss" module>
$playButtonDimensions: 50px;

.colPlayBtnHeading {
    width: $playButtonDimensions;
}
.colPlayBtn {
    height: $playButtonDimensions;
    width: $playButtonDimensions;

    svg {
        display: none;
        color: dodgerblue;
    }

    .row:hover &,
    &.isPlaying {
        svg {
            display: block;
        }
    }
}

.playButton {
    height: 50px;
    background-color: transparent;
    border: none;
    width: 100%;

    &:active,
    &:focus {
        border: none;

        svg {
            display: block;
        }
    }
}

.shortColumn {
    width: 8em;
}
</style>

<script>
import { nextTick } from 'vue';
import ItemsTable from './widgets/items-table.vue';
import { formatTrackLength, formatUtcDateToUs } from '../view-helpers';

export default {
    props: {
        // might be string or object
        getItemsKey: {
            required: true,
        },
        getItems: {
            type: Function,
            required: true,
        },
        isTrackPlaying: {
            type: Function,
            required: true,
        },
        playTrack: {
            type: Function,
            required: true,
        },
        stopTrack: {
            type: Function,
            required: true,
        },
        artistsMap: {
            type: Map,
            required: true,
        },
        albumsMap: {
            type: Map,
            required: true,
        },
        composersMap: {
            type: Map,
            required: true,
        },
    },
    components: {
        ItemsTable,
    },
    created() {
        this.loadTracks();
    },
    watch: {
        $route(to, from) {
            this.tracks = [];
            nextTick().then(() => {
                this.loadTracks();
            });
        },
    },
    data() {
        return {
            tracks: [],
        };
    },
    computed: {
        itemColumns() {
            return [
                { class: this.$style.colPlayBtnHeading },
                { title: 'Title', sort: 'title' },
                { title: 'Artist', sort: 'artist' },
                { title: 'Album', sort: 'album' },
                {
                    title: 'Length',
                    sort: 'length',
                    class: this.$style.shortColumn,
                },
                { title: 'Composer', sort: 'composer' },
                {
                    title: 'Bit Rate',
                    sort: 'bit_rate',
                    class: this.$style.shortColumn,
                },
                {
                    title: 'Play Count',
                    sort: 'play_count',
                    class: this.$style.shortColumn,
                },
                {
                    title: 'Date Added',
                    sort: 'date_added',
                    class: this.$style.shortColumn,
                },
            ];
        },
    },
    methods: {
        formatTrackLength,
        formatUtcDateToUs,
        loadTracks() {
            this.tracks = [];
            this.getItems(this.getItemsKey).then(tracks => {
                this.tracks = tracks.map(track => ({
                    ...track,
                    artist: this.artistsMap.get(track.artist_id),
                    album: this.albumsMap.get(track.album_id),
                    composer: this.composersMap.get(track.composer_id),
                }));
            });
        },
        rowPlayButtonClicked(track, i) {
            if (this.isTrackPlaying(track)) {
                this.stopTrack();
            } else {
                this.playTrack(track, i, this.tracks);
            }
        },
        sortTracks(key, isAsc) {
            let sortFunction;

            switch (key) {
                case 'title':
                    sortFunction = (a, b) => {
                        const compare = a.title.localeCompare(b.title);
                        if (compare !== 0) {
                            return compare;
                        }

                        return a.artist.name.localeCompare(b.artist.name);
                    };
                    break;
                case 'artist':
                    sortFunction = (a, b) => {
                        const compare = a.artist.name.localeCompare(
                            b.artist.name
                        );
                        if (compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
                case 'album':
                    sortFunction = (a, b) => {
                        const compare = a.album?.title.localeCompare(
                            b.album?.title
                        );
                        if (compare !== undefined && compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
                case 'composer':
                    sortFunction = (a, b) => {
                        const compare = a.composer?.name.localeCompare(
                            b.composer?.name
                        );
                        if (compare !== undefined && compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
                case 'length':
                    sortFunction = (a, b) => {
                        const compare = a.length - b.length;
                        if (compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
                case 'bit_rate':
                    sortFunction = (a, b) => {
                        const compare = a.bit_rate - b.bit_rate;
                        if (compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
                case 'play_count':
                    sortFunction = (a, b) => {
                        const compare = a.play_count - b.play_count;
                        if (compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
                default:
                    sortFunction = (a, b) => {
                        const compare = a[key].localeCompare(b[key]);
                        if (compare !== 0) {
                            return compare;
                        }

                        return a.title.localeCompare(b.title);
                    };
                    break;
            }

            this.tracks.sort(sortFunction);

            if (!isAsc) {
                this.tracks.reverse();
            }
        },
    },
};
</script>
