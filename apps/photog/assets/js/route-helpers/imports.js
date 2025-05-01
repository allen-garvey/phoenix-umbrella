import { API_URL_BASE } from '../request-helpers';
import { importRelatedFields } from './related-fields.js';
import { updateItemFavorite } from './images.js';

import ThumbnailList from '../components/thumbnail-list.vue';

export function buildImportsShowVariant(path, name, props = {}) {
    return {
        path,
        name,
        component: ThumbnailList,
        props: route => {
            const defaultProps = {
                useBigThumbnails: true,
                setCoverImageCallback(cover_image_id, sendJSON, model) {
                    const importId = model.id;
                    return sendJSON(
                        `${API_URL_BASE}/imports/${importId}`,
                        'PATCH',
                        {
                            import: {
                                cover_image_id,
                            },
                        }
                    );
                },
                apiPath: route.path,
                buildItemsApiUrl: () => `${route.path}/images`,
                itemsCountKey: 'images_count',
                isPaginated: true,
                enableHasAlbumFilter: true,
                enableHasPersonFilter: true,
                enableBatchSelectImages: true,
                getDescription: importModel => importModel.notes,
                relatedFields: importRelatedFields,
                editItemLinkFor: model => ({
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
                updateItemFavorite,
            };
            return Object.assign(defaultProps, props);
        },
    };
}
