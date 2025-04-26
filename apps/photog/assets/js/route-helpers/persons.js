export const getPersonsShowApiPath = personId => `/persons/${personId}`;

export const getPersonsShowSharedProps = personId => {
    const itemApiPath = getPersonsShowApiPath(personId);

    return {
        useBigThumbnails: true,
        batchRemoveItemsCallback(image_ids, sendJSON) {
            return sendJSON(`/api${itemApiPath}/images`, 'DELETE', {
                image_ids,
            });
        },
        setCoverImageCallback(cover_image_id, sendJSON) {
            return sendJSON(`/api${itemApiPath}`, 'PATCH', {
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
