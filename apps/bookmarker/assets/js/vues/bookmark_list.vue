<template>
<div v-if="initialLoadComplete">
    <div v-if="bookmarks.length === 0">No bookmarks</div>
	<div v-else>
		<h4>Bookmarks</h4>
		<ul 
            class="list-group"
            :class="$style['folder-bookmark-list']"
        >
			<li 
                class="list-group-item" 
                :class="bookmarkItemClasses(bookmark)" 
                v-for="bookmark in bookmarks" 
                :key="bookmark.id"
            >
				<div :class="$style['bookmark-header-container']">
					<div :class="$style['bookmark-title-container']">
                        <a 
                            :href="bookmark.url" 
                            :class="$style['bookmark-title']" 
                            rel="noreferrer noopener" 
                            target="_blank"
                        >
                            {{bookmark.title}}
                        </a>
                        <a 
                            :href="bookmark.self.show" 
                            class="btn btn-default btn-sm pull-right"
                        >
                            Edit
                        </a>
                    </div>
                    <div :class="$style['bookmark-url']">{{ bookmark.url }}</div>
                        <div 
                            :class="$style['bookmark-description']" v-if="bookmark.description"
                        >
                            <p>{{bookmark.description}}</p>
                        </div>
                </div>
                <div :class="$style['bookmark-thumbnail-container']">
                    <img :src="bookmark.thumbnail_url" v-if="bookmark.thumbnail_url" />
                </div>
            </li>
		</ul>
        <infinite-observer :on-trigger="loadBookmarks"></infinite-observer>
	</div>
</div>
</template>

<style lang="scss" module>
    .folder-bookmark-list{
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        margin-top: 0;
    }

    .bookmark-url, 
    .bookmark-description{
        font-size: 0.9em;
    }

    .bookmark-url{
        color: #888;
    }

    .bookmark-title{
        font-size: 16px;
    }

    .bookmark-header-container{
        margin-bottom: 5px;
    }

    .bookmark-title-container{
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        margin-bottom: 3px;
    }

    .bookmark-thumbnail-container{
        &:empty{
            display: none;
        }
    }

    .bookmark-item{
        border: none;
        flex-basis: 33%;

        @media screen and (max-width: 870px){
            flex-basis: 50%;
        }
        @media screen and (max-width: 584px){
            flex-basis: 100%;
        }
    }
</style>

<script>
import InfiniteObserver from 'umbrella-common-js/vue/components/infinite-observer.vue';
import { fetchJson } from 'umbrella-common-js/ajax.js';

const BOOKMARK_PAGE_SIZE = 6;

export default {
    props: {
        bookmarksApiUrl: {
            type: String,
            required: true,
        },
    },
    components: {
        InfiniteObserver,
    },
    created(){
        fetchJson(this.bookmarksApiUrl).then((data)=>{
            this.model = data;
            this.initialLoadComplete = true;
        });
    },
    data(){
        return {
            initialLoadComplete: false,
            model: [],
            currentPage: 1,
        };
    },
    computed: {
        bookmarks(){
            return this.model.slice(0, this.currentPage * BOOKMARK_PAGE_SIZE);
        },
    },
    methods: {
        loadBookmarks($state){
            this.currentPage++;

            if(this.bookmarks.length === this.model.length){
                $state.complete();
            }
            else{
                $state.loaded();
            }
        },
        bookmarkItemClasses(bookmark){
            return {
                [this.$style['bookmark-item']]: true,
                'list-group-item-success': bookmark.preview_image_selector,
            };
        },
    }
};
</script>