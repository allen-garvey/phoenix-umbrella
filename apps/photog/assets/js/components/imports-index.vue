<template>
    <Text-List 
        :title="pageTitle"
        :count="model.length"
        :total="itemsCount"
        :itemsList="model" 
        :isInitialLoadComplete="isInitialLoadComplete"
        :loadMoreItemsCallback="loadMoreItems"
    >
        <template v-slot:item="{item, index}">
            <router-link :to="showRouteFor(item)">
                <div>{{ titleFor(item) }}</div>
                <p :class="$style.itemNotes" v-if="item.camera_model">{{ item.camera_model }}</p>
                <p :class="$style.itemNotes" v-if="item.notes">{{ item.notes }}</p>
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
            width: 400px;
            transition: width 0.4s, height 0.75s;
        }

        &:hover{
            img{
                height: 240px;
                width: 600px;
            }
        }
    }
    .itemNotes{
        color: #777;
        margin: 0;
    }
</style>

<script>
import { thumbnailUrlFor } from '../image.js';
import TextList from './base/text-list.vue';

const ITEMS_CHUNK_SIZE = 10;

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
                itemsCount: 0,
            }
        },
        computed: {
            itemsOffset(){
                return this.model.length;
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
                const getModelPromise = this.getModel(this.modelPath, 
                {
                    isPaginated: true, 
                    limit: ITEMS_CHUNK_SIZE, 
                    offset: this.itemsOffset
                })
                .then((itemsJson)=>{
                    this.model = itemsJson;
                });
                const getCountPromise = this.getModel(`${this.modelPath}/count`).then((count)=>{
                    this.itemsCount = count;
                });
                Promise.all([getModelPromise, getCountPromise]).then(() => {
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
                this.getModel(this.modelPath, 
                {
                    isPaginated: true, 
                    limit: ITEMS_CHUNK_SIZE, 
                    offset: this.itemsOffset,
                })
                .then((itemsJson)=>{
                    this.model = itemsJson;
                    
                    if(this.itemsOffset === this.itemsCount) {
                        $state.complete();
                    }
                    else {
                        $state.loaded();
                    }
                });
            },
        }
    };
</script>
