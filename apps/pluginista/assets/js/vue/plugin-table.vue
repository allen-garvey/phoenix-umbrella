<template>
<div>
    <loading-animation v-if="!isInitialLoadComplete" />
    <table v-if="isInitialLoadComplete" class="plugin-table">
        <thead>
            <tr>
                <th></th>
                <th><a :href="sortUrlForColumn(sortColumns.maker)" @click="updateSort($event, sortColumns.maker)">Maker</a></th>
                <th><a :href="sortUrlForColumn(sortColumns.name)" @click="updateSort($event, sortColumns.name)">Name</a></th>
                <th><a :href="sortUrlForColumn(sortColumns.group)" @click="updateSort($event, sortColumns.group)">Group</a></th>
                <th><a :href="sortUrlForColumn(sortColumns.category)" @click="updateSort($event, sortColumns.category)">Category</a></th>
                <th><a :href="sortUrlForColumn(sortColumns.date)" @click="updateSort($event, sortColumns.date)">Acquisition date</a></th>
                <th><a :href="sortUrlForColumn(sortColumns.cost)" @click="updateSort($event, sortColumns.cost)">Cost</a></th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <tr 
                v-for="plugin in pluginsSorted" 
                :key="plugin.id"
                :class="{[this.$style[`row-${plugin.category?.color}`]]: plugin.category}"
            >
                <td></td>
                <td><a :href="plugin.maker.url">{{plugin.maker.name}}</a></td>
                <td><a :href="plugin.url">{{plugin.name}}</a></td>
                <td><a :href="plugin.group.url">{{plugin.group.name}}</a></td>
                <td><a :href="plugin.category.url" v-if="plugin.category">{{plugin.category.name}}</a></td>
                <td>{{ plugin.acquisition_date }}</td>
                <td>${{ plugin.cost }}</td>
                <td><span><a :href="plugin.edit_url" class="btn btn-primary">Edit</a></span></td>
            </tr>
        </tbody>
    </table>
</div>
</template>

<style lang="scss" module>
    .row-red {
        background-color: #ff2929;
    }

    .row-bordeaux {
        background-color: #ad0057;
        
        &, & a {
            color: rgba(255, 255, 255, 0.9);
        }
    }

    .row-magenta {
        background-color: #ff61ff;
    }

    .row-orange {
        background-color: orange;
    }

    .row-yellow {
        background-color: yellow;
    }

    .row-green {
        background-color: green;
        
        &, & a {
            color: rgba(255, 255, 255, 0.9);
        }
    }

    .row-lime {
        background-color: #47ff47;
    }

    .row-blue {
        background-color: #0a7cff;
        
        &, & a {
            color: rgba(255, 255, 255, 0.9);
        }
    }

    .row-teal {
        background-color: teal;
        
        &, & a {
            color: rgba(255, 255, 255, 0.9);
        }
    }

    .row-cyan {
        background-color: #6ff;
    }

    .row-violet {
        background-color: #ba61ff;
    }

    .row-black {
        background-color: #333;

        &, & a {
            color: rgba(255, 255, 255, 0.9);
        }
    }
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
        pluginsApiRoute: {
            type: String,
            required: true,
        },
    },
    components: {
        LoadingAnimation,
    },
    created(){
        const pluginsPromise = fetchJson(this.pluginsApiRoute).then(plugins => this.pluginsRaw = plugins);
        const makersPromise = fetchJson('/api/makers').then(makers => this.makersMap = makers);
        const groupsPromise = fetchJson('/api/groups').then(groups => this.groupsMap = groups);
        const categoriesPromise = fetchJson('/api/categories').then(categories => this.categoriesMap = categories);

        Promise.all([pluginsPromise, makersPromise, groupsPromise, categoriesPromise]).then(() => this.isInitialLoadComplete = true);

        const params = new URLSearchParams(window.location.search);
        const paramSortDirection = params.get(QUERY_PARAM_SORT_DIRICTION);
        const paramSortColumn = params.get(QUERY_PARAM_SORT_COLUMN);
        this.sortDirection = paramSortDirection in SORT_DIRECTIONS ? paramSortDirection : SORT_DIRECTIONS.asc;
        this.sortColumn = paramSortColumn in this.sortColumns ? paramSortColumn : this.sortColumns.category;
    },
    data(){
        return {
            isInitialLoadComplete: false,
            pluginsRaw: [],
            categoriesMap: {},
            groupsMap: {},
            makersMap: {},
            sortColumn: '',
            sortDirection: '',
        };
    },
    computed: {
        plugins(){
            return this.pluginsRaw.map(plugin => {
                const maker = this.makersMap[plugin.maker_id];
                const group = this.groupsMap[plugin.group_id];
                const category = this.categoriesMap[plugin.category_ids[0]];
                return {
                    ...plugin,
                    maker,
                    group,
                    category,
                    sort: {
                        [this.sortColumns.maker]: maker.sort,
                        [this.sortColumns.group]: group.sort,
                        [this.sortColumns.category]: category?.sort,
                        [this.sortColumns.name]: plugin.name,
                        [this.sortColumns.cost]: plugin.cost,
                        [this.sortColumns.date]: plugin.acquisition_date,
                    },
                };
            });
        },
        pluginsSorted(){
            const stringCompare = (a, b) => a.sort[this.sortColumn].localeCompare(b.sort[this.sortColumn]);
            const numberCompare = (a, b) => a.sort[this.sortColumn] - b.sort[this.sortColumn];

            const compareFunc = this.sortColumn === this.sortColumns.name || this.sortColumn === this.sortColumns.date ? stringCompare : numberCompare;

            if(this.sortDirection === SORT_DIRECTIONS.asc){
                return this.plugins.slice().sort(compareFunc);
            }

            return this.plugins.slice().sort((a, b) => compareFunc(b, a));
        },
        sortColumns(){
            return {
                maker: 'maker',
                group: 'group',
                category: 'category',
                name: 'name',
                cost: 'cost',
                date: 'date',
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