import ThumbnailList from '../components/thumbnail-list.vue';

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
                            image_id: item.id,
                        },
                    };
                },
            };
            return Object.assign(defaultProps, props);
        },
    };
}
