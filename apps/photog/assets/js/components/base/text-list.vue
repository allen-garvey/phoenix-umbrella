<template>
    <main class="main container">
        <Resource-Header 
            :title="title" 
            :editItemLink="editItemLink" 
            :newItemLink="newItemLink" 
        />
        <ul :class="$style['text-list']">
            <li v-for="(item, i) in itemsList" :key="i">
                <slot name="item" :item="item" :index="i"></slot>
            </li>
        </ul>
        <infinite-observer 
            :onTrigger="loadMoreItemsCallback" 
            v-if="isInitialLoadComplete && loadMoreItemsCallback"
        >
        </infinite-observer>
    </main>
</template>

<style lang="scss" module>
    .text-list > li{
        padding: 1em 0;
    }
</style>

<script>
import InfiniteObserver from 'umbrella-common-js/vue/components/infinite-observer.vue';
import ReasourceHeader from '../resource-header.vue';

export default {
        name: 'Text-List',
        props: {
            title: {
                type: String,
                required: true,
            },
            itemsList: {
                type: Array,
                required: true,
            },
            isInitialLoadComplete: {
                type: Boolean,
                required: true,
            },
            newItemLink: {
                type: Object,
            },
            editItemLink: {
                type: Object,
            },
            loadMoreItemsCallback: {
                type: Function
            },
        },
        components: {
            'Resource-Header': ReasourceHeader,
            InfiniteObserver,
        },
    };
</script>