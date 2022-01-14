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
            <import-item :item="item" />
        </template>
    </Text-List>
</template>

<style lang="scss" module>
</style>

<script>
import TextList from './base/text-list.vue';
import ImportItem from './import-item.vue';

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
            ImportItem,
        },
        created(){
            this.setup();
        },
        data() {
            return {
                modelPath: '/imports',
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
