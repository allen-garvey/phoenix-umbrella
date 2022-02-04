<template>
    <template v-for="(part, i) in pathSplit" :key="i">
        <span>{{ part }}</span>
        <strong :class="$style.pathSlash">/</strong>
    </template>
</template>

<style lang="scss" module>
.pathSlash{
    margin: 0 0.4em;
    &:last-of-type{
        display: none;
    }
}
</style>

<script>
export default {
    props: {
        path: {
            type: String,
            required: true,
        },
    },
    computed: {
        pathSplit(){
            return this.path.split('/');
        },
    },
};
</script>