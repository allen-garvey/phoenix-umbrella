import { getOptionalParams, buildImagesIndexVariant, buildImportsShowVariant } from './router-helpers.js';
import { getPersonsInAlbum, sortImagesCallback, sortAlbumsCallback } from './routes-helpers';

import ThumbnailList from './components/thumbnail-list.vue';
import ImportsIndex from './components/imports-index.vue';
import ImageDetail from './components/image-detail.vue'
import AlbumForm from './components/album-form.vue';
import PersonForm from './components/person-form.vue';
import TagForm from './components/tag-form.vue';
import ImportForm from './components/import-form.vue';
import Home from './components/home.vue';
import ImagesMenu from './components/images-menu.vue';
import Slideshow from './components/slideshow.vue';

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
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    newItemLink: {name: 'tagsNew'},
                    pageTitle: 'Tags',
                    showRouteFor: (item, _model)=>{
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
        { 
            path: '/albums',
            name: 'albumsIndex', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    apiItemsCountPath: `${route.path}/count`,
                    enableBatchSelectAlbums: true,
                    isPaginated: true,
                    newItemLink: {name: 'albumsNew'},
                    pageTitle: 'Albums',
                    itemPreviewContentCallback: (album) => album.tags.map(tag => tag.name).join(', '),
                    showRouteFor: (item, _model)=>{
                        return {
                            name: 'albumsShow',
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
            path: '/persons',
            name: 'personsIndex', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    newItemLink: {name: 'personsNew'},
                    pageTitle: 'Persons',
                    showRouteFor: (item, _model)=>{
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
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    apiItemsCountPath: `${route.path}/count`,
                    enableBatchSelectImages: true,
                    isPaginated: true,
                    pageTitle: 'Images',
                    showRouteFor: (item, _model)=>{
                        return {
                            name: 'imagesShow',
                            params: {
                                id: item.id,
                                image_id: item.id,
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
            component: ImagesMenu,
        },
        { 
            path: '/images/years/:year',
            name: 'imagesForYear', 
            component: ThumbnailList,
            props: (route) => {
                const year = parseInt(route.params.year);
                const previousYear = year - 1;
                const nextYear = year + 1;

                const props = {
                    apiPath: route.path,
                    apiItemsCountPath: `${route.path}/count`,
                    enableBatchSelectImages: true,
                    isPaginated: true,
                    pageTitle: `Images from ${route.params.year}`,
                    previousPageLink: {
                        text: `Images from ${previousYear}`,
                        link: {name: 'imagesForYear', params: {year: previousYear}},
                    },
                    showRouteFor: (item, _model)=>{
                        return {
                            name: 'imagesShow',
                            params: {
                                id: item.id,
                                image_id: item.id,
                            },
                        };
                    },
                    slideshowRoute: {
                        name: 'imageYearSlideshow', 
                        params: { year: route.params.year }
                    },
                };

                if(year < (new Date).getFullYear()){
                    props.nextPageLink = {
                        text: `Images from ${nextYear}`,
                        link: {name: 'imagesForYear', params: {year: nextYear}},
                    };
                }

                return props;
            },
        },
        { 
            path: '/albums/years/:year',
            name: 'albumsForYear', 
            component: ThumbnailList,
            props: (route) => {
                const year = parseInt(route.params.year);
                const previousYear = year - 1;
                const nextYear = year + 1;

                const props = {
                    apiPath: route.path,
                    apiItemsCountPath: `${route.path}/count`,
                    enableBatchSelectAlbums: true,
                    isPaginated: true,
                    newItemLink: {name: 'albumsNew'},
                    pageTitle: `Albums from ${route.params.year}`,
                    previousPageLink: {
                        text: `Albums from ${previousYear}`,
                        link: {name: 'albumsForYear', params: {year: previousYear}},
                    },
                    itemPreviewContentCallback: (album) => album.tags.map(tag => tag.name).join(', '),
                    showRouteFor: (item, _model)=>{
                        return {
                            name: 'albumsShow',
                            params: {
                                id: item.id,
                                album_id: item.id,
                            },
                        };
                    },
                    slideshowRoute: {
                        name: 'imageYearSlideshow', 
                        params: { year: route.params.year }
                    },
                };

                if(year < (new Date).getFullYear()){
                    props.nextPageLink = {
                        text: `Albums from ${nextYear}`,
                        link: {name: 'albumsForYear', params: {year: nextYear}},
                    };
                }

                return props;
            },
        },
        buildImagesIndexVariant(
            '/images/favorites',
            'imageFavoritesIndex',
            {
                apiPath: '/images/?favorites=true',
                apiItemsCountPath: '/images/count/?favorites=true',
                isPaginated: true,
                enableBatchSelectImages: true,
                pageTitle: 'Favorite images',
                itemPreviewContentCallback: (image) => {
                    const albums = image.albums.map(album => album.name).join(', ');
                    const persons = image.persons.map(person => person.name).join(', ');
                    const messages = [];
                    if(albums){
                        messages.push(`Albums: ${albums}`);
                    }
                    if(persons){
                        messages.push(`Persons: ${persons}`);
                    }
                    return messages.join('\n');
                },
            }
        ),
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
        buildImagesIndexVariant(
            '/images/no-amazon',
            'imageNoAmazonIndex',
            {
                apiPath: '/images/?amazon_photos_id=false',
                isPaginated: true,
                enableBatchSelectImages: true,
                pageTitle: 'Images with no Amazon Photos Id',
            }
        ),
        //new route has to be before show route
        { 
            path: '/albums/new',
            name: 'albumsNew', 
            component: AlbumForm,
            props: (route) => {
                return getOptionalParams(route.params, ['images', 'successRedirect']);
            },
        },
        { 
            path: '/albums/:id/edit',
            name: 'albumsEdit', 
            component: AlbumForm,
            props: (route) => {
                return {
                    modelId: parseInt(route.params.id),
                    itemsUrl: `/albums/${route.params.id}/images?excerpt=true`,
                }; 
            },
        },
        { 
            path: '/albums/:id',
            name: 'albumsShow', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    batchRemoveItemsCallback(image_ids, sendJSON){
                        const albumId = route.params.id;
                        return sendJSON(`/api/albums/${albumId}/images`, 'DELETE', {image_ids});
                    },
                    apiPath: route.path,
                    buildItemsApiUrl: () => `${route.path}/images`,
                    itemsCountKey: 'images_count',
                    isPaginated: true,
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
                    editItemLinkFor: () => ({name: 'albumsEdit', params: {id: route.params.id}}),
                    isDeleteEnabled: true,
                    reorderPathSuffix: '/images/reorder',
                    reorderItemsKey: 'image_ids',
                    reorderBySortCallback: sortImagesCallback,
                    relatedFieldsKey: 'tags',
                    computedRelatedFieldsCallback: getPersonsInAlbum,
                    computedRelatedFieldsKey: 'persons',
                    getDescription: (album) => album.description,
                    itemPreviewContentCallback: (image) => image.persons.map(person => person.name).join(', '),
                    showRouteFor: (item, _model)=>{
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
                        params: { album_id: route.params.id }
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
            props: (route) => {
                return getOptionalParams(route.params, ['images', 'successRedirect']);
            },
        },
        { 
            path: '/persons/:id/edit',
            name: 'personsEdit', 
            component: PersonForm,
            props: (route) => {
                return {
                    modelId: parseInt(route.params.id),
                    itemsUrl: `/persons/${route.params.id}/images?excerpt=true`,
                }; 
            },
        },
        { 
            path: '/persons/:id',
            name: 'personsShow', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    buildItemsApiUrl: () => `${route.path}/images`,
                    itemsCountKey: 'images_count',
                    isPaginated: true,
                    enableHasAlbumFilter: true,
                    enableBatchSelectImages: true,
                    editItemLinkFor: () => ({name: 'personsEdit', params: {id: route.params.id}}),
                    isDeleteEnabled: true,
                    itemPreviewContentCallback: (image) => image.albums.map(album => album.name).join(', '),
                    showRouteFor: (item, _model)=>{
                        return {
                            name: 'personImagesShow',
                            params: {
                                person_id: route.params.id,
                                image_id: item.id,
                            },
                        };
                    },
                }; 
                return props;
            },
        },
        //new route has to be before show route
        { 
            path: '/tags/new',
            name: 'tagsNew', 
            component: TagForm,
            props: (route) => {
                return {
                }; 
            },
        },
        { 
            path: '/tags/:id/edit',
            name: 'tagsEdit', 
            component: TagForm,
            props: (route) => {
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
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    buildItemsApiUrl: () => `${route.path}/albums`,
                    itemsCountKey: 'albums_count',
                    isPaginated: true,
                    enableBatchSelectAlbums: true,
                    editItemLinkFor: () => ({name: 'tagsEdit', params: {id: route.params.id}}),
                    isDeleteEnabled: true,
                    reorderPathSuffix: '/albums/reorder',
                    reorderItemsKey: 'album_ids',
                    reorderBySortCallback: sortAlbumsCallback,
                    showRouteFor: (item)=>{
                        return {
                            name: 'albumsShow',
                            params: {
                                id: item.id,
                            },
                        };
                    },
                    slideshowRoute: {
                        name: 'tagSlideshow', 
                        params: { tag_id: route.params.id }
                    },
                }; 
                return props;
            },
        },
        //has to be before importsShow route
        buildImportsShowVariant('/imports/last', 'importsShowLast', {
            buildItemsApiUrl: (model) => `/imports/${model.id}/images`,
        }),
        buildImportsShowVariant('/imports/:id', 'importsShow'),
        { 
            path: '/imports/:id/edit',
            name: 'importsEdit', 
            component: ImportForm,
            props: (route) => {
                return {
                    modelId: parseInt(route.params.id),
                }; 
            },
        },
        { 
            path: '/images/:id',
            name: 'imagesShow', 
            component: ImageDetail,
            props: (route) => {
                return {
                    imageId: parseInt(route.params.id),
                }; 
            },
        },
        { 
            path: '/albums/:album_id/images/:image_id',
            name: 'albumImagesShow', 
            component: ImageDetail,
            props: (route) => {
                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.album_id,
                        getName(image){
                            for(let i=0;i<image.albums.length;i++){
                                const album = image.albums[i];
                                if(album.id == route.params.album_id){
                                    return album.name;
                                }
                            }
                        },
                        parentRouteName: 'albumsShow',
                        imagesApiPath: `/albums/${route.params.album_id}/images?excerpt=true`,
                        showRouteFor: (item)=>{
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
                                params: { album_id: route.params.album_id }
                            }
                        }
                    },
                }; 
            },
        },
        { 
            path: '/persons/:person_id/images/:image_id',
            name: 'personImagesShow', 
            component: ImageDetail,
            props: (route) => {
                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.person_id,
                        getName(image){
                            for(let i=0;i<image.persons.length;i++){
                                const person = image.persons[i];
                                if(person.id == route.params.person_id){
                                    return person.name;
                                }
                            }
                        },
                        imagesApiPath: `/persons/${route.params.person_id}/images?excerpt=true`,
                        parentRouteName: 'personsShow',
                        showRouteFor: (item)=>{
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
            props: (route) => {
                return {
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        id: route.params.import_id,
                        name: 'Import',
                        imagesApiPath: `/imports/${route.params.import_id}/images?excerpt=true`,
                        parentRouteName: 'importsShow',
                        showRouteFor: (item)=>{
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
            path: '/slideshows/albums/:album_id',
            name: 'albumSlideshow', 
            component: Slideshow,
            props: (route) => {
                return {
                    apiPath: `/albums/${route.params.album_id}/images?excerpt=true`,
                    getImageShowRoute(image){
                        return {
                            name: 'albumImagesShow',
                                params: {
                                    album_id: route.params.album_id,
                                    image_id: image.id,
                                },
                        };
                    },
                    parentRoute: {name: 'albumsShow', params: {id: route.params.album_id}},
                    parentName: 'Album',
                }; 
            },
        },
        { 
            path: '/slideshows/tags/:tag_id',
            name: 'tagSlideshow', 
            component: Slideshow,
            props: (route) => {
                return {
                    apiPath: `/tags/${route.params.tag_id}/images?excerpt=true`,
                    getImageShowRoute(image){
                        return {
                            name: 'imagesShow',
                                params: {
                                    id: image.id,
                                },
                        };
                    },
                    parentRoute: {name: 'tagsShow', params: {id: route.params.tag_id}},
                    parentName: 'Tag',
                }; 
            },
        },
        { 
            path: '/slideshows/images/years/:year',
            name: 'imageYearSlideshow', 
            component: Slideshow,
            props: (route) => {
                return {
                    apiPath: `/images/years/${route.params.year}/?excerpt=true`,
                    getImageShowRoute(image){
                        return {
                            name: 'imagesShow',
                                params: {
                                    id: image.id,
                                },
                        };
                    },
                    parentRoute: {name: 'albumsForYear', params: {year: route.params.year}},
                    parentName: 'Albums',
                }; 
            },
        },
    ],
};