// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

import Vue from 'vue';
import LoginForm from './vues/login-form.vue';

(function(){
    const loginFormContainer = document.getElementById('login-form');
    
    if(loginFormContainer){
        const dataset = loginFormContainer.dataset;
        const csrfToken = dataset.csrfToken;
        const loginUrl = dataset.loginUrl;

        new Vue({
            el: loginFormContainer,
            render: h => h(LoginForm, {props: {csrfToken, loginUrl}}),
        });
    }
})();
