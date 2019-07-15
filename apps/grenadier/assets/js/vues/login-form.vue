<template>
    <div class="login-form">
        <input type="text" placeholder="Identifier"/>
        <input type="password" placeholder="Proof"/>
        <button>Login</button>
    </div>
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
    created(){
    },
    mounted(){
    },
    data(){
        return {
        };
    },
    computed: {
    },
    watch: {
    },
    methods: {
    }
};