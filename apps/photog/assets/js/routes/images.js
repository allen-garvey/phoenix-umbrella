import {
    getApiPathForTodaysImages,
    todaysImagesTitle,
} from '../route-helpers/on-this-day.js';
import {
    buildImagesIndexVariant,
    updateItemFavorite,
} from '../route-helpers/images.js';
import { imageListRelatedFields } from '../route-helpers/related-fields.js';

import { getCurrentYear } from '../date-helpers';

import ThumbnailList from '../components/thumbnail-list.vue';
import ListPage from '../components/list-page.vue';
import ImagesSearch from '../components/images-search.vue';
import ImageDetail from '../components/image-detail.vue';

export default () => [
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
                updateItemFavorite,
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
                updateItemFavorite,
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
                updateItemFavorite,
            };

            return props;
        },
    },
    buildImagesIndexVariant('/images/favorites', 'imageFavoritesIndex', {
        apiPath: '/images/?favorites=true',
        apiItemsCountPath: '/images/count/?favorites=true',
        isPaginated: true,
        enableBatchSelectImages: true,
        pageTitle: 'Favorite images',
        itemPreviewContentCallback: image => {
            const albums = image.albums.map(album => album.name).join(', ');
            const persons = image.persons.map(person => person.name).join(', ');
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
    buildImagesIndexVariant('/images/uncategorized', 'imagesNotInAlbumIndex', {
        apiPath: '/images/?in_album=false',
        apiItemsCountPath: '/images/count/?in_album=false',
        isPaginated: true,
        enableBatchSelectImages: true,
        pageTitle: 'Images not in an album',
    }),
    buildImagesIndexVariant('/images/no-amazon', 'imageNoAmazonIndex', {
        apiPath: '/images/?amazon_photos_id=false',
        isPaginated: true,
        enableBatchSelectImages: true,
        pageTitle: 'Images with no Amazon Photos Id',
    }),
    // has to be before images show
    {
        path: '/images/search',
        name: 'imagesSearch',
        component: ImagesSearch,
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
];
