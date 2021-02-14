<template>
    <div>
        <h1 @click="showForm()" v-if="!shouldShowForm">Under Construction</h1>
        <form class="login-form" method="POST" :action="loginUrl" v-if="shouldShowForm">
            <input type="hidden" name="_csrf_token" :value="csrfToken" />
            <input name="_utf8" type="hidden" value="✓"/>
            <input name="redirect" type="hidden" :value="redirect">
            <input type="text" placeholder="Identifier" name="username" v-model="username" v-focus />
            <input type="password" placeholder="Proof" name="password" v-model="password" />
            <button type="submit">Login</button>
        </form>
    </div>
</template>

<script>
import { sendJson } from 'umbrella-common-js/ajax.js';
import focus from './directives/focus.js';

export default {
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        loginUrl: {
            type: String,
            required: true,
        },
    },
    directives: {
        focus,
    },
    data(){
        return {
            shouldShowForm: false,
            username: '',
            password: '',
        };
    },
    computed: {
        redirect() {
            const urlParams = new URLSearchParams(window.location.search);
            return urlParams.get('redirect');
        }
    },
    methods: {
        showForm(){
            this.shouldShowForm = true;
        },
    }
};
</script>

