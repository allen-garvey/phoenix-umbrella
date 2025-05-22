<template>
    <table :class="$style.trackList">
        <thead>
            <tr>
                <th :class="$style.colPlayBtn"></th>
                <th
                    v-for="(column, i) in itemColumns"
                    :key="i"
                    @click="sortItems(column.sort)"
                >
                    {{ column.title }}
                </th>
            </tr>
        </thead>
        <tbody>
            <tr v-for="(item, i) in items" :key="i">
                <td
                    @click="rowPlayButtonClicked(item, i)"
                    :class="{
                        [$style.colPlayBtn]: true,
                        [$style.isPlaying]: isTrackPlaying(item),
                    }"
                >
                    <button
                        :class="$style.playButton"
                        v-if="this.canRowBePlayed"
                    >
                        <svg>
                            <use
                                href="#icon-pause"
                                v-if="isTrackPlaying(item)"
                            />
                            <use href="#icon-play" v-else />
                        </svg>
                    </button>
                </td>
                <td
                    v-for="(field, j) in itemFields(item)"
                    :key="`${item.id}${i}${field}${j}`"
                >
                    <router-link
                        :to="routeForItem(item)"
                        v-if="routeForItem && j === 0"
                    >
                        {{ field }}
                    </router-link>
                    <span v-else>{{ field }}</span>
                </td>
            </tr>
            <tr>
                <td :colspan="itemColumns.length + 1">
                    <infinite-observer
                        :on-trigger="infiniteScrollTriggered"
                        v-if="!isInfiniteScrollDisabled"
                    >
                    </infinite-observer>
                </td>
            </tr>
        </tbody>
    </table>
</template>

<style lang="scss" module>
.trackList {
    width: 100%;
    table-layout: fixed;
    border-collapse: collapse;

    thead {
        background: var(--seren-table-header-bg-color);
        font-family: sans-serif;
    }
    th,
    td {
        padding: 0.5em;
    }
    th {
        text-align: left;
        cursor: pointer;
    }

    tbody tr {
        transition: background-color 0.3s ease;

        &:nth-of-type(even) {
            background: var(--seren-table-row-even-bg-color);
        }
    }
}

.colPlayBtn {
    height: 50px;
    width: 50px;

    svg {
        display: none;
    }

    &:hover,
    &.isPlaying {
        svg {
            display: block;
        }
    }

    &:hover {
        svg {
            color: var(--seren-accent-color-text);
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
</style>

<script>
import { nextTick } from 'vue';
import InfiniteObserver from 'umbrella-common-js/vue/components/infinite-observer.vue';

export default {
    components: {
        InfiniteObserver,
    },
    props: {
        loadMoreTracks: {
            type: Function,
            required: true,
        },
        itemColumns: {
            type: Array,
            required: true,
        },
        itemFields: {
            type: Function,
            required: true,
        },
        isTrackPlaying: {
            type: Function,
            required: true,
        },
        getItems: {
            type: Function,
            required: true,
        },
        //might be string or function
        getItemsKey: {
            required: true,
        },
        sortItemsFunc: {
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
        //if on list page with list of tracks, routeForItem will be null meaning we should play the track,
        //otherwise it will be a function taking the row and giving us a route to go to
        routeForItem: {
            default: null,
        },
        isInfiniteScrollDisabled: {
            type: Boolean,
            default: true,
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
    data() {
        return {
            items: [],
            previousSortKey: null,
            sortAsc: true,
        };
    },
    computed: {
        canRowBePlayed() {
            return !this.routeForItem;
        },
    },
    created() {
        this.loadItems();
    },
    watch: {
        $route(to, from) {
            this.items = [];
            nextTick().then(() => {
                this.loadItems();
            });
        },
    },
    methods: {
        loadItems() {
            this.items = [];
            this.getItems(this.getItemsKey).then(items => {
                this.items = items;
            });
        },
        infiniteScrollTriggered($state) {
            this.loadMoreTracks().then(() => {
                this.loadItems();
                $state.loaded();
            });
        },
        sortItems(key) {
            if (key !== this.previousSortKey) {
                this.sortAsc = true;
            } else {
                this.sortAsc = !this.sortAsc;
            }
            this.previousSortKey = key;
            this.sortItemsFunc(this.items, key, this.sortAsc);
        },
        rowPlayButtonClicked(item, i) {
            if (!this.canRowBePlayed) {
                return;
            }
            if (this.isTrackPlaying(item)) {
                this.stopTrack();
            } else {
                this.playTrack(item, i, this.items);
            }
        },
    },
};
</script>
