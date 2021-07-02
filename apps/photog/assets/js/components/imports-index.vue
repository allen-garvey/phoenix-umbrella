<template>
    <Text-List 
        :title="pageTitle"
        :count="itemsList.length"
        :total="model.length"
        :itemsList="itemsList" 
        :isInitialLoadComplete="isInitialLoadComplete"
        :loadMoreItemsCallback="loadMoreItems"
    >
        <template v-slot:item="{item, index}">
            <router-link :to="showRouteFor(item)">
                <div>{{titleFor(item)}}</div>
                <ul :class="$style.thumbnailList">
                    <li v-for="image in item.images" :key="image.id">
                        <img :src="thumbnailUrlFor(image)" loading="lazy"/>
                    </li>
                </ul>
            </router-link>
        </template>
    </Text-List>
</template>

<style lang="scss" module>
    .thumbnailList{
        display: inline-flex;
        flex-wrap: wrap;
        img{
            object-fit: cover;
            object-position: center;
            height: 130px;
            width: 140px;
            transition: width 0.4s, height 0.75s;
        }

        &:hover{
            img{
                height: 240px;
                width: 280px;
            }
        }
    }
</style>

<script>
import { thumbnailUrlFor } from '../image.js';
import TextList from './base/text-list.vue';

const ITEMS_PAGINATION_LIMIT_INITIAL = 10;
const ITEMS_PAGINATION_LIMIT_SCROLL = 30;

export default {
        props: {
            setWindowTitle: {
                type: Function,
                required: true,
            },
            getModel: {
                type: Function,
                required: true,
            },
        },
        components: {
            'Text-List': TextList,
        },
        created(){
            this.setup();
        },
        data() {
            return {
                modelPath: '/imports',
                showRouteName: 'importsShow',
                model: [],
                //need this property or there will be errors when we switch routes and new models haven't been loaded yet
                isInitialLoadComplete: false,
                pageTitle: 'Imports',
                numItemsShown: 0,
            }
        },
        computed: {
            itemsList(){
                if(!this.isInitialLoadComplete){
                    return [];
                }
                return this.model.slice(0, this.numItemsShown);
            },
        },
        watch: {
            '$route'(to, from){
                this.setup();
            }
        },
        methods: {
            setup(){
                this.setWindowTitle(this.pageTitle);
                this.isInitialLoadComplete = false;
                this.getModel(this.modelPath).then((itemsJson)=>{
                    this.model = itemsJson;
                    this.numItemsShown = Math.min(this.numItemsShown + ITEMS_PAGINATION_LIMIT_INITIAL, this.model.length);
                    this.isInitialLoadComplete = true;
                });
            },
            showRouteFor(item){
                return {
                    name: this.showRouteName,
                    params: {
                        id: item.id,
                    },
                };
            },
            titleFor(item){
                return item.name;
            },
            titleFor(item){
                return `${item.name} (${item.images_count})`;
            },
            thumbnailUrlFor(image){
                return thumbnailUrlFor(image.mini_thumbnail_path);
            },
            //to make the code a bit easier, there are only 2 states for the infinite scroll
            //at first load we only load the most recent imports, but if you scroll down we just load everything
            //instead of incremental loads with offsets
            loadMoreItems($state){
                this.numItemsShown = Math.min(this.numItemsShown + ITEMS_PAGINATION_LIMIT_SCROLL, this.model.length);
                if(this.numItemsShown === this.model.length) {
                    $state.complete();
                }
                else {
                    $state.loaded();
                }
            },
        }
    };
</script>
