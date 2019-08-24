import Vue from 'vue';
import VueRouter from 'vue-router';
import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import App from './components/app.vue';
import routes from './routes.js';

import css from '../sass/style.scss';


Vue.use(VueRouter);

const options = {
    router: new VueRouter(routes),
};

instantiateVue('app', App, [], options);