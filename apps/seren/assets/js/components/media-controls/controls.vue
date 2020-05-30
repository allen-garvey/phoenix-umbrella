<template>
    <div class="media-controls">
        <button 
            :class="[$style.button, $style['button-previous'], $style['button-rounded']]" 
            @click="previousButtonAction" 
            :disabled="!hasPreviousTrack" 
            title="Play previous track">&#9194;</button>
        <button 
            :class="playButtonClasses"
            @click="playButtonAction" 
            :title="playButtonTitle"
        >
            <span v-html="playButtonText"></span>
        </button>
        <button 
            :class="[$style.button, $style['button-next'], $style['button-rounded']]"
            @click="playNextTrack" 
            :disabled="!hasNextTrack" 
            title="Play next track"
        >&#9193;</button>
    </div>
</template>

<style lang="scss" module>
    .button{
        cursor: pointer;
        font-size: 24px;
        margin-right: 3px;
        border: 2px solid transparent;

        &:hover, &:active{
            border: 2px solid #2166ab;
        }
        &:active{
            background-color: #85b8ea;
        }
    }

    .button-play{
        height: 48px;
        width: 48px;
        border-radius: 50%;
        //play icon doesn't get perfectly centered
        &.is-paused span{
            position: relative;
            left: 2px;
        }
    }
    .button-rounded{
        border-radius: 20%;
        height: 34px;
        width: 34px;
    }
    .button-next{
        margin-right: 0;
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
        playButtonClasses(){
            return {
                [this.$style.button]: true,
                [this.$style['button-play']]: true,
                [this.$style['is-paused']]: !this.isPlaying,
            };
        },
    },
};
</script>