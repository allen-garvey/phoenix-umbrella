<template>
<div>
    <loading-animation v-if="!isInitialLoadComplete" />
    <table v-if="isInitialLoadComplete" class="plugin-table">
        <thead>
            <tr>
                <th></th>
                <th>Maker</th>
                <th>Name</th>
                <th>Group</th>
                <th>Category</th>
                <th>Acquisition date</th>
                <th>Cost</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <tr 
                v-for="plugin in plugins" 
                :key="plugin.id"
                :class="{[`row-${plugin.category?.color}`]: plugin.category}"
            >
                <td></td>
                <td><a :href="plugin.maker.url">{{plugin.maker.name}}</a></td>
                <td><a :href="plugin.url">{{plugin.name}}</a></td>
                <td><a :href="plugin.group.url">{{plugin.group.name}}</a></td>
                <td><a :href="plugin.category.url" v-if="plugin.category">{{plugin.category.name}}</a></td>
                <td>{{ plugin.acquisition_date }}</td>
                <td>{{ plugin.cost }}</td>
                <td><span><a :href="plugin.edit_url" class="btn btn-primary">Edit</a></span></td>
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
    },
    data(){
        return {
            isInitialLoadComplete: false,
            pluginsRaw: [],
            categoriesMap: {},
            groupsMap: {},
            makersMap: {},
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
                        maker: maker.sort,
                        group: group.sort,
                        category: category?.sort,
                        name: plugin.name,
                        cost: plugin.cost,
                        acquisition_date: plugin.acquisition_date,
                    },
                };
            });
        },
    },
    methods: {
    }
};
</script>