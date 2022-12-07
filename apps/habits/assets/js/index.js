import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js'

import ActivityCalendar from './vue/activity-calendar.vue';

import css from '../css/app.scss';

instantiateVue('activity-calendar', ActivityCalendar);