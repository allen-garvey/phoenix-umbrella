import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './components/app.vue'
import routes from './routes.js'

import css from '../sass/style.scss';

Vue.use(VueRouter);
const router = new VueRouter(routes);

(function(){
    const appContainer = document.getElementById('app');

    if(appContainer){
        const csrfToken = appContainer.dataset.csrfToken;

        new Vue({
            el: appContainer,
            render: h => h(App, {props: {csrfToken}}),
            router,
        });
    }
})();



