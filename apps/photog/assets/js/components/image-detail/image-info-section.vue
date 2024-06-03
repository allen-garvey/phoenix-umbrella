<template>
    <div :class="$style.imageShowInfoSection">
        <h3 :class="$style.imageInfoSectionHeading">{{ heading }}</h3>
        <slot></slot>
    </div>
</template>

<style lang="scss" module>
    $image_show_dt_width: 10em;
    .imageShowInfoSection{
        dl{
            display: flex;
            flex-wrap: wrap;
            margin-top: 0;
        }
        dt{
            font-weight: normal;
            flex-basis: $image_show_dt_width;
            margin-bottom: 0.5em;
            &:after{
                content: ":";
            }
        }
        dd{
            flex-basis: calc(100% - #{$image_show_dt_width});
            margin-left: 0;
        }
    }
    .imageInfoSectionHeading{
        margin-bottom: 0.5rem;
    }
</style>

<script>
export default {
    props: {
        heading: {
            type: String,
            required: true,
        },
    },
};
</script>