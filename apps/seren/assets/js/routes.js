import TrackList from './components/track-list.vue'
import Models from './models';

function relatedTracksProps(route){
    return {
        itemColumns: Models.trackItemColumns,
        itemFields: Models.trackItemFields,
        getItemsKey: {
            apiPath: route.path
        },
    }; 
}


export default {
    mode: 'history',
    routes: [
        { 
            path: '/', 
            name: 'home',
            redirect: '/artists' 
        },
        { 
            path: '/artists',
            name: 'artistsIndex', 
            component: TrackList,
            props: (route) => {
                return {
                    itemColumns: Models.defaultItemColumns,
                    itemFields: Models.defaultItemFields,
                    getItemsKey: 'artists',
                    routeForItem(item){
                        return {name: 'artistTracks', params: {id: item.id}};
                    },
                }; 
            },
        },
        { 
            path: '/albums',
            name: 'albumsIndex', 
            component: TrackList,
            props: (route) => {
                return {
                    itemColumns: Models.albumItemColumns,
                    itemFields: Models.albumItemFields,
                    getItemsKey: 'albums',
                    routeForItem(item){
                        return {name: 'albumTracks', params: {id: item.id}};
                    },
                }; 
            },
        },
        { 
            path: '/composers',
            name: 'composersIndex', 
            component: TrackList,
            props: (route) => {
                return {
                    itemColumns: Models.defaultItemColumns,
                    itemFields: Models.defaultItemFields,
                    getItemsKey: 'composers',
                    routeForItem(item){
                        return {name: 'composerTracks', params: {id: item.id}};
                    },
                }; 
            },
        },
        { 
            path: '/genres',
            name: 'genresIndex', 
            component: TrackList,
            props: (route) => {
                return {
                    itemColumns: Models.defaultItemColumns,
                    itemFields: Models.defaultItemFields,
                    getItemsKey: 'genres',
                    routeForItem(item){
                        return {name: 'genreTracks', params: {id: item.id}};
                    },
                }; 
            },
        },
        { 
            path: '/tracks',
            name: 'tracksIndex', 
            component: TrackList,
            props: (route) => {
                return {
                    itemColumns: Models.trackItemColumns,
                    itemFields: Models.trackItemFields,
                    getItemsKey: 'tracks',
                    isInfiniteScrollDisabled: false,
                }; 
            },
        },
        { 
            path: '/search/tracks',
            name: 'searchTracks', 
            component: TrackList,
            props: (route) => {
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
            props: (route) => {
                return relatedTracksProps(route);
            },
        },
        { 
            path: '/albums/:id/tracks',
            name: 'albumTracks', 
            component: TrackList,
            props: (route) => {
                return relatedTracksProps(route);
            },
        },
        { 
            path: '/composers/:id/tracks',
            name: 'composerTracks', 
            component: TrackList,
            props: (route) => {
                return relatedTracksProps(route);
            },
        },
        { 
            path: '/genres/:id/tracks',
            name: 'genreTracks', 
            component: TrackList,
            props: (route) => {
                return relatedTracksProps(route); 
            },
        },
    ],
};