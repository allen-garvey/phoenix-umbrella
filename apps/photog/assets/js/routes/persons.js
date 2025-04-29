import {
    getPersonsShowApiPath,
    getPersonsShowSharedProps,
} from '../route-helpers/persons';

import { API_URL_BASE } from '../request-helpers';

import ThumbnailList from '../components/thumbnail-list.vue';
import PersonForm from '../components/person-form.vue';

export default () => [
    {
        path: '/persons',
        name: 'personsIndex',
        component: ThumbnailList,
        props: route => {
            const props = {
                apiPath: route.path,
                newItemLink: { name: 'personsNew' },
                pageTitle: 'Persons',
                showRouteFor: (item, _model) => {
                    return {
                        name: 'personsShow',
                        params: {
                            id: item.id,
                        },
                    };
                },
            };
            return props;
        },
    },
    //new route has to be before show route
    {
        path: '/persons/new',
        name: 'personsNew',
        component: PersonForm,
    },
    {
        path: '/persons/:id/edit',
        name: 'personsEdit',
        component: PersonForm,
        props: route => {
            return {
                modelId: parseInt(route.params.id),
            };
        },
    },
    {
        path: '/persons/:id',
        name: 'personsShow',
        component: ThumbnailList,
        props: route => {
            const personId = route.params.id;

            const props = {
                ...getPersonsShowSharedProps(personId),
                isDeleteEnabled: true,
                buildItemsApiUrl: () => `${route.path}/images`,
                itemsCountKey: 'images_count',
                enableHasAlbumFilter: true,
                headerExtraLinks: [
                    {
                        class: 'btn-outline-dark',
                        link: {
                            name: 'personsShowFavorites',
                            params: { id: personId },
                        },
                        text: 'Favorites',
                    },
                ],
                updateItemFavorite(sendJson, item) {
                    const id = item.id;

                    const newValue = !item.is_favorite;
                    item.is_favorite = newValue;

                    const apiUrl = `${API_URL_BASE}/images/${id}`;

                    return sendJson(apiUrl, 'PATCH', {
                        image: {
                            id,
                            is_favorite: newValue,
                        },
                    });
                },
            };
            return props;
        },
    },
    {
        path: '/persons/:id/favorites',
        name: 'personsShowFavorites',
        component: ThumbnailList,
        props: route => {
            const personId = route.params.id;
            const itemApiPath = getPersonsShowApiPath(personId);

            const props = {
                ...getPersonsShowSharedProps(personId),
                buildItemsApiUrl: () => `${itemApiPath}/images/favorites`,
                apiItemsCountPath: `${itemApiPath}/images/favorites/count`,
                headerExtraLinks: [
                    {
                        class: 'btn-outline-dark',
                        link: {
                            name: 'personsShow',
                            params: { id: personId },
                        },
                        text: 'All images',
                    },
                ],
            };
            return props;
        },
    },
];
