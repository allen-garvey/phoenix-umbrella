<template>
    <div class="main container">
        <h2>{{ title }}</h2>
        <ul :class="$style.list">
            <li v-for="(item, index) in items" :key="index">
                <router-link :to="item.route">{{ item.title }}</router-link>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    .list {
        margin-top: 1rem;
        font-size: 1.5rem;
        
        li {
            margin-bottom: 2rem;
        }
    }
</style>

<script>
export default {
    props: {
        title: {
            type: String,
            required: true,
        },
        items: {
            type: Array,
            required: true,
        },
    },
};
</script>