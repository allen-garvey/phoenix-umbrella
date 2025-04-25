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
            const props = {
                useBigThumbnails: true,
                batchRemoveItemsCallback(image_ids, sendJSON) {
                    const personId = route.params.id;
                    return sendJSON(
                        `/api/persons/${personId}/images`,
                        'DELETE',
                        { image_ids }
                    );
                },
                setCoverImageCallback(cover_image_id, sendJSON) {
                    const personId = route.params.id;
                    return sendJSON(`/api/persons/${personId}`, 'PATCH', {
                        person: {
                            cover_image_id,
                        },
                    });
                },
                apiPath: route.path,
                buildItemsApiUrl: () => `${route.path}/images`,
                itemsCountKey: 'images_count',
                isPaginated: true,
                enableHasAlbumFilter: true,
                enableBatchSelectImages: true,
                editItemLinkFor: () => ({
                    name: 'personsEdit',
                    params: { id: route.params.id },
                }),
                isDeleteEnabled: true,
                itemPreviewContentCallback: image =>
                    image.albums.map(album => album.name).join(', '),
                showRouteFor: (item, _model) => {
                    return {
                        name: 'personImagesShow',
                        params: {
                            person_id: route.params.id,
                            image_id: item.id,
                        },
                    };
                },
                headerExtraLinks: [
                    {
                        class: 'btn-outline-dark',
                        link: {
                            name: 'personsShowFavorites',
                            params: { id: route.params.id },
                        },
                        text: 'Favorites',
                    },
                ],
            };
            return props;
        },
    },
    {
        path: '/persons/:id/favorites',
        name: 'personsShowFavorites',
        component: ThumbnailList,
        props: route => {
            const itemApiPath = `/persons/${route.params.id}`;

            const props = {
                useBigThumbnails: true,
                batchRemoveItemsCallback(image_ids, sendJSON) {
                    const personId = route.params.id;
                    return sendJSON(
                        `/api/persons/${personId}/images`,
                        'DELETE',
                        { image_ids }
                    );
                },
                setCoverImageCallback(cover_image_id, sendJSON) {
                    const personId = route.params.id;
                    return sendJSON(`/api/persons/${personId}`, 'PATCH', {
                        person: {
                            cover_image_id,
                        },
                    });
                },
                apiPath: itemApiPath,
                buildItemsApiUrl: () => `${itemApiPath}/images/favorites`,
                apiItemsCountPath: `${itemApiPath}/images/favorites/count`,
                isPaginated: true,
                enableBatchSelectImages: true,
                editItemLinkFor: () => ({
                    name: 'personsEdit',
                    params: { id: route.params.id },
                }),
                itemPreviewContentCallback: image =>
                    image.albums.map(album => album.name).join(', '),
                showRouteFor: (item, _model) => {
                    return {
                        name: 'personImagesShow',
                        params: {
                            person_id: route.params.id,
                            image_id: item.id,
                        },
                    };
                },
                headerExtraLinks: [
                    {
                        class: 'btn-outline-dark',
                        link: {
                            name: 'personsShow',
                            params: { id: route.params.id },
                        },
                        text: 'All images',
                    },
                ],
            };
            return props;
        },
    },
];
