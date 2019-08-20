import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './components/app.vue'
import routes from './routes.js'
import { instantiateVue } from '../../../common/assets/js/vue/instantiate-vue.js'

import css from '../sass/style.scss';

Vue.use(VueRouter);
const router = new VueRouter(routes);

instantiateVue('app', App, ['csrfToken'], {router});



