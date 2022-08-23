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
            <div :class="$style.flexHeader">
                <h2 :class="$style.sectionHeading">Recent Albums</h2>
                <router-link 
                    :to="{ name: 'albumsForYear', params: { year: currentYear } }"
                    :class="$style.headerSupplement"
                >
                    {{ currentYear }}
                </router-link>
            </div>
            <thumbnail-items-list
                :items="recentAlbums"
                :showRouteFor="showRouteForAlbum"
            />
        </div>

        <div 
            :class="$style.section"
            v-if="favoriteTags.length > 0"
        >
            <h2 :class="$style.sectionHeading">Favorite Tags</h2>
            <thumbnail-items-list
                :items="favoriteTags"
                :showRouteFor="showRouteForTag"
            />
        </div>

        <div 
            :class="$style.section"
        >
            <router-link :to="{name: 'albumFavoritesIndex'}">
                 <h2 :class="$style.sectionHeading">Favorite Albums</h2>
            </router-link>
            <thumbnail-items-list
                :items="favoriteAlbums"
                :showRouteFor="showRouteForAlbum"
                v-if="favoriteAlbums"
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

    .flexHeader {
        display: flex;
    }

    .headerSupplement {
        align-self: center;
        margin-left: 0.5em;
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
            limit: 6,
        }).then((albums) => {
            this.recentAlbums = albums;
        });

        this.getModel('/albums?favorites=true', {
            isPaginated: true,
            offset: 0,
            limit: 12,
        }).then((albums) => {
            this.favoriteAlbums = albums;
        });

        this.getModel('/tags?is_favorite=1').then((tags) => {
            this.favoriteTags = tags;
        });
    },
    data(){
        return {
            lastImport: null,
            recentAlbums: [],
            favoriteTags: [],
            favoriteAlbums: [],
        };
    },
    computed: {
        currentYear(){
            return new Date().getFullYear();
        },
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
        showRouteForTag(item, _model) {
            return {
                name: 'tagsShow',
                params: {
                    id: item.id,
                },
            };
        },
    }
};
</script>