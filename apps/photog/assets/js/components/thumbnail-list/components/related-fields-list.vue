<template>
    <ul :class="$style.relatedFieldsList">
        <li 
            v-for="item in items" 
            :key="item.id" 
            :class="$style.listItem"
        >
            <router-link :to="item.to">{{ item.name }}</router-link>
        </li>
    </ul>
</template>

<style lang="scss" module>
    .relatedFieldsList{
        display: flex;
        flex-wrap: wrap;
        gap: 0.5em;
    }

    .listItem{
        padding: 1em;
        background-color: #eee;
        border-radius: 4px;
    }
</style>

<script>
export default {
    props: {
        items: {
            type: Array,
            default: [],
        },
    },
};
</script>