import TrackList from './components/track-list.vue';
import TrackList2 from './components/track-list2.vue';
import ArtistList from './components/artist-list.vue';
import ComposerList from './components/composer-list.vue';
import AlbumList from './components/album-list.vue';
import Models from './models';

function relatedTracksProps(route) {
    return {
        itemColumns: Models.trackItemColumns,
        itemFields: Models.trackItemFields,
        getItemsKey: {
            apiPath: route.path,
        },
    };
}

export default {
    mode: 'history',
    routes: [
        {
            path: '/',
            name: 'home',
            redirect: '/artists',
        },
        {
            path: '/artists',
            name: 'artistsIndex',
            component: ArtistList,
        },
        {
            path: '/albums',
            name: 'albumsIndex',
            component: AlbumList,
        },
        {
            path: '/composers',
            name: 'composersIndex',
            component: ComposerList,
        },
        {
            path: '/tracks',
            name: 'tracksIndex',
            component: TrackList2,
        },
        {
            path: '/search/tracks',
            name: 'searchTracks',
            component: TrackList,
            props: route => {
                return {
                    itemColumns: Models.trackItemColumns,
                    itemFields: Models.trackItemFields,
                    getItemsKey: 'searchTracks',
                };
            },
        },
        {
            path: '/artists/:id/tracks',
            name: 'artistTracks',
            component: TrackList,
            props: route => {
                return relatedTracksProps(route);
            },
        },
        {
            path: '/albums/:id/tracks',
            name: 'albumTracks',
            component: TrackList,
            props: route => {
                return relatedTracksProps(route);
            },
        },
        {
            path: '/composers/:id/tracks',
            name: 'composerTracks',
            component: TrackList,
            props: route => {
                return relatedTracksProps(route);
            },
        },
        {
            path: '/genres/:id/tracks',
            name: 'genreTracks',
            component: TrackList,
            props: route => {
                return relatedTracksProps(route);
            },
        },
    ],
};
