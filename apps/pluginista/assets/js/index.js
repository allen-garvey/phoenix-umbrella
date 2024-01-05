import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeYesterdayButton } from 'umbrella-common-js/date-input.js';
import { initializeFormDeleteButton } from 'umbrella-common-js/form-delete-button.js';

import PluginCategories from './vue/plugin-categories.vue';
import PluginTable from './vue/plugin-table.vue';
import MakersReportTable from './vue/makers-report-table.vue';

import css from '../css/app.scss';

initializeYesterdayButton();
initializeFormDeleteButton();

instantiateVue('plugin-categories', PluginCategories, ['categories']);
instantiateVue('plugin-table', PluginTable, ['pluginsApiRoute']);
instantiateVue('makers-report-table', MakersReportTable, ['itemsApiRoute']);
