<template>
    <div :class="$style.mediaControls">
        <button
            :class="[$style.button, $style.buttonSecondary]"
            @click="previousButtonAction"
            :disabled="!hasPreviousTrack"
            title="Play previous track"
        >
            <svg>
                <use href="#icon-skip-back" />
            </svg>
        </button>
        <button
            :class="[$style.button, $style.buttonPlay]"
            @click="playButtonAction"
            :title="playButtonTitle"
        >
            <svg>
                <use href="#icon-pause" v-if="isPlaying" />
                <use href="#icon-play" v-else />
            </svg>
        </button>
        <button
            :class="[$style.button, $style.buttonSecondary]"
            @click="playNextTrack"
            :disabled="!hasNextTrack"
            title="Play next track"
        >
            <svg>
                <use href="#icon-skip-forward" />
            </svg>
        </button>
    </div>
</template>

<style lang="scss" module>
svg {
    position: relative;
}

.mediaControls {
    display: flex;
    align-items: center;
    justify-content: space-between;
}
.button {
    cursor: pointer;
    border: none;
    background-color: transparent;
    font-size: 24px;

    &:hover,
    &:active {
        border-color: white;
        color: white;
    }
    &:active {
        background-color: #85b8ea;
    }
}

.buttonPlay {
    height: 42px;
    width: 42px;
}

.buttonSecondary {
    height: 42px;
    width: 42px;
}
</style>

<script>
export default {
    props: {
        hasNextTrack: {
            type: Boolean,
            required: true,
        },
        isPlaying: {
            type: Boolean,
            required: true,
        },
        activeTrack: {
            type: Object,
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
        hasPreviousTrack: {
            type: Boolean,
            required: true,
        },
        playNextTrack: {
            type: Function,
            required: true,
        },
        hasActiveTrack: {
            type: Boolean,
            required: true,
        },
    },
    computed: {
        playButtonTitle() {
            if (this.isPlaying) {
                return `Pause ${this.activeTrack.track.title}`;
            } else if (this.hasActiveTrack) {
                return `Play ${this.activeTrack.track.title}`;
            }
            return 'Play track';
        },
    },
};
</script>
