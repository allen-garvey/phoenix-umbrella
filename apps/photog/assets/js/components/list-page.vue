<template>
    <main class="main container">
        <div :class="$style.headerContainer">
            <h2 :class="$style.title">{{ title }}</h2>
            <router-link 
                :to="headerButton.route" 
                class="btn btn-sm"
                :class="[headerButton.className, $style.headerButton]"
                v-if="headerButton"
            >
                {{ headerButton.title }}
            </router-link>
        </div>
        <ul :class="$style.list" v-if="isInitialLoadComplete">
            <li v-for="item in items" :key="item.id || item.title">
                <router-link :to="item.route">{{ item.title }}</router-link>
            </li>
        </ul>
    </main>
</template>

<style lang="scss" module>
    .headerContainer {
        display: flex;
        flex-wrap: wrap;
        gap: 1em;
        margin-bottom: 2rem;
    }
    a.headerButton {
        align-self: center;
    }
    .title {
        margin: 0;
    }
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
        headerButton: {
            type: Object,
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