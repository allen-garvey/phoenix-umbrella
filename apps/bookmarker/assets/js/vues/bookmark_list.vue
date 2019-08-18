<template>
<div v-if="initialLoadComplete">
    <div v-if="bookmarks.length === 0">No bookmarks</div>
	<div v-else>
		<h4>Bookmarks</h4>
		<ul class="list-group folder-bookmark-list">
			<li class="list-group-item bookmark-item" :class="{'list-group-item-success preview-enabled': bookmark.preview_image_selector}" v-for="bookmark in bookmarks" :key="bookmark.id">
				<div>
					<div>
                        <a :href="bookmark.url" class="bookmark-title" rel="noreferrer noopener" target="_blank">{{bookmark.title}}</a>
                        <a :href="bookmark.self.show" class="btn btn-default btn-sm pull-right">Edit</a>
                    </div>
                    <div class="bookmark-url">{{ bookmark.url }}</div>
                        <div class="bookmark-description" v-if="bookmark.description"><p>{{bookmark.description}}</p></div>
                </div>
                <div class="bookmark-thumbnail-container">
                    <img :src="bookmark.thumbnail_url" v-if="bookmark.thumbnail_url" />
                </div>
            </li>
		</ul>
        <infinite-observer :on-trigger="loadBookmarks"></infinite-observer>
	</div>
</div>
</template>

<script>
import InfiniteObserver from '../../../../common/assets/js/vue/components/infinite-observer.vue';

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
        fetch(this.bookmarksApiUrl).then((res)=>{
            return res.json();
        }).then((json)=>{
            this.model = json.data;
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
    }
};
</script>