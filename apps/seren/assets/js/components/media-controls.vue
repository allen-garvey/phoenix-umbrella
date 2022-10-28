<template>
    <div :class="$style['media-controls-container']">
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
            </track-time>
            <controls
                :has-next-track="hasNextTrack"
                :is-playing="isPlaying"
                :active-track="activeTrack"
                :play-button-action="playButtonAction"
                :previous-button-action="previousButtonAction"
                :has-previous-track="hasPreviousTrack"
                :play-next-track="playNextTrack"
                :has-active-track="hasActiveTrack"
            >
            </controls>
        </template>
        <div v-if="!isInitialLoadComplete">Loading&hellip;</div>
    </div>
</template>

<style lang="scss" module>
    @import '~seren-styles/variables';

    .media-controls-container{
        position: fixed;
        bottom: 0;
        height: $media-controls-container-height;
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        background: $media_controls_background_color;
        box-shadow: 0px -1px 15px rgba(41, 56, 36, 0.6);
        padding: 24px;
        font-size: 15px;
    }
</style>

<script>
import ActiveTrackDisplay from './media-controls/active-track-display.vue';
import TrackTime from './media-controls/track-time.vue';
import Controls from './media-controls/controls.vue';

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
        Controls,
    },
};
</script>