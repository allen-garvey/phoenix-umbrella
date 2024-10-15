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
                :new-activity-url="newActivityUrl"
                v-if="categoriesMap.size > 0"
            />
        </div>
    </div>
</template>

<style lang="scss" module>
    .hidden {
        visibility: hidden;
    }
    @media (prefers-color-scheme: dark) {
        .container {
            background-color: #333;
        }
    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import { getTodaysDate, formatDate } from '../date';

import ActivityMonth from './activity-month.vue';

export default {
    props: {
        newActivityUrl: {
            type: String,
            required: true,
        },
    },
    components: {
        ActivityMonth,
    },
    created(){
        let month = this.todaysDate.getMonth();
        let year = this.todaysDate.getFullYear();

        const urlParams = new URL(window.location.href).searchParams;

        if(urlParams.has('year') && urlParams.has('month')){
            month = parseInt(urlParams.get('month'));
            year = urlParams.get('year');
        }

        const activitiesPromise = this.fetchActivities(month, year);
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
    watch: {
        currentMonthActivities(to){
            const currentMonthActivities = to;
            
            if(!currentMonthActivities){
                return;
            }

            const url = new URL(window.location.href);
            
            if(this.currentMonthIndex === 0){
                url.searchParams.delete('year');
                url.searchParams.delete('month');
            }
            else {
                url.searchParams.set('year', currentMonthActivities.year);
                url.searchParams.set('month', currentMonthActivities.month);
            }

            history.replaceState(null, '', url.toString());
        },
    },
    methods: {
        formatDate,
        fetchActivities(month, year){
            return fetchJson(`/api/activities?year=${year}&month=${month+1}`)
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

                this.fetchActivities(month, year)
                    .then(() => this.isLoading = false);
            }

            this.currentMonthIndex = previousMonthIndex;
        },
    }
};
</script>