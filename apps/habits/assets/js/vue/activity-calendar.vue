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
                    v-if="!isTodaysMonth"
                >
                    Next Month
                </button>
            </div>
            <h3 :class="$style.title">{{ monthName(currentMonth) }} {{ currentYear }}</h3>
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
    .title {
        text-align: center;
        margin-bottom: 2.5rem;
    }
    @media (prefers-color-scheme: dark) {
        .container {
            background-color: #333;
        }
    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import { getTodaysDate, monthName, formatDate } from '../date';

import ActivityMonth from './activity-month.vue';

const keyFor = (month, year) => `${year}-${month}`;

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
            year = parseInt(urlParams.get('year'));
        }

        const activitiesPromise = this.fetchActivities(month, year);
        const categoriesPromise = fetchJson('/api/categories')
            .then(data => this.categories = data);
        
        Promise.all([activitiesPromise, categoriesPromise]).then(() => {
            this.currentMonth = month;
            this.currentYear = year;
            this.isLoading = false;
        });
    },
    data(){
        return {
            todaysDate: getTodaysDate(),
            isLoading: true,
            activities: new Map(),
            categories: [],
            currentMonth: 0,
            currentYear: 0,
        };
    },
    computed: {
        currentMonthActivities(){
            return this.activities.get(keyFor(this.currentMonth, this.currentYear));
        },
        categoriesMap(){
            const categoriesMap = new Map();
            this.categories.forEach(category => categoriesMap.set(category.id, category));
            return categoriesMap;
        },
        isTodaysMonth(){
            return this.currentMonth === this.todaysDate.getMonth() && this.currentYear === this.todaysDate.getFullYear();
        }
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
        monthName,
        fetchActivities(month, year){
            const key = keyFor(month, year);

            if(this.activities.has(key)){
                return Promise.resolve();
            }

            return fetchJson(`/api/activities?year=${year}&month=${month+1}`)
                .then(data => { 
                    this.activities.set(key, {
                        meta: data.meta,
                        month: month,
                        year: year,
                        activities: data.activities,
                    });
                });
        },
        goOneMonthForward(){
            let month = this.currentMonth + 1;
            let year = this.currentYear;
            
            if(month > 11){
                month = 0;
                year = year + 1;
            }
            
            this.isLoading = true;
            this.fetchActivities(month, year).then(() => {
                  this.currentMonth = month;
                  this.currentYear = year; 
                  this.isLoading = false; 
            });
        },
        goOneMonthBack(){
            let month = this.currentMonth - 1;
            let year = this.currentYear;
            
            if(month < 0){
                month = 11;
                year = year - 1;
            }
            
            this.isLoading = true;
            this.fetchActivities(month, year).then(() => {
                  this.currentMonth = month;
                  this.currentYear = year;  
                  this.isLoading = false;
            });
        },
    }
};
</script>