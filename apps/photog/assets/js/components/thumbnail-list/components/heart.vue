<template>
    <div
        :class="{
            [$style.heart]: true,
            [$style.checked]: checked,
            [$style.interactive]: isInteractive,
        }"
    ></div>
</template>

<style lang="scss" module>
@use 'sass:math';
/*
* Styles for heart icon on favorited images
* based on: https://css-tricks.com/hearts-in-html-and-css/
*/

$heart_color_default: #aaa;
$heart_color_default_dark: #666;
$heart_color: #ff3919;
$heart_size: 8px;

.heart {
    display: inline-block;
    height: $heart_size;
    transform: rotate(-45deg);
    width: $heart_size;
}

.heart:before,
.heart:after {
    content: '';
    border-radius: 50%;
    height: $heart_size;
    position: absolute;
    width: $heart_size;
}

.heart:before {
    top: math.div(-1 * $heart_size, 2);
    left: 0;
}

.heart:after {
    left: math.div($heart_size, 2);
    top: 0;
}

.heart {
    &,
    &:before,
    &:after {
        background-color: $heart_color_default;
    }
}

@media (prefers-color-scheme: dark) {
    .heart {
        &,
        &:before,
        &:after {
            background-color: $heart_color_default_dark;
        }
    }
}

.heart.checked {
    &,
    &:before,
    &:after {
        background-color: $heart_color;
    }
}

.interactive {
    cursor: pointer;
}
</style>

<script>
export default {
    props: {
        checked: {
            type: Boolean,
            default: false,
        },
        isInteractive: {
            type: Boolean,
            default: false,
        },
    },
};
</script>
