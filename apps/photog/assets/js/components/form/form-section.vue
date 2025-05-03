<template>
    <main class="main container inner-container">
        <div>
            <h1>{{ heading }}</h1>
        </div>
        <form @submit.prevent="save()">
            <slot name="inputs"></slot>

            <div class="spread-content">
                <router-link :to="backLink" class="btn btn-outline-dark"
                    >Cancel</router-link
                >
                <spinner-button
                    :isLoading="isSaving"
                    :buttonClasses="['btn-success']"
                    buttonType="submit"
                    buttonText="Save"
                    spinnerText="Saving..."
                />
            </div>
        </form>
    </main>
</template>

<script>
import SpinnerButton from './spinner-button.vue';

export default {
    props: {
        heading: {
            type: String,
            required: true,
        },
        backLink: {
            type: Object,
            required: true,
        },
        save: {
            type: Function,
            required: true,
        },
        isSaving: {
            type: Boolean,
            required: true,
        },
    },
    components: {
        SpinnerButton,
    },
};
</script>
