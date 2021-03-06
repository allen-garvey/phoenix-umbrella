// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from '../css/app.scss';

import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import LoginForm from './vues/login-form.vue';

(function(){
    const propKeys = [
        'csrfToken',
        'loginUrl',
    ];

    instantiateVue('login-form', LoginForm, propKeys);
})();
