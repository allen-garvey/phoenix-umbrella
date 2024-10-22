import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeFormDeleteButton } from 'umbrella-common-js/form-delete-button.js';

import BookmarkList from './vues/bookmark_list.vue';

import css from '../css/app.scss';

initializeFormDeleteButton();

(function () {
    const propKeys = ['bookmarksApiUrl'];

    instantiateVue('bookmark_list', BookmarkList, propKeys);
})();
