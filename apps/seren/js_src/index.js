import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './components/app.vue'
import routes from './routes.js'


Vue.use(VueRouter);
const router = new VueRouter(routes);

new Vue({
    el: '#app',
    render: h => h(App),
    router,
});