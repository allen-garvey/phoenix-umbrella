import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeYesterdayButton } from 'umbrella-common-js/date-input.js';

import ActivityCalendar from './vue/activity-calendar.vue';

import css from '../css/app.scss';

initializeYesterdayButton();
instantiateVue('activity-calendar', ActivityCalendar);

document.querySelectorAll('[data-button="delete"]').forEach((button) => {
    button.onclick = (e) => {
        if (!confirm('Are you sure you want to delete?')) {
            e.preventDefault();
            return false;
        }
    };
});
