import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js'

import PlugCategories from './vue/plugin-categories.vue';

import css from '../css/app.scss';

instantiateVue('plugin-categories', PlugCategories, ['categories']);
