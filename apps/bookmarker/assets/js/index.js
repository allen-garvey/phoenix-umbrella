import Vue from 'vue';
import BookmarkTagList from './vues/bookmark_tag_list.vue';
import BookmarkList from './vues/bookmark_list.vue';

import css from '../css/app.scss';


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

(function(){
    const bookmarkList = document.getElementById('bookmark_list');
    if(bookmarkList){
        const props = {};
        [
            'bookmarksApiUrl',
        ].forEach((key)=>{
            props[key] = bookmarkList.dataset[key];
        });

        new Vue({
            el: bookmarkList,
            render: h => h(BookmarkList, {props}),
        });
    }
})();


