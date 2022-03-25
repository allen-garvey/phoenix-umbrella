<template>
    <div :class="$style['active-track-display']">
        {{activeTrackDisplay}}
    </div>
</template>

<style lang="scss" module>
    .active-track-display{
        margin-bottom: 8px;
    }
</style>

<script>
export default {
    props: {
        artistsMap: {
            type: Map,
            required: true,
        },
        activeTrack: {
            type: Object,
            required: true,
        },
    },
    computed: {
        activeTrackDisplay(){
			if(!this.activeTrack.track){
				return '';
			}
            const titleArray = [
                this.artistsMap.get(this.activeTrack.track.artist_id).name,
                this.activeTrack.track.title,
            ];
			if(this.activeTrack.track.album_title){
                titleArray.push(this.activeTrack.track.album_title);
			}
			return titleArray.join(' - ');;
		},
    },
};
</script>