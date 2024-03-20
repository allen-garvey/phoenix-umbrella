<template>
    <div class="main container">
        <div 
            :class="$style.section"
            v-if="recentAlbums.length > 0"
        >
            <div :class="$style.flexHeader">
                <h3 :class="$style.sectionHeading">Recent Albums</h3>
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
                :miniThumbnailUrlFor="miniThumbnailUrlFor"
            />
        </div>

        <div 
            :class="$style.section"
            v-if="favoriteTags.length > 0"
        >
            <h3 :class="$style.sectionHeading">Favorite Tags</h3>
            <thumbnail-items-list
                :items="favoriteTags"
                :showRouteFor="showRouteForTag"
                :miniThumbnailUrlFor="miniThumbnailUrlFor"
            />
        </div>

        <div 
            :class="$style.section"
        >
            <router-link :to="{name: 'albumFavoritesIndex'}">
                 <h3 :class="$style.sectionHeading">Favorite Albums</h3>
            </router-link>
            <thumbnail-items-list
                :items="favoriteAlbums"
                :showRouteFor="showRouteForAlbum"
                :miniThumbnailUrlFor="miniThumbnailUrlFor"
                v-if="favoriteAlbums"
            />
        </div>
    </div>
</template>

<style lang="scss" module>
    .section {
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
import ThumbnailItemsList from './thumbnail-list/components/thumbnail-items-list.vue';

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
        miniThumbnailUrlFor: {
            type: Function,
            required: true,
        },
    },
    components: {
        ThumbnailItemsList,
    },
    created(){
        this.setWindowTitle('');

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