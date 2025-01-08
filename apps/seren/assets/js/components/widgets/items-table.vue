<template>
    <table :class="$style.trackList">
        <thead>
            <tr>
                <template v-for="(column, i) in itemColumns" :key="i">
                    <th :class="column?.class">
                        <template
                            v-if="column?.title"
                            @click="sortItems(column.sort)"
                        >
                            {{ column.title }}
                        </template>
                    </th>
                </template>
            </tr>
        </thead>
        <tbody>
            <slot></slot>
            <tr v-if="infiniteScroll">
                <td>
                    <infinite-observer :on-trigger="infiniteScrollTriggered">
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
        background: #b6cfe7;
        font-family: sans-serif;
    }
    th,
    td {
        padding: 0.5em;
    }
    th {
        text-align: left;

        &:not(:empty) {
            cursor: pointer;
        }
    }

    tbody tr {
        transition: background-color 0.3s ease;

        &:nth-of-type(even) {
            background: #e6f2fe;
        }
    }
}
</style>

<script>
import InfiniteObserver from 'umbrella-common-js/vue/components/infinite-observer.vue';

export default {
    components: {
        InfiniteObserver,
    },
    props: {
        itemColumns: {
            type: Array,
            required: true,
        },
        onSortRequested: {
            type: Function,
            required: true,
        },
        infiniteScroll: {
            type: Boolean,
            default: false,
        },
        onInfiniteScroll: {
            type: Function,
        },
    },
    data() {
        return {
            previousSortKey: null,
            sortAsc: true,
        };
    },
    methods: {
        infiniteScrollTriggered($state) {
            this.onInfiniteScroll().then(() => {
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
            this.onSortRequested(key, this.sortAsc);
        },
    },
};
</script>
