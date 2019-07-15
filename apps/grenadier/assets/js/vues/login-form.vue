<template>
    <form class="login-form" @submit.prevent="formSubmitted()">
        <input type="text" placeholder="Identifier" v-model="username" />
        <input type="password" placeholder="Proof" v-model="password" />
        <button type="submit">Login</button>
    </form>
</template>

<script>
export default {
    props: {
        csrfToken: {
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

        },
    }
};
</script>

