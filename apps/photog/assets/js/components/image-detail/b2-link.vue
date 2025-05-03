<template>
    <div>
        <a
            :href="url"
            v-if="url"
            target="_blank"
            rel="noopener noreferrer nofollow"
            :class="$style.url"
        >
            Open image in Backblaze B2
            <svg><use href="#icon-external-link" /></svg>
        </a>
        <spinner-button
            v-else
            @buttonClick="loadUrl"
            :isLoading="isLoading"
            :buttonClasses="['btn-sm', 'btn-outline-dark']"
            buttonText="Get B2 image url"
            spinnerText="Loading..."
        />
    </div>
</template>

<style lang="scss" module>
.url {
    font-size: 1rem;

    svg {
        height: 1em;
        width: 1em;
    }
}
</style>

<script>
import SpinnerButton from '../form/spinner-button.vue';

export default {
    props: {
        image: {
            type: Object,
            required: true,
        },
        onB2UrlRequested: {
            type: Function,
            required: true,
        },
    },
    components: {
        SpinnerButton,
    },
    created() {
        this.setup();
    },
    data() {
        return {
            isLoading: false,
            url: null,
        };
    },
    watch: {
        image() {
            this.setup();
        },
    },
    methods: {
        setup() {
            this.isLoading = false;
            this.url = null;
            this.onB2UrlRequested(this.image, true).then(this.urlLoaded);
        },
        loadUrl() {
            this.isLoading = true;
            this.onB2UrlRequested(this.image).then(this.urlLoaded);
        },
        urlLoaded(result) {
            this.isLoading = false;
            if (!result || result.imageId !== this.image.id) {
                return;
            }
            this.url = result.url;
        },
    },
};
</script>
