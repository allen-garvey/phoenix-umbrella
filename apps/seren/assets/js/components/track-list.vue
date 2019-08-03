<template>
    <div>
        <table class="track-list">
            <thead>
                <th class="col-play-btn"></th>
                <template v-for="(column, i) in itemColumns">
                    <th :key="i" @click="sortItems(column.sort)">{{column.title}}</th>
                </template>
            </thead>
            <tbody>
                <template v-for="(item, i) in items">
                    <tr @dblclick="doubleClickRowAction(item, i)" :key="i">
                        <td @click="rowPlayButtonClicked(item, i)" class="col-play-btn" :class="{'pause': canRowBePlayed && isTrackPlaying(item), 'track-play-button': canRowBePlayed}"></td>
                        <template v-for="(field, j) in itemFields(item)">
                            <td :key="`${item.id}${i}${field}${j}`">{{field}}</td>
                        </template>
                    </tr>
                </template>
                <infinite-observer :on-trigger="infiniteScrollTriggered" v-if="!isInfiniteScrollDisabled">
                </infinite-observer>
            </tbody>
        </table>
    </div>
</template>

<script>
import InfiniteObserver from '../../../../common/assets/js/vue/components/infinite-observer.vue';

export default {
	name: 'Track-List',
    components: {
        InfiniteObserver,
    },
    props: {
        loadMoreTracks: {
            type: Function,
            required: true,
        },
        itemColumns: {
            type: Array,
            required: true,
        },
        itemFields: {
            type: Function,
            required: true,
        },
        isTrackPlaying: {
            type: Function,
            required: true,
        },
        getItems: {
            type: Function,
            required: true,
        },
        //might be string or function
        getItemsKey: {
            required: true,
        },
        sortItemsFunc: {
            type: Function,
            required: true,
        },
        playTrack: {
            type: Function,
            required: true,
        },
        stopTrack: {
            type: Function,
            required: true,
        },
        //if on list page with list of tracks, routeForItem will be null meaning we should play the track, 
        //otherwise it will be a function taking the row and giving us a route to go to 
        routeForItem: {
            default: null,
        },
        isInfiniteScrollDisabled: {
            type: Boolean,
            default: true,
        },
        artistsMap: {
            type: Map,
            required: true,
        },
        albumsMap: {
            type: Map,
            required: true,
        },
        genresMap: {
            type: Map,
            required: true,
        },
        composersMap: {
            type: Map,
            required: true,
        },
    },
	created(){
        //watch for $route will not be called on initial load
        this.loadItems();
	},
	data(){
		return {
            items: [],
			previousSortKey: null,
            sortAsc: true,
		};
	},
	computed: {
        canRowBePlayed(){
            return !this.routeForItem;
        },
    },
    watch: {
        '$route'(){
            this.loadItems();
        },
    },
	methods: {
        loadItems(){
            this.items = [];
            this.getItems(this.getItemsKey).then((items)=>{
                this.items = items;
            });
        },
        infiniteScrollTriggered($state){
            this.loadMoreTracks().then(()=>{
                this.loadItems();
                $state.loaded();
            });
        },
		sortItems(key){
			if(key !== this.previousSortKey){
				this.sortAsc = true;
			}
			else{
				this.sortAsc = !this.sortAsc;
            }
			this.previousSortKey = key;
            this.sortItemsFunc(this.items, key, this.sortAsc);
        },
        rowPlayButtonClicked(item, i){
            if(!this.canRowBePlayed){
                return;
            }
            if(this.isTrackPlaying(item)){
                this.stopTrack();
            }
            else{
                this.playTrack(item, i, this.items);
            }
        },
        doubleClickRowAction(item, i){
            if(this.routeForItem){
                this.$router.push(this.routeForItem(item));
            }
            else{
                this.playTrack(item, i, this.items);
            }
        },
	}
};
</script>