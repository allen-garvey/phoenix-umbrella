<template>
    <div class="media-controls-container">
        <template v-if="hasActiveTrack">
            <active-track-display
                :artists-map="artistsMap"
                :active-track="activeTrack"
            >
            </active-track-display>
            <track-time
                :elapsed-time="elapsedTime"
                :total-time="activeTrack.track.length"
            >
            <track-time>
            <div class="media-controls">
                <button class="button-previous media-controls-button media-controls-button-rounded" @click="previousButtonAction" :disabled="!hasPreviousTrack" title="Play previous track">&#9194;</button>
                <button class="button-play media-controls-button" :class="{'is-paused': !isPlaying}" @click="playButtonAction" :title="playButtonTitle">
                    <span v-html="playButtonText"></span>
                </button>
                <button class="button-next media-controls-button media-controls-button-rounded" @click="playNextTrack" :disabled="!hasNextTrack" title="Play next track">&#9193;</button>
            </div>
        </template>
        <div v-if="!isInitialLoadComplete">Loading&hellip;</div>
    </div>
</template>

<script>
import ActiveTrackDisplay from './media-controls/active-track-display.vue';
import TrackTime from './media-controls/track-time.vue';

export default {
	name: 'Media-Controls',
	props: {
        elapsedTime: {
            type: Number,
            required: true,
        },
        isPlaying: {
            type: Boolean,
            required: true,
        },
        isInitialLoadComplete: {
            type: Boolean,
            required: true,
        },
        hasActiveTrack: {
            type: Boolean,
            required: true,
        },
        hasPreviousTrack: {
            type: Boolean,
            required: true,
        },
        hasNextTrack: {
            type: Boolean,
            required: true,
        },
        artistsMap: {
            type: Map,
            required: true,
        },
        activeTrack: {
            type: Object,
            required: true,
        },
        playNextTrack: {
            type: Function,
            required: true,
        },
        playButtonAction: {
            type: Function,
            required: true,
        },
        previousButtonAction: {
            type: Function,
            required: true,
        },
    },
    components: {
        ActiveTrackDisplay,
        TrackTime,
    },
	computed: {
		playButtonTitle(){
			if(this.isPlaying){
				return `Pause ${this.activeTrack.track.title}`;
			}
			else if(this.hasActiveTrack){
				return `Play ${this.activeTrack.track.title}`;
			}
			return 'Play track';

		},
		playButtonText(){
			if(this.isPlaying){
				return '&#9646;&#9646;';
			}
			return '&#9654;';
		},
	},
};
</script>