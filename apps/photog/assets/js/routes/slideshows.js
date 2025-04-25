import Slideshow from '../components/slideshow.vue';

export default () => [
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
];
