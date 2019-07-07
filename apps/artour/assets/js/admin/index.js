import css from '../../css/admin.scss';

import { initializeAutofillImageName } from './autofill_image_name.js';
initializeAutofillImageName();

import { initializeFormDeleteButton } from './form_delete_button.js';
initializeFormDeleteButton();

import { initializeAutofillSlug } from './slugify.js';
initializeAutofillSlug();

import { initializeVueComponent } from './vue-helpers.js';

import PostAddImages from './vues/post_add_images.vue';
(function(){
    const keys = ['csrfToken', 'formUrl', 'imagesApiUrl'];
    initializeVueComponent('post_add_images_component', PostAddImages, keys);
})();

import PostAlbumList from './vues/post_album_list.vue';
(function(){
    const keys = ['csrfToken', 'coverImageId', 'postImagesApiUrl', 'editPostApiUrl', 'reorderImagesApiUrl'];
    initializeVueComponent('post_album_list_component', PostAlbumList, keys);
})();

import PostAddTagsList from './vues/post_add_tags_list.vue';
(function(){
    const keys = ['csrfToken', 'postId', 'apiBaseUrl', 'newTagUrl'];
    initializeVueComponent('post_add_tags_list', PostAddTagsList, keys);
})();

import ImportImages from './vues/import_images.vue';
(function(){
    const keys = ['csrfToken', 'apiFormatIndexUrl', 'apiCreateImagesUrl', 'imagesIndexUrl'];
    initializeVueComponent('import_images', ImportImages, keys);
})();