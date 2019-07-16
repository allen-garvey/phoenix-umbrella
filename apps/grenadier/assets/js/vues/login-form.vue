<template>
    <form class="login-form" method="POST" :action="loginUrl">
        <input type="hidden" name="_csrf_token" :value="csrfToken" />
        <input name="_utf8" type="hidden" value="✓">
        <input type="text" placeholder="Identifier" name="username" v-model="username" />
        <input type="password" placeholder="Proof" name="password" v-model="password" />
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
    methods: {
    }
};
</script>

