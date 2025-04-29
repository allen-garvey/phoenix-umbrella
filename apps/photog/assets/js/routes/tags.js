import { sortAlbumsCallback } from '../route-helpers/sorting.js';
import { API_URL_BASE } from '../request-helpers.js';

import ThumbnailList from '../components/thumbnail-list.vue';
import TagForm from '../components/tag-form.vue';

export default () => [
    {
        path: '/tags',
        name: 'tagsIndex',
        component: ThumbnailList,
        props: route => {
            const props = {
                apiPath: route.path,
                newItemLink: { name: 'tagsNew' },
                pageTitle: 'Tags',
                showRouteFor: (item, _model) => {
                    return {
                        name: 'tagsShow',
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
        path: '/tags/new',
        name: 'tagsNew',
        component: TagForm,
        props: route => {
            return {};
        },
    },
    {
        path: '/tags/:id/edit',
        name: 'tagsEdit',
        component: TagForm,
        props: route => {
            return {
                modelId: parseInt(route.params.id),
                itemsUrl: `/tags/${route.params.id}/albums?excerpt=true`,
            };
        },
    },
    {
        path: '/tags/:id',
        name: 'tagsShow',
        component: ThumbnailList,
        props: route => {
            const props = {
                setCoverImageCallback(cover_album_id, sendJSON, tag) {
                    const tagId = tag.id;
                    return sendJSON(`/api/tags/${tagId}`, 'PATCH', {
                        tag: {
                            cover_album_id,
                        },
                    });
                },
                batchRemoveItemsCallback(album_ids, sendJSON) {
                    const tagId = route.params.id;
                    return sendJSON(`/api/tags/${tagId}/albums`, 'DELETE', {
                        album_ids,
                    });
                },
                apiPath: route.path,
                buildItemsApiUrl: () => `${route.path}/albums`,
                itemsCountKey: 'albums_count',
                isPaginated: true,
                enableBatchSelectAlbums: true,
                editItemLinkFor: () => ({
                    name: 'tagsEdit',
                    params: { id: route.params.id },
                }),
                isDeleteEnabled: true,
                reorderPathSuffix: '/albums/reorder',
                reorderItemsKey: 'album_ids',
                reorderBySortCallback: sortAlbumsCallback,
                showRouteFor: item => {
                    return {
                        name: 'albumsShow',
                        params: {
                            id: item.id,
                        },
                    };
                },
                slideshowRoute: {
                    name: 'tagSlideshow',
                    params: { tag_id: route.params.id },
                },
                updateItemFavorite(sendJson, item) {
                    const id = item.id;

                    const newValue = !item.is_favorite;
                    item.is_favorite = newValue;

                    const apiUrl = `${API_URL_BASE}/albums/${id}`;

                    return sendJson(apiUrl, 'PATCH', {
                        album: {
                            id,
                            is_favorite: newValue,
                        },
                    });
                },
            };

            return props;
        },
    },
];
