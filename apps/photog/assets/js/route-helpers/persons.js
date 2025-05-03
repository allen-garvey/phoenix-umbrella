import { API_URL_BASE } from '../request-helpers';

export const getPersonsShowApiPath = personId => `/persons/${personId}`;

export const getPersonsShowSharedProps = personId => {
    const itemApiPath = getPersonsShowApiPath(personId);

    return {
        useBigThumbnails: true,
        batchRemoveItemsCallback(image_ids, sendJSON) {
            return sendJSON(`${API_URL_BASE}${itemApiPath}/images`, 'DELETE', {
                image_ids,
            });
        },
        setCoverImageCallback(cover_image_id, sendJSON) {
            return sendJSON(`${API_URL_BASE}${itemApiPath}`, 'PATCH', {
                person: {
                    cover_image_id,
                },
            });
        },
        apiPath: itemApiPath,
        isPaginated: true,
        enableBatchSelectImages: true,
        editItemLinkFor: () => ({
            name: 'personsEdit',
            params: { id: personId },
        }),
        itemPreviewContentCallback: image =>
            image.albums.map(album => album.name).join(', '),
        showRouteFor: (item, _model) => {
            return {
                name: 'personImagesShow',
                params: {
                    person_id: personId,
                    image_id: item.id,
                },
            };
        },
    };
};

export const getPersonsIndexSharedProps = () => {
    return {
        newItemLink: { name: 'personsNew' },
        showRouteFor: (item, _model) => {
            return {
                name: 'personsShow',
                params: {
                    id: item.id,
                },
            };
        },
        updateItemFavorite(sendJson, item) {
            const id = item.id;

            const newValue = !item.is_favorite;
            item.is_favorite = newValue;

            const apiUrl = `${API_URL_BASE}/persons/${id}`;

            return sendJson(
                apiUrl,
                'PATCH',
                {
                    person: {
                        id,
                        is_favorite: newValue,
                    },
                },
                { preserveCache: true }
            );
        },
    };
};
