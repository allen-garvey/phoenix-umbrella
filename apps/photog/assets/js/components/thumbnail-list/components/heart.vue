<template>
    <div :class="$style.heart"> 
    </div>
</template>

<style lang="scss" module>
    @use 'sass:math';
    /*
    * Styles for heart icon on favorited images
    * based on: https://css-tricks.com/hearts-in-html-and-css/
    */

    $heart_color: #FF3919;
    $heart_size: 8px;

    .heart {
        background-color: $heart_color;
        display: inline-block;
        height: $heart_size;
        transform: rotate(-45deg);
        width: $heart_size;
    }

    .heart:before,
    .heart:after {
        content: "";
        background-color: $heart_color;
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
</style>

<script>
export default {
};
</script>