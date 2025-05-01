import { API_URL_BASE } from '../request-helpers';

import ThumbnailList from '../components/thumbnail-list.vue';

export const updateItemFavorite = (sendJson, item) => {
    const id = item.id;

    const newValue = !item.is_favorite;
    item.is_favorite = newValue;

    const apiUrl = `${API_URL_BASE}/albums/${id}`;

    return sendJson(
        apiUrl,
        'PATCH',
        {
            album: {
                id,
                is_favorite: newValue,
            },
        },
        { preserveCache: true }
    );
};

export function buildAlbumVariant(path, name, propsBuilder = null) {
    return {
        path,
        name,
        component: ThumbnailList,
        props: route => {
            const defaultProps = {
                apiPath: route.path,
                apiItemsCountPath: `${route.path}/count`,
                enableBatchSelectAlbums: true,
                isPaginated: true,
                newItemLink: { name: 'albumsNew' },
                pageTitle: 'Albums',
                itemPreviewContentCallback: album =>
                    album.tags.map(tag => tag.name).join(', '),
                showRouteFor: (item, _model) => {
                    return {
                        name: 'albumsShow',
                        params: {
                            id: item.id,
                        },
                    };
                },
                updateItemFavorite,
            };
            const props = propsBuilder ? propsBuilder(route) : {};
            return Object.assign(defaultProps, props);
        },
    };
}
