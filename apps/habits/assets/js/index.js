import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeYesterdayButton } from 'umbrella-common-js/date-input.js';
import { initializeFormDeleteButton } from 'umbrella-common-js/form-delete-button.js';
import { initializeActivityFormLoadTags } from './activity-form-load-tags';

import { initializeSummaryTagsList } from './summary-tags-list';

import ActivityCalendar from './vue/activity-calendar.vue';

import css from '../css/app.scss';

initializeYesterdayButton();
initializeFormDeleteButton();
instantiateVue('activity-calendar', ActivityCalendar, ['newActivityUrl']);
initializeActivityFormLoadTags();
initializeSummaryTagsList();
