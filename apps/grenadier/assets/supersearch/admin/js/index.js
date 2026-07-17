import { instantiateVue } from 'umbrella-common-js/vue/instantiate-vue.js';
import { initializeFormDeleteButton } from 'umbrella-common-js/form-delete-button.js';
import EnginesList from './vues/engines-list.vue';

import '../css/app.scss';

initializeFormDeleteButton();

instantiateVue('engines-list', EnginesList, [
    'csrfToken',
    'reorderEnginesUrl',
    'enginesApiUrl',
    'adminEnginesUrlBase',
]);
