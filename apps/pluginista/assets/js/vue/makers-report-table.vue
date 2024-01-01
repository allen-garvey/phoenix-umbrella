<template>
    <div>
        <loading-animation v-if="!isInitialLoadComplete" />
        <table v-if="isInitialLoadComplete">
            <thead>
                <tr>
                    <th></th>
                    <th><a :href="sortUrlForColumn(sortColumns.maker)" @click="updateSort($event, sortColumns.maker)">Maker</a></th>
                    <th><a :href="sortUrlForColumn(sortColumns.count)" @click="updateSort($event, sortColumns.count)">Count</a></th>
                    <th><a :href="sortUrlForColumn(sortColumns.total)" @click="updateSort($event, sortColumns.total)">Total</a></th>
                </tr>
            </thead>
            <tbody>
                <tr 
                    v-for="item in itemsSorted" 
                    :key="item.id"
                >
                    <td></td>
                    <td><a :href="item.url">{{item.name}}</a></td>
                    <td>{{ item.count }}</td>
                    <td>${{ item.total }}</td>
                </tr>
            </tbody>
        </table>
    </div>
</template>

<style lang="scss" module>
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';

const QUERY_PARAM_SORT_COLUMN = 'sort';
const QUERY_PARAM_SORT_DIRICTION = 'direction';

const SORT_DIRECTIONS = {
    asc: 'asc',
    desc: 'desc',
};

export default {
    props: {
        itemsApiRoute: {
            type: String,
            required: true,
        },
    },
    components: {
        LoadingAnimation,
    },
    created(){
        fetchJson(this.itemsApiRoute)
            .then(items => this.items = items)
            .then(() => this.isInitialLoadComplete = true);

        const params = new URLSearchParams(window.location.search);
        const paramSortDirection = params.get(QUERY_PARAM_SORT_DIRICTION);
        const paramSortColumn = params.get(QUERY_PARAM_SORT_COLUMN);
        this.sortDirection = paramSortDirection in SORT_DIRECTIONS ? paramSortDirection : SORT_DIRECTIONS.asc;
        this.sortColumn = paramSortColumn in this.sortColumns ? paramSortColumn : this.sortColumns.maker;
    },
    data(){
        return {
            isInitialLoadComplete: false,
            items: [],
            sortColumn: '',
            sortDirection: '',
        };
    },
    computed: {
        itemsSorted(){
            const stringCompare = (a, b) => a[this.sortColumn].localeCompare(b[this.sortColumn]);
            const numberCompare = (a, b) => a[this.sortColumn] - b[this.sortColumn];

            const compareFunc = this.sortColumn === this.sortColumns.maker ? stringCompare : numberCompare;

            if(this.sortDirection === SORT_DIRECTIONS.asc){
                return this.items.slice().sort(compareFunc);
            }

            return this.items.slice().sort((a, b) => compareFunc(b, a));
        },
        sortColumns(){
            return {
                maker: 'name',
                count: 'count',
                total: 'total',
            };
        },
    },
    methods: {
        updateSort(event, column){
            event.preventDefault();

            if(this.sortColumn === column){
                this.sortDirection = this.sortDirection === SORT_DIRECTIONS.asc ? SORT_DIRECTIONS.desc : SORT_DIRECTIONS.asc;
            }
            else {
                this.sortColumn = column;
                this.sortDirection = SORT_DIRECTIONS.asc;
            }

            const searchParams = new URLSearchParams(window.location.search)
            searchParams.set(QUERY_PARAM_SORT_COLUMN, this.sortColumn);
            searchParams.set(QUERY_PARAM_SORT_DIRICTION, this.sortDirection);
            const newRelativePathQuery = `${window.location.pathname}?${searchParams.toString()}`;
            history.replaceState(null, '', newRelativePathQuery);
        },
        sortUrlForColumn(column){
            return `?${QUERY_PARAM_SORT_COLUMN}=${column}`;
        },
    }
};
</script>