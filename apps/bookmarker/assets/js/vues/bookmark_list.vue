<template>
<div v-if="initialLoadComplete">
    <div v-if="bookmarks.length === 0">No bookmarks</div>
	<div v-else>
		<h4>Bookmarks</h4>
		<ul class="list-group folder-bookmark-list">
			<li class="list-group-item bookmark-item" :class="{'list-group-item-success preview-enabled': bookmark.preview_image_selector}" v-for="bookmark in bookmarks" :key="bookmark.id">
				<div>
					<div>
                        <a :href="bookmark.url" class="bookmark-title">{{bookmark.title}}</a>
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
	</div>
</div>
</template>

<script>
export default {
    props: {
        bookmarksApiUrl: {
            type: String,
            required: true,
        },
    },
    components: {
    },
    created(){
        fetch(this.bookmarksApiUrl).then((res)=>{
            return res.json();
        }).then((json)=>{
            this.bookmarks = json.data;
            this.initialLoadComplete = true;
        });
    },
    data(){
        return {
            initialLoadComplete: false,
            bookmarks: [],
        };
    },
    computed: {
    },
    methods: {
    }
};
</script>