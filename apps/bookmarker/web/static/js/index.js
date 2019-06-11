import Vue from 'vue';
import BookmarkTagList from './vues/bookmark_tag_list.vue';


(function(){
    const bookmarkTagListContainer = document.getElementById('bookmark_tag_list');

    if(bookmarkTagListContainer){
        const props = {};
        [
            'csrfToken',
            'bookmarkId', 
            'newTagUrl', 
            'newBookmarkTagUrl', 
            'deleteBookmarkTagUrl',
            'tagsUrl',
            'unusedTagsUrl',
        ].forEach((key)=>{
            props[key] = bookmarkTagListContainer.dataset[key];
        });

        new Vue({
            el: bookmarkTagListContainer,
            render: h => h(BookmarkTagList, {props}),
        });
    }
})();



