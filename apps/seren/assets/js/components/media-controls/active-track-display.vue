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
			if(!this.hasActiveTrack){
				return '';
			}
			let ret = `${this.activeTrack.track.title} - ${this.artistsMap.get(this.activeTrack.track.artist_id).name}`;
			if(this.activeTrack.track.album_title){
				ret = `${ret} - ${this.activeTrack.track.album_title}`;
			}
			return ret;
		},
    },
};
</script>