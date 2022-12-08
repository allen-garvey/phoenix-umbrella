<template>
    <div :class="$style.container">
        <Activity-Month
            :activities="activities[0].activities"
            :month="activities[0].month"
            :year="activities[0].year"
            :start-date="activities[0].meta.from"
            :end-date="activities[0].meta.to"
            v-if="isInitialLoadComplete"
        />
    </div>
</template>

<style lang="scss" module>
    .container {

    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import {getTodaysDate, formatDate, getMonthSunday} from '../date';

import ActivityMonth from './activity-month.vue';

export default {
    components: {
        ActivityMonth,
    },
    created(){
        const todaysDate = getTodaysDate();
        const todaysDateString = formatDate(todaysDate);
        const startDateString = formatDate(getMonthSunday(todaysDate));

        const activitiesPromise = fetchJson(`/api/activities?from=${startDateString}&to=${todaysDateString}`)
            .then(data => { 
                this.activities.push({
                    meta: data.meta,
                    month: todaysDate.getMonth(),
                    year: todaysDate.getFullYear(),
                    activities: data.activities,
                });
            });
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