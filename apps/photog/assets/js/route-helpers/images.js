import { API_URL_BASE } from '../request-helpers';

import ThumbnailList from '../components/thumbnail-list.vue';

export const imagePreviewContentCallback = (image, getModel) =>
    getModel(`/images/${image.id}/parents`).then(image => {
        const albums = image.albums;
        const persons = image.persons;
        const messages = [];
        if (albums.length > 0) {
            messages.push(`Albums: ${albums.join(', ')}`);
        }
        if (persons.length > 0) {
            messages.push(`Persons: ${persons.join(', ')}`);
        }
        return messages.join('\n');
    });

export const updateItemFavorite = (sendJson, item) => {
    const id = item.id;

    const newValue = !item.is_favorite;
    item.is_favorite = newValue;

    const apiUrl = `${API_URL_BASE}/images/${id}`;

    return sendJson(
        apiUrl,
        'PATCH',
        {
            image: {
                id,
                is_favorite: newValue,
            },
        },
        { preserveCache: true }
    );
};

export function buildImagesIndexVariant(path, name, props = {}) {
    return {
        path,
        name,
        component: ThumbnailList,
        props: route => {
            const defaultProps = {
                showRouteFor: (item, _model) => {
                    return {
                        name: 'imagesShow',
                        params: {
                            id: item.id,
                        },
                    };
                },
                updateItemFavorite,
                itemPreviewContentCallback: imagePreviewContentCallback,
            };
            return Object.assign(defaultProps, props);
        },
    };
}
