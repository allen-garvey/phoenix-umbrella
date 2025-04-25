import ThumbnailList from '../components/thumbnail-list.vue';

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
            };
            const props = propsBuilder ? propsBuilder(route) : {};
            return Object.assign(defaultProps, props);
        },
    };
}
