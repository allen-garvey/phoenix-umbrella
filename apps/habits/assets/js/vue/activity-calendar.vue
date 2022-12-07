<template>
    <div :class="$style.container">
        
    </div>
</template>

<style lang="scss" module>
    .container {

    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import {getTodaysDate, formatDate, getPastSundayFromDate} from '../date';

export default {
    components: {
    },
    created(){
        const todaysDate = getTodaysDate();
        const todaysDateString = formatDate(todaysDate);
        const startDateString = formatDate(getPastSundayFromDate(todaysDate, 1));

        const activitiesPromise = fetchJson(`/api/activities?from=${startDateString}&to=${todaysDateString}`)
            .then(data => this.activities = data.activities);
        const categoriesPromise = fetchJson('/api/categories')
            .then(data => this.categories = data);
        
        Promise.all([activitiesPromise, categoriesPromise]).then(() => this.isInitialLoadComplete = true);
    },
    data(){
        return {
            isInitialLoadComplete: false,
            activities: [],
            categories: [],
        };
    },
    computed: {
    },
    methods: {
    }
};
</script>