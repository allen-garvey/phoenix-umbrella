import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js'

import ActivityCalendar from './vue/activity-calendar.vue';

import css from '../css/app.scss';

instantiateVue('activity-calendar', ActivityCalendar);

document.querySelectorAll('[data-button="delete"]').forEach(button => {
    button.onclick = (e) => {
        if(!confirm('Are you sure you want to delete?')){
            e.preventDefault();
            return false;
        }
    };
});