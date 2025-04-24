import { getCurrentYear } from './date-helpers';
import {
    buildImagesIndexVariant,
    buildImportsShowVariant,
    buildAlbumVariant,
} from './router-helpers.js';
import {
    albumRelatedFields,
    imageListRelatedFields,
    sortImagesCallback,
    sortAlbumsCallback,
    getApiPathForTodaysImages,
    todaysImagesTitle,
} from './routes-helpers';

import ThumbnailList from './components/thumbnail-list.vue';
import ImportsIndex from './components/imports-index.vue';
import ImageDetail from './components/image-detail.vue';
import AlbumForm from './components/album-form.vue';
import ClanForm from './components/clan-form.vue';
import PersonForm from './components/person-form.vue';
import TagForm from './components/tag-form.vue';
import ImportForm from './components/import-form.vue';
import Home from './components/home.vue';
import Slideshow from './components/slideshow.vue';
import ListPage from './components/list-page.vue';
import YearsListPage from './components/years-list-page.vue';
import ImagesSearch from './components/images-search.vue';

export default {
    routes: [
        {
            path: '/',
            name: 'home',
            component: Home,
        },
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
        {
            path: '/imports',
            name: 'importsIndex',
            component: ImportsIndex,
        },
        buildAlbumVariant('/albums', 'albumsIndex'),
        {
            path: '/persons',
            name: 'personsIndex',
            component: ThumbnailList,
            props: route => {
                const props = {
                    apiPath: route.path,
                    newItemLink: { name: 'personsNew' },
                    pageTitle: 'Persons',
                    showRouteFor: (item, _model) => {
                        return {
                            name: 'personsShow',
                            params: {
                                id: item.id,
                            },
                        };
                    },
                };
                return props;
            },
        },
        {
            path: '/images',
            name: 'imagesIndex',
            component: ThumbnailList,
            props: route => {
                const props = {
                    useBigThumbnails: true,
                    apiPath: route.path,
                    apiItemsCountPath: `${route.path}/count`,
                    enableBatchSelectImages: true,
                    isPaginated: true,
                    pageTitle: 'Images',
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
        {
            path: '/images-menu',
            name: 'imagesMenu',
            component: ListPage,
            props(route) {
                return {
                    title: 'Images',
                    getItems: () =>
                        Promise.resolve([
                            {
                                title: todaysImagesTitle,
                                route: { name: 'imagesForToday' },
                            },
                            {
                                title: 'All Images',
                                route: { name: 'imagesIndex' },
                            },
                            {
                                title: 'Yearly Images',
                                route: {
                                    name: 'imagesForYear',
                                    params: { year: getCurrentYear() },
                                },
                            },
                            {
                                title: 'Favorite Images',
                                route: { name: 'imageFavoritesIndex' },
                            },
                            {
                                title: 'Uncategorized Images',
                                route: { name: 'imagesNotInAlbumIndex' },
                            },
                            {
                                title: 'Search Images',
                                route: { name: 'imagesSearch' },
                            },
                        ]),
                };
            },
        },
        {
            path: '/images/years/:year',
            name: 'imagesForYear',
            component: ThumbnailList,
            props: route => {
                const year = parseInt(route.params.year);
                const previousYear = year - 1;
                const nextYear = year + 1;

                const props = {
                    useBigThumbnails: true,
                    apiPath: route.path,
                    apiItemsCountPath: `${route.path}/count`,
                    enableBatchSelectImages: true,
                    isPaginated: true,
                    pageTitle: `Images from ${route.params.year}`,
                    previousPageLink: {
                        text: `Images from ${previousYear}`,
                        link: {
                            name: 'imagesForYear',
                            params: { year: previousYear },
                        },
                    },
                    showRouteFor: (item, _model) => {
                        return {
                            name: 'imagesShow',
                            params: {
                                id: item.id,
                            },
                        };
                    },
                    slideshowRoute: {
                        name: 'imageYearSlideshow',
                        params: { year: route.params.year },
                    },
                };

                if (year < new Date().getFullYear()) {
                    props.nextPageLink = {
                        text: `Images from ${nextYear}`,
                        link: {
                            name: 'imagesForYear',
                            params: { year: nextYear },
                        },
                    };
                }

                return props;
            },
        },
        {
            path: '/images/today',
            name: 'imagesForToday',
            component: ThumbnailList,
            props: route => {
                const apiPath = getApiPathForTodaysImages();

                const props = {
                    useBigThumbnails: true,
                    apiPath,
                    apiItemsCountPath: `${apiPath}/count`,
                    enableBatchSelectImages: true,
                    isPaginated: true,
                    pageTitle: todaysImagesTitle,
                    relatedFields: imageListRelatedFields,
                    showRouteFor: (item, _model) => {
                        return {
                            name: 'todaysImagesShow',
                            params: {
                                image_id: item.id,
                            },
                        };
                    },
                };

                return props;
            },
        },
        {
            path: '/albums/years',
            name: 'albumsForYearIndex',
            component: YearsListPage,
        },
        buildAlbumVariant('/albums/favorites', 'albumFavoritesIndex', route => {
            const props = {
                apiPath: '/albums/?favorites=true',
                apiItemsCountPath: '/albums/count?favorites=true',
                pageTitle: 'Favorite Albums',
            };

            return props;
        }),
        buildAlbumVariant('/albums/years/:year', 'albumsForYear', route => {
            const year = parseInt(route.params.year);
            const previousYear = year - 1;
            const nextYear = year + 1;

            const props = {
                pageTitle: `Albums from ${route.params.year}`,
                previousPageLink: {
                    text: `Albums from ${previousYear}`,
                    link: {
                        name: 'albumsForYear',
                        params: { year: previousYear },
                    },
                },
                slideshowRoute: {
                    name: 'imageYearSlideshow',
                    params: { year: route.params.year },
                },
            };

            if (year < new Date().getFullYear()) {
                props.nextPageLink = {
                    text: `Albums from ${nextYear}`,
                    link: { name: 'albumsForYear', params: { year: nextYear } },
                };
            }

            return props;
        }),
        buildImagesIndexVariant('/images/favorites', 'imageFavoritesIndex', {
            apiPath: '/images/?favorites=true',
            apiItemsCountPath: '/images/count/?favorites=true',
            isPaginated: true,
            enableBatchSelectImages: true,
            pageTitle: 'Favorite images',
            itemPreviewContentCallback: image => {
                const albums = image.albums.map(album => album.name).join(', ');
                const persons = image.persons
                    .map(person => person.name)
                    .join(', ');
                const messages = [];
                if (albums) {
                    messages.push(`Albums: ${albums}`);
                }
                if (persons) {
                    messages.push(`Persons: ${persons}`);
                }
                return messages.join('\n');
            },
        }),
        buildImagesIndexVariant(
            '/images/uncategorized',
            'imagesNotInAlbumIndex',
            {
                apiPath: '/images/?in_album=false',
                apiItemsCountPath: '/images/count/?in_album=false',
                isPaginated: true,
                enableBatchSelectImages: true,
                pageTitle: 'Images not in an album',
            }
        ),
        buildImagesIndexVariant('/images/no-amazon', 'imageNoAmazonIndex', {
            apiPath: '/images/?amazon_photos_id=false',
            isPaginated: true,
            enableBatchSelectImages: true,
            pageTitle: 'Images with no Amazon Photos Id',
        }),
        //new route has to be before show route
        {
            path: '/albums/new',
            name: 'albumsNew',
            component: AlbumForm,
        },
        {
            path: '/albums/:id/edit',
            name: 'albumsEdit',
            component: AlbumForm,
            props: route => {
                return {
                    modelId: parseInt(route.params.id),
                };
            },
        },
        {
            path: '/albums/:id',
            name: 'albumsShow',
            component: ThumbnailList,
            props: route => {
                const props = {
                    useBigThumbnails: true,
                    batchRemoveItemsCallback(image_ids, sendJSON) {
                        const albumId = route.params.id;
                        return sendJSON(
                            `/api/albums/${albumId}/images`,
                            'DELETE',
                            { image_ids }
                        );
                    },
                    setCoverImageCallback(cover_image_id, sendJSON) {
                        const albumId = route.params.id;
                        return sendJSON(`/api/albums/${albumId}`, 'PATCH', {
                            album: {
                                cover_image_id,
                            },
                        });
                    },
                    apiPath: route.path,
                    buildItemsApiUrl: () => `${route.path}/images`,
                    itemsCountKey: 'images_count',
                    isPaginated: true,
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
                    editItemLinkFor: () => ({
                        name: 'albumsEdit',
                        params: { id: route.params.id },
                    }),
                    isDeleteEnabled: true,
                    reorderPathSuffix: '/images/reorder',
                    reorderItemsKey: 'image_ids',
                    reorderBySortCallback: sortImagesCallback,
                    relatedFields: albumRelatedFields,
                    getDescription: album => album.description,
                    itemPreviewContentCallback: image =>
                        image.persons.map(person => person.name).join(', '),
                    showRouteFor: (item, _model) => {
                        return {
                            name: 'albumImagesShow',
                            params: {
                                album_id: route.params.id,
                                image_id: item.id,
                            },
                        };
                    },
                    slideshowRoute: {
                        name: 'albumSlideshow',
                        params: { album_id: route.params.id },
                    },
                };
                return props;
            },
        },
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
        //new route has to be before show route
        {
            path: '/persons/new',
            name: 'personsNew',
            component: PersonForm,
        },
        {
            path: '/persons/:id/edit',
            name: 'personsEdit',
            component: PersonForm,
            props: route => {
                return {
                    modelId: parseInt(route.params.id),
                };
            },
        },
        {
            path: '/persons/:id',
            name: 'personsShow',
            component: ThumbnailList,
            props: route => {
                const props = {
                    useBigThumbnails: true,
                    batchRemoveItemsCallback(image_ids, sendJSON) {
                        const personId = route.params.id;
                        return sendJSON(
                            `/api/persons/${personId}/images`,
                            'DELETE',
                            { image_ids }
                        );
                    },
                    setCoverImageCallback(cover_image_id, sendJSON) {
                        const personId = route.params.id;
                        return sendJSON(`/api/persons/${personId}`, 'PATCH', {
                            person: {
                                cover_image_id,
                            },
                        });
                    },
                    apiPath: route.path,
                    buildItemsApiUrl: () => `${route.path}/images`,
                    itemsCountKey: 'images_count',
                    isPaginated: true,
                    enableHasAlbumFilter: true,
                    enableBatchSelectImages: true,
                    editItemLinkFor: () => ({
                        name: 'personsEdit',
                        params: { id: route.params.id },
                    }),
                    isDeleteEnabled: true,
                    itemPreviewContentCallback: image =>
                        image.albums.map(album => album.name).join(', '),
                    showRouteFor: (item, _model) => {
                        return {
                            name: 'personImagesShow',
                            params: {
                                person_id: route.params.id,
                                image_id: item.id,
                            },
                        };
                    },
                    headerExtraLinks: [
                        {
                            class: 'btn-outline-dark',
                            link: {
                                name: 'personsShowFavorites',
                                params: { id: route.params.id },
                            },
                            text: 'Favorites',
                        },
                    ],
                };
                return props;
            },
        },
        {
            path: '/persons/:id/favorites',
            name: 'personsShowFavorites',
            component: ThumbnailList,
            props: route => {
                const itemApiPath = `/persons/${route.params.id}`;

                const props = {
                    useBigThumbnails: true,
                    batchRemoveItemsCallback(image_ids, sendJSON) {
                        const personId = route.params.id;
                        return sendJSON(
                            `/api/persons/${personId}/images`,
                            'DELETE',
                            { image_ids }
                        );
                    },
                    setCoverImageCallback(cover_image_id, sendJSON) {
                        const personId = route.params.id;
                        return sendJSON(`/api/persons/${personId}`, 'PATCH', {
                            person: {
                                cover_image_id,
                            },
                        });
                    },
                    apiPath: itemApiPath,
                    buildItemsApiUrl: () => `${itemApiPath}/images/favorites`,
                    apiItemsCountPath: `${itemApiPath}/images/favorites/count`,
                    isPaginated: true,
                    enableBatchSelectImages: true,
                    editItemLinkFor: () => ({
                        name: 'personsEdit',
                        params: { id: route.params.id },
                    }),
                    itemPreviewContentCallback: image =>
                        image.albums.map(album => album.name).join(', '),
                    showRouteFor: (item, _model) => {
                        return {
                            name: 'personImagesShow',
                            params: {
                                person_id: route.params.id,
                                image_id: item.id,
                            },
                        };
                    },
                    headerExtraLinks: [
                        {
                            class: 'btn-outline-dark',
                            link: {
                                name: 'personsShow',
                                params: { id: route.params.id },
                            },
                            text: 'All images',
                        },
                    ],
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
                        return sendJSON(`/api/tags/${tagId}`, 'PATCH', {
                            tag: {
                                cover_album_id,
                            },
                        });
                    },
                    batchRemoveItemsCallback(album_ids, sendJSON) {
                        const tagId = route.params.id;
                        return sendJSON(`/api/tags/${tagId}/albums`, 'DELETE', {
                            album_ids,
                        });
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
                };
                return props;
            },
        },
        //has to be before importsShow route
        {
            path: '/images/search',
            name: 'imagesSearch',
            component: ImagesSearch,
        },
        buildImportsShowVariant('/imports/last', 'importsShowLast', {
            buildItemsApiUrl: model => `/imports/${model.id}/images`,
        }),
        buildImportsShowVariant('/imports/:id', 'importsShow'),
        {
            path: '/imports/:id/edit',
            name: 'importsEdit',
            component: ImportForm,
            props: route => {
                return {
                    modelId: parseInt(route.params.id),
                };
            },
        },
        {
            path: '/images/:id',
            name: 'imagesShow',
            component: ImageDetail,
            props: route => {
                return {
                    imageId: parseInt(route.params.id),
                };
            },
        },
        {
            path: '/albums/:album_id/images/:image_id',
            name: 'albumImagesShow',
            component: ImageDetail,
            props: route => {
                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.album_id,
                        getName(image) {
                            return image.albums.find(
                                album => album.id == route.params.album_id
                            ).name;
                        },
                        parentRouteName: 'albumsShow',
                        imagesApiPath: `/albums/${route.params.album_id}/images?excerpt=true`,
                        showRouteFor: item => {
                            return {
                                name: 'albumImagesShow',
                                params: {
                                    album_id: route.params.album_id,
                                    image_id: item.id,
                                },
                            };
                        },
                        getSlideshowRoute(imageIndex) {
                            return {
                                name: 'albumSlideshow',
                                hash: `#${imageIndex}`,
                                params: { album_id: route.params.album_id },
                            };
                        },
                    },
                };
            },
        },
        {
            path: '/persons/:person_id/images/:image_id',
            name: 'personImagesShow',
            component: ImageDetail,
            props: route => {
                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.person_id,
                        getName(image) {
                            return image.persons.find(
                                person => person.id == route.params.person_id
                            ).name;
                        },
                        imagesApiPath: `/persons/${route.params.person_id}/images?excerpt=true`,
                        parentRouteName: 'personsShow',
                        showRouteFor: item => {
                            return {
                                name: 'personImagesShow',
                                params: {
                                    person_id: route.params.person_id,
                                    image_id: item.id,
                                },
                            };
                        },
                    },
                };
            },
        },
        {
            path: '/imports/:import_id/images/:image_id',
            name: 'importImagesShow',
            component: ImageDetail,
            props: route => {
                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.import_id,
                        name: 'Import',
                        imagesApiPath: `/imports/${route.params.import_id}/images?excerpt=true`,
                        parentRouteName: 'importsShow',
                        showRouteFor: item => {
                            return {
                                name: 'importImagesShow',
                                params: {
                                    import_id: route.params.import_id,
                                    image_id: item.id,
                                },
                            };
                        },
                    },
                };
            },
        },
        {
            path: '/images/today/images/:image_id',
            name: 'todaysImagesShow',
            component: ImageDetail,
            props: route => {
                const apiPath = getApiPathForTodaysImages();

                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.album_id,
                        name: todaysImagesTitle,
                        parentRouteName: 'imagesForToday',
                        imagesApiPath: apiPath,
                        showRouteFor: item => {
                            return {
                                name: 'todaysImagesShow',
                                params: {
                                    image_id: item.id,
                                },
                            };
                        },
                    },
                };
            },
        },
        {
            path: '/slideshows/albums/:album_id',
            name: 'albumSlideshow',
            component: Slideshow,
            props: route => {
                return {
                    apiPath: `/albums/${route.params.album_id}/images?excerpt=true`,
                    getImageShowRoute(image) {
                        return {
                            name: 'albumImagesShow',
                            params: {
                                album_id: route.params.album_id,
                                image_id: image.id,
                            },
                        };
                    },
                    parentRoute: {
                        name: 'albumsShow',
                        params: { id: route.params.album_id },
                    },
                    parentName: 'Album',
                };
            },
        },
        {
            path: '/slideshows/tags/:tag_id',
            name: 'tagSlideshow',
            component: Slideshow,
            props: route => {
                return {
                    apiPath: `/tags/${route.params.tag_id}/images?excerpt=true`,
                    getImageShowRoute(image) {
                        return {
                            name: 'imagesShow',
                            params: {
                                id: image.id,
                            },
                        };
                    },
                    parentRoute: {
                        name: 'tagsShow',
                        params: { id: route.params.tag_id },
                    },
                    parentName: 'Tag',
                };
            },
        },
        {
            path: '/slideshows/images/years/:year',
            name: 'imageYearSlideshow',
            component: Slideshow,
            props: route => {
                return {
                    apiPath: `/images/years/${route.params.year}/?excerpt=true`,
                    getImageShowRoute(image) {
                        return {
                            name: 'imagesShow',
                            params: {
                                id: image.id,
                            },
                        };
                    },
                    parentRoute: {
                        name: 'albumsForYear',
                        params: { year: route.params.year },
                    },
                    parentName: 'Albums',
                };
            },
        },
    ],
};
