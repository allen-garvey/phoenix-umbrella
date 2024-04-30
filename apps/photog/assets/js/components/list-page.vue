<template>
    <main class="main container">
        <h2>{{ title }}</h2>
        <ul :class="$style.list" v-if="isInitialLoadComplete">
            <li v-for="(item, index) in items" :key="index">
                <router-link :to="item.route">{{ item.title }}</router-link>
            </li>
        </ul>
    </main>
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
import { nextTick } from 'vue';

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
        title: {
            type: String,
            required: true,
        },
        getItems: {
            type: Function,
            required: true,
        },
    },
    data() {
        return {
            isInitialLoadComplete: false,
            items: [],
        }
    },
    created(){
        this.setup();
    },
    watch: {
        '$route'(to, from){
            nextTick().then(() => {
                this.setup();
            });
        }
    },
    methods: {
        setup(){
            this.isInitialLoadComplete = false;
            this.items = [];
            
            this.getItems(this.getModel).then((items) => {
                this.items = items;
                this.isInitialLoadComplete = true;
            });
        },
    },
};
</script>