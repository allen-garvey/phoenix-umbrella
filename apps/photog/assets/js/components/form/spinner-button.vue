<template>
    <button
        @click="$emit('buttonClick')"
        class="btn"
        :class="buttonClasses"
        :disabled="isDisabled || isLoading"
    >
        <span v-if="!isLoading">{{ buttonText }}</span>
        <span v-else>
            <span>{{ spinnerText }}</span>
            <span
                class="spinner-border spinner-border-sm"
                :class="$style.buttonSpinner"
                role="status"
                aria-hidden="true"
            ></span>
        </span>
    </button>
</template>

<style lang="scss" module>
.buttonSpinner {
    margin-left: 0.5em;
}
</style>

<script>
export default {
    props: {
        buttonText: {
            type: String,
            required: true,
        },
        spinnerText: {
            type: String,
            required: true,
        },
        isLoading: {
            type: Boolean,
            required: true,
        },
        isDisabled: {
            type: Boolean,
            default: false,
        },
        buttonClasses: {
            type: Array,
            required: true,
        },
    },
};
</script>
