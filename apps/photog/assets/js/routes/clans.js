import ClanForm from '../components/clan-form.vue';
import ListPage from '../components/list-page.vue';
import ThumbnailList from '../components/thumbnail-list.vue';

export default () => [
    {
        path: '/clans',
        name: 'clansIndex',
        component: ListPage,
        props(route) {
            return {
                title: 'Clans',
                headerButton: {
                    title: 'New',
                    className: 'btn-success',
                    route: { name: 'clansNew' },
                },
                getItems: getModel =>
                    getModel('/clans').then(clans =>
                        clans.map(clan => ({
                            title: clan.name,
                            id: clan.id,
                            route: {
                                name: 'clansShow',
                                params: { id: clan.id },
                            },
                        }))
                    ),
            };
        },
    },
    //new route has to be before show route
    {
        path: '/clans/new',
        name: 'clansNew',
        component: ClanForm,
    },
    {
        path: '/clans/:id/edit',
        name: 'clansEdit',
        component: ClanForm,
        props: route => {
            return {
                modelId: parseInt(route.params.id),
            };
        },
    },
    {
        path: '/clans/:id',
        name: 'clansShow',
        component: ThumbnailList,
        props: route => {
            const props = {
                useBigThumbnails: true,
                apiPath: route.path,
                buildItemsApiUrl: () => `${route.path}/images`,
                itemsCountKey: 'images_count',
                isPaginated: true,
                enableHasAlbumFilter: true,
                editItemLinkFor: () => ({
                    name: 'clansEdit',
                    params: { id: route.params.id },
                }),
                isUnsafeDeleteEnabled: true,
                showRouteFor: (item, _model) => {
                    return {
                        name: 'imagesShow',
                        params: {
                            id: item.id,
                        },
                    };
                },
            };
            return props;
        },
    },
];
