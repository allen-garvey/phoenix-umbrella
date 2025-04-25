import ImageDetail from '../components/image-detail.vue';

export default () => [
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
];
