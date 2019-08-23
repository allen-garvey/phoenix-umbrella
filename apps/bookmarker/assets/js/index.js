import Vue from 'vue';
import { instantiateVue } from '../../../common/assets/js/vue/instantiate-vue';

import BookmarkTagList from './vues/bookmark_tag_list.vue';
import BookmarkList from './vues/bookmark_list.vue';

import css from '../css/app.scss';


(function(){
    const propKeys = [
        'csrfToken',
        'bookmarkId', 
        'newTagUrl', 
        'newBookmarkTagUrl', 
        'deleteBookmarkTagUrl',
        'tagsUrl',
        'unusedTagsUrl',
    ];

    instantiateVue('bookmark_tag_list', BookmarkTagList, propKeys);
})();

(function(){
    const propKeys = [
        'bookmarksApiUrl',
    ];

    instantiateVue('bookmark_list', BookmarkList, propKeys);
})();


