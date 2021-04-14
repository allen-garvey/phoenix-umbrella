<template>
    <span>{{title}}</span>
    <span :class="$style['items-count']" v-if="itemsCount >= 0"> ({{itemsCount}})</span>
</template>

<style lang="scss" module>
    .items-count {
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
            required: true,
        },
    },
};
</script>