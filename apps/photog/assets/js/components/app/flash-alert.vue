<template>
    <div class="container">
        <div class="alert" :class="`alert-${alertClass}`">{{alertText}}</div>
    </div>
</template>

<script>
//note that you can't use v-if when not alertText or scrollIntoView won't work

export default {
    props: {
    },
    data() {
        return {
            alertClass: 'info',
            alertText: '',
        }
    },
    methods: {
        putFlash(message, type='info'){
            this.alertText = message;
            this.alertClass = type;
        },
        //can't clear flash automatically in route watch, since might be called after
        //flash message has already been put there
        clearFlash(){
            this.alertText = '';
        },
    }
}
</script>
