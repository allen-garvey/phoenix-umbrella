<template>
    <div :class="$style.mediaControlsContainer">
        <template v-if="hasActiveTrack">
            <div :class="$style.controlsContainer">
                <active-track-display
                    :artists-map="artistsMap"
                    :albumsMap="albumsMap"
                    :active-track="activeTrack"
                />
                <track-time
                    :elapsed-time="elapsedTime"
                    :total-time="activeTrack.track.length"
                />
            </div>
            <div :class="$style.controlsContainer">
                <controls
                    :has-next-track="hasNextTrack"
                    :is-playing="isPlaying"
                    :active-track="activeTrack"
                    :play-button-action="playButtonAction"
                    :previous-button-action="previousButtonAction"
                    :has-previous-track="hasPreviousTrack"
                    :play-next-track="playNextTrack"
                    :has-active-track="hasActiveTrack"
                />
                <div :class="$style.volumeContainer">
                    <svg :class="$style.volumeIcon" viewBox="0 0 24 24">
                        <use
                            xlink:href="#icon-volume-x"
                            v-if="audioVolume === 0"
                        />
                        <use
                            xlink:href="#icon-volume-1"
                            v-else-if="audioVolume <= 0.6"
                        />
                        <use xlink:href="#icon-volume-2" v-else />
                    </svg>
                    <input
                        tabindex="2"
                        type="range"
                        min="0"
                        max="1"
                        :value="audioVolume"
                        step="0.05"
                        :class="$style.volumeInput"
                        @input="
                            $emit(
                                'volumeChanged',
                                parseFloat($event.target.value)
                            )
                        "
                    />
                </div>
            </div>
        </template>
        <div v-if="!isInitialLoadComplete">Loading&hellip;</div>
    </div>
</template>

<style lang="scss" module>
@use '~seren-styles/variables';

.mediaControlsContainer {
    position: fixed;
    bottom: 0;
    height: variables.$media-controls-container-height;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: center;
    background: variables.$media_controls_background_color;
    box-shadow: 0px -1px 15px rgba(41, 56, 36, 0.6);
    padding: 24px;
    font-size: 15px;
}

.controlsContainer {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 1.5rem;
}

.volumeContainer {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.volumeIcon {
    max-height: 100%;
    width: 28px;
}

.volumeInput {
}
</style>

<script>
import ActiveTrackDisplay from './media-controls/active-track-display.vue';
import TrackTime from './media-controls/track-time.vue';
import Controls from './media-controls/controls.vue';

export default {
    props: {
        audioVolume: {
            type: Number,
            required: true,
        },
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
        albumsMap: {
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
