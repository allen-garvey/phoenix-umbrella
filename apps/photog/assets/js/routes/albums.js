import { buildAlbumVariant } from '../route-helpers/albums.js';
import { albumRelatedFields } from '../route-helpers/related-fields.js';
import { sortImagesCallback } from '../route-helpers/sorting.js';

import AlbumForm from '../components/album-form.vue';
import YearsListPage from '../components/years-list-page.vue';
import ThumbnailList from '../components/thumbnail-list.vue';

export default () => [
    buildAlbumVariant('/albums', 'albumsIndex'),
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
                    return sendJSON(`/api/albums/${albumId}/images`, 'DELETE', {
                        image_ids,
                    });
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
];
