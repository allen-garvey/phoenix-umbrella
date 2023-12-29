import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeYesterdayButton } from 'umbrella-common-js/date-input.js';

import PluginCategories from './vue/plugin-categories.vue';
import PluginTable from './vue/plugin-table.vue';

import css from '../css/app.scss';

initializeYesterdayButton();

instantiateVue('plugin-categories', PluginCategories, ['categories']);
instantiateVue('plugin-table', PluginTable, ['pluginsApiRoute']);

document.querySelectorAll('[data-button="delete"]').forEach((button) => {
    button.onclick = (e) => {
        if (!confirm('Are you sure you want to delete?')) {
            e.preventDefault();
            return false;
        }
    };
});
