<template>
    <span class="help-block">
        <p v-for="(error, i) in errors" :key="i">{{error}}</p>
    </span>
</template>

<script>
export default {
    props: {
        errors: {
            type: Array,
            default: [],
        },
    },
    data(){
        return {
        };
    },
    computed: {
    },
    methods: {
    }
};
</script>