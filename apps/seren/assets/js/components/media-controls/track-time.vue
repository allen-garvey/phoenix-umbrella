<template>
    <div :class="$style.trackTime">
        <span>{{ formatTrackLength(elapsedTime) }}</span>
        <span>-</span>
        <span>{{ formatTrackLength(totalTime) }}</span>
    </div>
</template>

<style lang="scss" module>
.trackTime {
    font-size: 18px;
    color: #fff;
    margin-bottom: 8px;
}
</style>

<script>
import { formatTrackLength } from '../../view-helpers';

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
        formatTrackLength,
    },
};
</script>
