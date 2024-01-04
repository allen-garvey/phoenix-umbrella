import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeFormDeleteButton } from 'umbrella-common-js/form-delete-button.js';

import BookmarkTagList from './vues/bookmark_tag_list.vue';
import BookmarkList from './vues/bookmark_list.vue';

import css from '../css/app.scss';

initializeFormDeleteButton();

(function () {
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

(function () {
    const propKeys = ['bookmarksApiUrl'];

    instantiateVue('bookmark_list', BookmarkList, propKeys);
})();
