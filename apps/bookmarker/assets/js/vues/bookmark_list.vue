<template>
<div v-if="initialLoadComplete">
    <div v-if="bookmarks.length === 0">No bookmarks</div>
	<div v-else>
		<h4>Bookmarks</h4>
		<ul 
            class="list-group"
            :class="$style.folderBookmarkList"
        >
			<li 
                class="list-group-item" 
                :class="bookmarkItemClasses(bookmark)" 
                v-for="bookmark in bookmarks" 
                :key="bookmark.id"
            >
				<div :class="$style.bookmarkHeaderContainer">
					<div :class="$style.bookmarkTitleContainer">
                        <a 
                            :href="bookmark.url" 
                            :class="$style.bookmarkTitle" 
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
                    <div :class="$style.bookmarkUrl">{{ bookmark.url }}</div>
                        <div 
                            :class="$style.bookmarkDescription" v-if="bookmark.description"
                        >
                            <p>{{bookmark.description}}</p>
                        </div>
                </div>
                <div :class="$style.bookmarkThumbnailContainer">
                    <img :src="bookmark.thumbnail_url" loading="lazy" v-if="bookmark.thumbnail_url" />
                </div>
            </li>
		</ul>
        <infinite-observer :on-trigger="loadBookmarks"></infinite-observer>
	</div>
</div>
</template>

<style lang="scss" module>
    .folderBookmarkList{
        min-height: 100vh;
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        margin-top: 0;
        flex-direction: row;
        gap: 1rem;
    }

    .bookmarkUrl, 
    .bookmarkDescription{
        font-size: 0.9em;
    }

    .bookmarkUrl{
        color: #888;
        word-wrap: break-word;
    }

    .bookmarkTitle{
        font-size: 16px;
    }

    .bookmarkHeaderContainer{
        margin-bottom: 5px;
    }

    .bookmarkTitleContainer{
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        margin-bottom: 3px;
    }

    .bookmarkThumbnailContainer{
        &:empty{
            display: none;
        }
    }

    .bookmarkItem{
        border: none;
        width: 32%;
        padding: 10px 15px;

        @media screen and (max-width: 1020px){
            width: 48%;
        }
        @media screen and (max-width: 640px){
            width: 100%;
        }
    }
</style>

<script>
import InfiniteObserver from 'umbrella-common-js/vue/components/infinite-observer.vue';
import { fetchJson } from 'umbrella-common-js/ajax.js';

const BOOKMARK_PAGE_SIZE = 16;

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
                [this.$style.bookmarkItem]: true,
                'list-group-item-success': bookmark.preview_image_selector,
            };
        },
    }
};
</script>