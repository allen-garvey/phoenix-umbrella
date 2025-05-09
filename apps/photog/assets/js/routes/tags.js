import { API_URL_BASE } from '../request-helpers';
import { sortAlbumsCallback } from '../route-helpers/sorting.js';
import { updateItemFavorite } from '../route-helpers/albums.js';

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
                    return sendJSON(`${API_URL_BASE}/tags/${tagId}`, 'PATCH', {
                        tag: {
                            cover_album_id,
                        },
                    });
                },
                batchRemoveItemsCallback(album_ids, sendJSON) {
                    const tagId = route.params.id;
                    return sendJSON(
                        `${API_URL_BASE}/tags/${tagId}/albums`,
                        'DELETE',
                        {
                            album_ids,
                        }
                    );
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
                updateItemFavorite,
            };

            return props;
        },
    },
];
