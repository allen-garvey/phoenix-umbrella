import { buildImportsShowVariant } from '../route-helpers/imports.js';

import ImportsIndex from '../components/imports-index.vue';
import ImportForm from '../components/import-form.vue';

export default () => [
    {
        path: '/imports',
        name: 'importsIndex',
        component: ImportsIndex,
    },
    //has to be before importsShow route
    buildImportsShowVariant('/imports/last', 'importsShowLast', {
        buildItemsApiUrl: model => `/imports/${model.id}/images`,
    }),
    buildImportsShowVariant('/imports/:id', 'importsShow'),
    {
        path: '/imports/:id/edit',
        name: 'importsEdit',
        component: ImportForm,
        props: route => {
            return {
                modelId: parseInt(route.params.id),
            };
        },
    },
];
