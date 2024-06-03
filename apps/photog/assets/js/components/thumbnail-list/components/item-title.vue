<template>
    <span>{{title}}</span>
    <span :class="$style.itemsCount" v-if="itemsCount >= 0"> ({{itemsCount}})</span>
</template>

<style lang="scss" module>
    .itemsCount {
        color: #aaa;
        font-size: 0.8em;
    }
</style>
<script>
export default {
    props: {
        title: {
            type: String,
            required: true,
        },
        itemsCount: {
            type: Number,
            default: -1,
        },
    },
};
</script>