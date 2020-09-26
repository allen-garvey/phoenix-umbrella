import { createRouter, createWebHistory } from 'vue-router';
import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import App from './components/app.vue';
import routes from './routes.js';

import css from '../sass/style.scss';


const router = createRouter({...routes, history: createWebHistory()});

instantiateVue('app', App, [], router);