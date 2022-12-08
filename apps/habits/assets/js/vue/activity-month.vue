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
                <h4>{{ formatDayDate(day.date) }}</h4>
                <div 
                    v-for="activity in day.activities"
                    :key="activity.id"
                    :class="getCategoryClass(activity.category_id)"
                >
                    <div>
                        <a :href="`/activities/${activity.id}`" target="_blank">
                            {{ activity.title }}
                        </a>
                    </div>
                </div>
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
    .day {
        padding: 0 1em 1em;
        width: 300px;
    }
    .dayContents {
        padding: 1em;

        a {
            color: inherit;
        }
    }
</style>

<script>
import { formatDate, monthName } from '../date';

export default {
    props: {
        activities: {
            type: Array,
            required: true,
        },
        categories: {
            type: Array,
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
    },
    created(){
        this.activities.forEach(activity => {
            if(this.daysMap.has(activity.date)){
                this.daysMap.get(activity.date).push(activity);
            }
            else {
                this.daysMap.set(activity.date, [activity]);
            }
        });

        this.categories.forEach(category => this.categoriesColorMap.set(category.id, category.color));

        let currentDate = this.startDate;
        const endDate = new Date(this.endDate);
        while(new Date(currentDate) < endDate){
            const week = [];
            for(let i=0;i<7;i++){
                week.push({
                    date: currentDate,
                    activities: this.daysMap.get(currentDate),
                });
                const tomorrow = new Date(currentDate);
                tomorrow.setDate(tomorrow.getDate() + 1);
                currentDate = formatDate(tomorrow);
            }
            this.weeks.push(week);
        }
    },
    data(){
        return {
            daysMap: new Map(),
            categoriesColorMap: new Map(),
            weeks: [],
        };
    },
    computed: {
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
                `category-color--${this.categoriesColorMap.get(categoryId)}`
            ];
        },
    }
};
</script>