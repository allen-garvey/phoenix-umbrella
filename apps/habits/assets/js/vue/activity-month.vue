<template>
    <div :class="$style.container">
        <h3 :class="$style.title">{{ month }} / {{ year }}</h3>
        <div v-for="week in weeks" :class="$style.week">
            <div v-for="day in week" :class="$style.day">
                <h4>{{ day.date }}</h4>
                <div v-for="activity in day.activities">
                    <div>{{ activity.title }}</div>
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
</style>

<script>
import { formatDate } from '../date';

export default {
    props: {
        activities: {
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

        let currentDate = this.startDate;
        const endDate = new Date(this.endDate);
        while(true){
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

            if(new Date(currentDate) >= endDate){
                break;
            }
        }
        console.log(this.weeks);
    },
    data(){
        return {
            daysMap: new Map(),
            weeks: [],
        };
    },
    computed: {
    },
    watch: {
    },
    methods: {
    }
};
</script>