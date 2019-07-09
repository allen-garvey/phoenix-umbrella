<template>
    <main class="main container">
        <Resource-Header :title="title" :editItemLink="editItemLink" :newItemLink="newItemLink" />
        <ul class="text-list">
            <li v-for="(item, i) in itemsList" :key="i">
                <slot name="item" :item="item" :index="i"></slot>
            </li>
        </ul>
        <infinite-loading @infinite="loadMoreItemsCallback" spinner="waveDots" v-if="isInitialLoadComplete && loadMoreItemsCallback">
            <template v-slot:no-results><div></div></template>
            <template v-slot:no-more><div></div></template>
        </infinite-loading>
    </main>
</template>

<script>
import InfiniteLoading from 'vue-infinite-loading';
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
            InfiniteLoading,
        },
    };
</script>