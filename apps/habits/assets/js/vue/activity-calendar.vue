<template>
    <div :class="$style.container">
        <div v-if="currentMonthActivities">
            <div :class="{[$style.hidden]: isLoading}">
                <button 
                    @click="goOneMonthBack" 
                    class="btn btn-light"
                >
                    Previous Month
                </button>
                <button 
                    @click="goOneMonthForward" 
                    class="btn btn-light" 
                    v-if="(currentMonthIndex > 0)"
                >
                    Next Month
                </button>
            </div>
            <Activity-Month
                :activities="currentMonthActivities.activities"
                :categories-map="categoriesMap"
                :month="currentMonthActivities.month"
                :year="currentMonthActivities.year"
                :start-date="currentMonthActivities.meta.from"
                :end-date="currentMonthActivities.meta.to"
                :todays-date="formatDate(todaysDate)"
                v-if="categoriesMap.size > 0"
            />
        </div>
    </div>
</template>

<style lang="scss" module>
    .hidden {
        visibility: hidden;
    }
    .container {

    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import { getTodaysDate, formatDate, getMonthSunday, getSaturdayAfter } from '../date';

import ActivityMonth from './activity-month.vue';

export default {
    components: {
        ActivityMonth,
    },
    created(){
        const todaysDateString = formatDate(this.todaysDate);
        const startDateString = formatDate(getMonthSunday(this.todaysDate));

        const activitiesPromise = this.fetchActivities(
            startDateString, 
            todaysDateString, 
            this.todaysDate.getMonth(), 
            this.todaysDate.getFullYear()
        );
        const categoriesPromise = fetchJson('/api/categories')
            .then(data => this.categories = data);
        
        Promise.all([activitiesPromise, categoriesPromise]).then(() => this.isLoading = false);
    },
    data(){
        return {
            todaysDate: getTodaysDate(),
            isLoading: true,
            activities: [],
            categories: [],
            currentMonthIndex: 0,
        };
    },
    computed: {
        currentMonthActivities(){
            return this.activities[this.currentMonthIndex];
        },
        categoriesMap(){
            const categoriesMap = new Map();
            this.categories.forEach(category => categoriesMap.set(category.id, category));
            return categoriesMap;
        },
    },
    methods: {
        formatDate,
        fetchActivities(startDateString, endDateString, month, year){
            return fetchJson(`/api/activities?from=${startDateString}&to=${endDateString}`)
                .then(data => { 
                    this.activities.push({
                        meta: data.meta,
                        month: month,
                        year: year,
                        activities: data.activities,
                    });
                });
        },
        goOneMonthForward(){
            this.currentMonthIndex = this.currentMonthIndex - 1;
        },
        goOneMonthBack(){
            const previousMonthIndex = this.currentMonthIndex + 1;
            
            if(!this.activities[previousMonthIndex]){
                this.isLoading = true;
                const currentData = this.activities[this.currentMonthIndex];
                let month = currentData.month - 1;
                let year = currentData.year;
                if(month < 0){
                    month = 11;
                    year = year - 1;
                }
                let endDate = new Date(currentData.year, currentData.month, 0);
                const startDateString = formatDate(getMonthSunday(endDate));
                endDate = formatDate(getSaturdayAfter(endDate));

                this.fetchActivities(startDateString, endDate, month, year)
                    .then(() => this.isLoading = false);
            }

            this.currentMonthIndex = previousMonthIndex;
        },
    }
};
</script>