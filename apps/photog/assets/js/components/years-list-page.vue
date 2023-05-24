<template>
    <div class="main container">
        <h2>{{ title }}</h2>
        <ul :class="$style.list" v-if="isInitialLoadComplete">
            <li v-for="year in years" :key="year.year">
                <router-link 
                    :to="{
                        name: 'albumsForYear',
                        params: { year: year.year }
                    }"
                >
                    {{ year.year }}
                    <span :class="$style.count">({{ year.count }})</span>
                </router-link>
            </li>
        </ul>
        <loading-animation v-if="!isInitialLoadComplete" />
    </div>
</template>

<style lang="scss" module>
    .list {
        margin-top: 1rem;
        font-size: 2.1rem;
        
        li {
            margin-bottom: 2rem;
        }
    }

    .count {
        color: #aaa;
        font-size: 1.2rem;
        margin-left: 0.2em;
    }
</style>

<script>
import { nextTick } from 'vue';
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
    },
    components: {
        LoadingAnimation,
    },
    data() {
        return {
            isInitialLoadComplete: false,
            years: [],
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
    computed: {
        title(){
            return 'Albums for Year';
        },
    },
    methods: {
        setup(){
            this.isInitialLoadComplete = false;
            this.years = [];

            this.getModel('/albums/years/index').then(years => {
                console.log(years);
                this.years = years;
                this.isInitialLoadComplete = true;
            });
        },
    },
};
</script>