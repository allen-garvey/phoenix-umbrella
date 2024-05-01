<template>
    <div>
        <a 
            :href="url" 
            v-if="url" 
            target="_blank" 
            rel="noopener noreferrer nofollow" 
            :class="$style.url"
        >
            Open image in Backblaze B2 <svg><use href="#icon-external-link" /></svg>
        </a>
        <button 
            @click="loadUrl" 
            class="btn btn-sm btn-outline-dark"
            :disabled="isLoading"
            v-else
        >
            <span v-if="!isLoading">Get B2 image url</span>
            <span v-else>
                <span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>
                Loading...
            </span>
        </button>
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
    created(){
        this.setup();
    },
    data(){
        return {
            isLoading: false,
            url: null,
        };
    },
    watch: {
        image(){
            this.setup();
        },
    },
    methods: {
        setup(){
            this.isLoading = false;
            this.url = null;
            this.onB2UrlRequested(this.image, true).then(this.urlLoaded);
        },
        loadUrl(){
            this.isLoading = true;
            this.onB2UrlRequested(this.image).then(this.urlLoaded);
        },
        urlLoaded(result){
            console.log(result);
            this.isLoading = false;
            if(!result || result.imageId !== this.image.id){
                return;
            }
            this.url = result.url;
        }
    }
};
</script>