import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js'

import PlugCategories from './vue/plugin-categories.vue';

import css from '../css/app.scss';

instantiateVue('plugin-categories', PlugCategories, ['categories']);

document.querySelectorAll('[data-button="delete"]').forEach(button => {
    button.onclick = (e) => {
        if(!confirm('Are you sure you want to delete?')){
            e.preventDefault();
            return false;
        }
    };
});
