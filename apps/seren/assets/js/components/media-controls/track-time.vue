<template>
    <div :class="$style['track-time']">
        <span>{{formatTrackLength(elapsedTime)}}</span>
        <span>-</span>
        <span>{{formatTrackLength(totalTime)}}</span>
    </div>
</template>

<style lang="scss" module>
    .track-time{
        font-size: 18px;
        color: #fff;
        margin-bottom: 8px;
    }
</style>

<script>
import Util from '../../util';

export default {
    props: {
        elapsedTime: {
            type: Number,
            required: true,
        },
        totalTime: {
            type: Number,
            required: true,
        },
    },
    methods: {
        formatTrackLength: Util.formatTrackLength,
	}
};
</script>