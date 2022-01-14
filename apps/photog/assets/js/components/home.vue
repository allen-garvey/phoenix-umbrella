<template>
    <div class="main container">
        <div 
            :class="$style.section"
            v-if="lastImport">
            <h2 :class="$style.sectionHeading">Last Import</h2>
            <import-item :item="lastImport" />
        </div>
        <div 
            :class="$style.section"
            v-if="recentAlbums.length > 0"
        >
            <h2 :class="$style.sectionHeading">Recent Albums</h2>
            <thumbnail-items-list
                :items="recentAlbums"
                :model="[]"
                :showRouteFor="showRouteForAlbum"
                :batchSelectedItems="[]"
                :batchSelectItem="()=>{}"
                :itemDragStart="()=>{}"
                :itemDragOver="()=>{}"
                :currentDragIndex="-1"
                :thumbnailLinkEvent="''"
                :isReordering="false"
                :isCurrentlyBatchSelect="false"
                @itemHover="()=>{}"
                @itemHoverEnd="()=>{}"
            />
        </div>
    </div>
</template>

<style lang="scss" module>
    .section {
        margin-bottom: 2rem;
    }
    .sectionHeading {
        margin: 0 0 0.5rem;
    }
</style>

<script>
import ImportItem from './import-item.vue';
import ThumbnailItemsList from './thumbnail-list/components/thumbnail-items-list.vue';

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
    },
    components: {
        ImportItem,
        ThumbnailItemsList,
    },
    created(){
        this.getModel('/imports', {
            isPaginated: true,
            offset: 0,
            limit: 1,
        }).then((imports) => {
            if(imports && imports.length > 0){
                this.lastImport = imports[0];
            }
        });

        this.getModel('/albums', {
            isPaginated: true,
            offset: 0,
            limit: 10,
        }).then((albums) => {
            this.recentAlbums = albums;
        });
    },
    data(){
        return {
            lastImport: null,
            recentAlbums: [],
            favoriteTags: [],
        };
    },
    computed: {
    },
    methods: {
        showRouteForAlbum(item, _model) {
            return {
                name: 'albumsShow',
                params: {
                    id: item.id,
                },
            };
        },
    }
};
</script>