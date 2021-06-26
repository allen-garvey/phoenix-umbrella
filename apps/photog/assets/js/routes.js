import { getOptionalParams, buildImagesIndexVariant } from './router-helpers.js'; 

import ThumbnailList from './components/thumbnail-list.vue';
import ImportsIndex from './components/imports-index.vue';
import ImageDetail from './components/image-detail.vue'
import AlbumForm from './components/album-form.vue';
import PersonForm from './components/person-form.vue';
import TagForm from './components/tag-form.vue';

export default {
    routes: [
        { 
            path: '/', 
            name: 'home',
            redirect: '/albums' 
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
                    enableBatchSelectAlbums: true,
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
                    enableHasAlbumFilter: true,
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
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
            path: '/images/years/:year',
            name: 'imagesForYear', 
            component: ThumbnailList,
            props: (route) => {
                const year = parseInt(route.params.year);
                const previousYear = year - 1;
                const nextYear = year + 1;

                const props = {
                    apiPath: route.path,
                    enableHasAlbumFilter: true,
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
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
        buildImagesIndexVariant(
            '/images/favorites',
            'imageFavoritesIndex',
            {
                apiPath: '/images/?favorites=true',
                enableHasAlbumFilter: true,
                enableHasPersonFilter: true,
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
                enableHasPersonFilter: true,
                enableBatchSelectImages: true,
                pageTitle: 'Images not in an album',
            }
        ),
        buildImagesIndexVariant(
            '/images/no-amazon',
            'imageNoAmazonIndex',
            {
                apiPath: '/images/?amazon_photos_id=false',
                enableHasAlbumFilter: true,
                enableHasPersonFilter: true,
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
                }; 
            },
        },
        { 
            path: '/albums/:id',
            name: 'albumsShow', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    itemsListKey: 'images',
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
                    editItemLink: {name: 'albumsEdit', params: {id: route.params.id}},
                    isDeleteEnabled: true,
                    reorderPathSuffix: '/images/reorder',
                    reorderItemsKey: 'image_ids',
                    relatedFieldsKey: 'tags',
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
                    itemsListKey: 'images',
                    enableHasAlbumFilter: true,
                    enableBatchSelectImages: true,
                    editItemLink: {name: 'personsEdit', params: {id: route.params.id}},
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
                    itemsListKey: 'albums',
                    enableBatchSelectAlbums: true,
                    editItemLink: {name: 'tagsEdit', params: {id: route.params.id}},
                    isDeleteEnabled: true,
                    reorderPathSuffix: '/albums/reorder',
                    reorderItemsKey: 'album_ids',
                    showRouteFor: (item)=>{
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
        //has to be before importsShow route
        { 
            path: '/imports/last',
            name: 'importsShowLast', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    itemsListKey: 'images',
                    enableHasAlbumFilter: true,
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
                    showRouteFor: (item, model)=>{
                        return {
                            name: 'importImagesShow',
                            params: {
                                import_id: model.id,
                                image_id: item.id,
                            },
                        };
                    },
                };
                return props;
            },
        },
        { 
            path: '/imports/:id',
            name: 'importsShow', 
            component: ThumbnailList,
            props: (route) => {
                const props = {
                    apiPath: route.path,
                    itemsListKey: 'images',
                    enableHasAlbumFilter: true,
                    enableHasPersonFilter: true,
                    enableBatchSelectImages: true,
                    showRouteFor: (item)=>{
                        return {
                            name: 'importImagesShow',
                            params: {
                                import_id: route.params.id,
                                image_id: item.id,
                            },
                        };
                    },
                };
                return props;
            },
        },
        { 
            path: '/images/:id',
            name: 'imagesShow', 
            component: ImageDetail,
            props: (route) => {
                return {
                    modelApiPath: `/images/${route.params.id}`,
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
                    modelApiPath: `/albums/${route.params.album_id}`,
                    imageId: parseInt(route.params.image_id),
                    parent: {
                        parentRouteName: 'albumsShow',
                        showRouteFor: (item)=>{
                            return {
                                name: 'albumImagesShow',
                                params: {
                                    album_id: route.params.album_id,
                                    image_id: item.id,
                                },
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
            props: (route) => {
                return {
                    modelApiPath: `/persons/${route.params.person_id}`,
                    imageId: parseInt(route.params.image_id),
                    parent: {
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
                    modelApiPath: `/imports/${route.params.import_id}`,
                    imageId: parseInt(route.params.image_id),
                    parent: {
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
    ],
};