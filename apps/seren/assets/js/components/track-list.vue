<template>
    <table :class="$style['track-list']">
        <thead>
            <th :class="$style['col-play-btn']"></th>
            <th 
                v-for="(column, i) in itemColumns"
                :key="i" 
                @click="sortItems(column.sort)"
            >
                {{column.title}}
            </th>
        </thead>
        <tbody>
            <tr 
                v-for="(item, i) in items"
                :key="i"
                @dblclick="doubleClickRowAction(item, i)"
            >
                <td 
                    @click="rowPlayButtonClicked(item, i)" 
                    :class="trackButtonClasses(item)"
                >
                </td>
                <td 
                    v-for="(field, j) in itemFields(item)"
                    :key="`${item.id}${i}${field}${j}`"
                >
                    {{field}}
                </td>
            </tr>
            <tr>
                <td :colspan="itemColumns.length + 1">
                    <infinite-observer 
                        :on-trigger="infiniteScrollTriggered" 
                        v-if="!isInfiniteScrollDisabled"
                    >
                    </infinite-observer>
                </td>
            </tr>
        </tbody>
    </table>
</template>

<style lang="scss" module>
    .track-list{
        width: 100%;
        table-layout: fixed;
        border-collapse: collapse;

        thead{
            background: #b6cfe7;
            font-family: sans-serif;
        }
        th, td{
            padding: 0.5em;
        }
        th{
            text-align: left;
            cursor: pointer;
        }

        tbody tr{
            transition: background-color 0.3s ease;
            cursor: pointer;
            
            &:nth-of-type(even){
                background: #e6f2fe;
            }
            //has to be after nth-of-type or it won't work
            &:active{
                background: dodgerblue;
            }
        }
    }

    .col-play-btn{
        width: 50px;
    }

    .track-play-button{
        cursor: pointer;

        &:hover::after{
            content: 'Play';
        }

        &.pause::after{
            content: 'Pause';
        }
    }
</style>

<script>
import InfiniteObserver from 'umbrella-common-js/vue/components/infinite-observer.vue';

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
    beforeRouteLeave(to, from, ){
        this.items = [];
    },
    beforeRouteEnter(to, from, next){
        next((self) => {
            self.loadItems();
        });
    },
	methods: {
        trackButtonClasses(item){
            return {
                [this.$style['col-play-btn']]: true,
                [this.$style.pause]: this.canRowBePlayed && this.isTrackPlaying(item), 
                [this.$style['track-play-button']]: this.canRowBePlayed,
            };
        },
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