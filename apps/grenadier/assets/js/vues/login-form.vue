<template>
    <form class="login-form" @submit.prevent="formSubmitted()">
        <input type="text" placeholder="Identifier" v-model="username" />
        <input type="password" placeholder="Proof" v-model="password" />
        <button type="submit">Login</button>
    </form>
</template>

<script>
import { sendJson } from '../ajax.js';

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
    components: {
    },
    data(){
        return {
            username: '',
            password: '',
        };
    },
    computed: {
    },
    watch: {
    },
    methods: {
        formSubmitted(){
            sendJson(this.loginUrl, this.csrfToken, 'POST', {
                username: this.username,
                password: this.password,
            })
        },
    }
};
</script>

