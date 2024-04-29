import { importRelatedFields } from './routes-helpers';

import ThumbnailList from './components/thumbnail-list.vue';

export function buildImagesIndexVariant(path, name, props = {}) {
    return {
        path,
        name,
        component: ThumbnailList,
        props: (route) => {
            const defaultProps = {
                showRouteFor: (item, _model) => {
                    return {
                        name: 'imagesShow',
                        params: {
                            id: item.id,
                            image_id: item.id,
                        },
                    };
                },
            };
            return Object.assign(defaultProps, props);
        },
    };
}

export function buildImportsShowVariant(path, name, props = {}) {
    return {
        path,
        name,
        component: ThumbnailList,
        props: (route) => {
            const defaultProps = {
                setCoverImageCallback(cover_image_id, sendJSON) {
                    const importId = route.params.id;
                    return sendJSON(`/api/imports/${importId}`, 'PATCH', {
                        import: {
                            cover_image_id,
                        },
                    });
                },
                apiPath: route.path,
                buildItemsApiUrl: () => `${route.path}/images`,
                itemsCountKey: 'images_count',
                isPaginated: true,
                enableHasAlbumFilter: true,
                enableHasPersonFilter: true,
                enableBatchSelectImages: true,
                getDescription: (importModel) => importModel.notes,
                relatedFields: importRelatedFields,
                editItemLinkFor: (model) => ({
                    name: 'importsEdit',
                    params: { id: model.id },
                }),
                showRouteFor: (item, model) => {
                    return {
                        name: 'importImagesShow',
                        params: {
                            import_id: model.id,
                            image_id: item.id,
                        },
                    };
                },
            };
            return Object.assign(defaultProps, props);
        },
    };
}

export function buildAlbumVariant(path, name, propsBuilder = null) {
    return {
        path,
        name,
        component: ThumbnailList,
        props: (route) => {
            const defaultProps = {
                apiPath: route.path,
                apiItemsCountPath: `${route.path}/count`,
                enableBatchSelectAlbums: true,
                isPaginated: true,
                newItemLink: { name: 'albumsNew' },
                pageTitle: 'Albums',
                itemPreviewContentCallback: (album) =>
                    album.tags.map((tag) => tag.name).join(', '),
                showRouteFor: (item, _model) => {
                    return {
                        name: 'albumsShow',
                        params: {
                            id: item.id,
                        },
                    };
                },
            };
            const props = propsBuilder ? propsBuilder(route) : {};
            return Object.assign(defaultProps, props);
        },
    };
}
