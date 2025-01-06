<template>
    <table :class="$style.trackList">
        <thead>
            <tr>
                <template v-for="(column, i) in itemColumns" :key="i">
                    <th v-if="column" @click="sortItems(column.sort)">
                        {{ column.title }}
                    </th>
                    <th v-else></th>
                </template>
            </tr>
        </thead>
        <tbody>
            <slot></slot>
            <tr>
                <td>
                    <infinite-observer
                        :on-trigger="infiniteScrollTriggered"
                        v-if="infiniteScroll"
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

    a {
        text-decoration: none;
    }

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
        cursor: pointer;
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
        sortItemsFunc: {
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
            this.sortItemsFunc(key, this.sortAsc);
        },
    },
};
</script>
