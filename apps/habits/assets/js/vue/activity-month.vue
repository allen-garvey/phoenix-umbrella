<template>
    <div :class="$style.container">
        <h3 :class="$style.title">{{ monthName(month) }} {{ year }}</h3>
        <div 
            v-for="(week, weekNum) in weeks" 
            :class="$style.week"
            :key="`${year}-${month}-${weekNum}`"
        >
            <div 
                v-for="(day, dayNum) in week" 
                :class="$style.day"
                :key="`${year}-${month}-${weekNum}-${dayNum}`"
            >
                <h4 :class="{[$style.today]: todaysDate === day.date}">
                    <a 
                        :href="generateNewActivityUrl(day.date)" 
                        :class="$style.newActivityLink"
                    >
                        {{ formatDayDate(day.date) }}
                    </a>
                </h4>
                <div 
                    v-for="activity in day.activities"
                    :key="activity.id"
                    :class="getCategoryClass(activity.category_id)"
                    @click="selectActivity(activity)"
                    @mouseover="selectActivity(activity)"
                >
                    <div>
                        <a :href="`/activities/${activity.id}`">
                            {{ activity.title }}
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div v-if="selectedActivity">
            <div :class="getCategoryClass(selectedActivity.category_id)">
                <a :href="`/activities/${selectedActivity.id}`">
                    {{ selectedActivity.title }} - {{ selectedActivity.date }}
                </a>
                <a 
                    class="btn btn-light" 
                    :class="$style.duplicateButton"
                    :href="`/activities/new?duplicate=${selectedActivity.id}`">
                        Duplicate
                </a>
            </div>
            <div :class="$style.selectedActivityContent">
                <div>{{ categoriesMap.get(selectedActivity.category_id).name }}</div>
                <div>{{ selectedActivity.description }}</div>
            </div>
        </div>
    </div>
</template>

<style lang="scss" module>
    .container {

    }
    .title {
        text-align: center;
        margin-bottom: 2.5rem;
    }
    .week {
        display: flex;
        padding: 0 0 3em;
    }
    .today {
        color: magenta;
    }
    .day {
        padding: 0 1em 1em;
        width: 300px;
    }
    .newActivityLink {
        color: #000;
    }
    .dayContents {
        padding: 1em;

        a {
            color: inherit;
        }
    }

    a.duplicateButton {
        display: inline-block;
        margin-left: 1em;
        color: #000;
    }

    .selectedActivityContent {
        padding: 1em;
    }

    @media (prefers-color-scheme: dark) {
        .newActivityLink {
            color: #fff;
        }
    }
</style>

<script>
import { formatDate, monthName, dateFromIso } from '../date';

export default {
    props: {
        activities: {
            type: Array,
            required: true,
        },
        categoriesMap: {
            type: Map,
            required: true,
        },
        month: {
            type: Number,
            required: true,
        },
        year: {
            type: Number,
            required: true,
        },
        startDate: {
            type: String,
            required: true,
        },
        endDate: {
            type: String,
            required: true,
        },
        todaysDate: {
            type: String,
            required: true,
        },
        newActivityUrl: {
            type: String,
            required: true,
        },
    },
    created(){
        this.setupActivities();
    },
    data(){
        return {
            daysMap: new Map(),
            weeks: [],
            selectedActivity: null,
        };
    },
    computed: {
    },
    watch: {
        activities(){
            this.setupActivities();
        },
    },
    methods: {
        monthName,
        formatDayDate(dayDate){
            return dayDate.split('-').slice(1,3).join('/');
        },
        getCategoryClass(categoryId){
            return [
                this.$style.dayContents,
                'category-color', 
                `category-color--${this.categoriesMap.get(categoryId).color}`
            ];
        },
        selectActivity(activity){
            this.selectedActivity = activity;
        },
        setupActivities(){
            this.selectedActivity = null;
            this.weeks = [];
            this.daysMap = new Map();

            this.activities.forEach(activity => {
                if(this.daysMap.has(activity.date)){
                    this.daysMap.get(activity.date).push(activity);
                }
                else {
                    this.daysMap.set(activity.date, [activity]);
                }
            });


            let currentDate = this.startDate;
            const endDate = dateFromIso(this.endDate);
            while(dateFromIso(currentDate) <= endDate){
                const week = [];
                for(let i=0;i<7;i++){
                    week.push({
                        date: currentDate,
                        activities: this.daysMap.get(currentDate),
                    });
                    const tomorrow = dateFromIso(currentDate);
                    tomorrow.setDate(tomorrow.getDate() + 1);
                    currentDate = formatDate(tomorrow);
                }
                this.weeks.push(week);
            }
        },
        generateNewActivityUrl(date){
            return `${this.newActivityUrl}?date=${date}`;
        },
    }
};
</script>