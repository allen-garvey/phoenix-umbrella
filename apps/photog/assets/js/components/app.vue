<template>
    <div>
        <Photog-Header />
        <Flash-Alert ref="flashAlert" />
        <router-view v-slot="{ Component }">
            <component
                ref="routerView"
                :is="Component"
                :getModel="get"
                :putFlash="putFlash"
                :getExif="getExif"
                :sendJson="sendJson"
                :setWindowTitle="setWindowTitle"
                :thumbnailUrlFor="thumbnailUrlFor"
                :miniThumbnailUrlFor="miniThumbnailUrlFor"
                :masterUrlFor="masterUrlFor"
                :isB2Enabled="!!b2BucketPrefix"
                :onB2UrlRequested="onB2UrlRequested"
            />
        </router-view>
    </div>
</template>

<script>
import PhotogHeader from './app/header.vue';
import FlashAlert from './app/flash-alert.vue';
import CacheUtil from '../cache-util.js';
import { API_URL_BASE } from '../request-helpers.js';
import { thumbnailUrlFor, getMasterUrl } from '../image.js';
import { sendJson, fetchJson } from 'umbrella-common-js/ajax.js';
import {
    getCachedValue,
    updateCachedValue,
    constructB2UrlResponse,
} from '../b2';

export default {
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        imageUrlPrefix: {
            type: String,
            required: true,
        },
        imageThumbnailsOnly: {
            type: String,
            required: true,
        },
        b2BucketPrefix: {
            type: String,
        },
    },
    components: {
        PhotogHeader,
        FlashAlert,
    },
    data() {
        return {
            cache: new Map(),
            exifCache: new Map(),
        };
    },
    computed: {},
    watch: {
        $route(to, from) {
            const flashAlert = this.$refs.flashAlert;
            const flashMessage = history.state.flashMessage;
            //show flash message if any
            if (flashMessage) {
                let parsedFlashMessage;
                try {
                    parsedFlashMessage = JSON.parse(flashMessage);
                } catch {
                    console.error('Could not parse flashMessage.');
                    return;
                }
                this.putFlash(...parsedFlashMessage);
            } else {
                //have to manually clear flash alert here, because this is called first
                //while if we do it in the component it might be called later
                flashAlert.clearFlash();
            }
        },
    },
    created() {
        window.addEventListener('keyup', e => {
            const routerView = this.$refs.routerView;
            if (routerView.onKeyPressed) {
                routerView.onKeyPressed(e.key);
            }
        });
    },
    methods: {
        setWindowTitle(title) {
            document.title = ['Photog', title].filter(s => s).join(' | ');
        },
        get(modelPath, options, isApiUrl = true) {
            const apiUrl = isApiUrl ? API_URL_BASE + modelPath : modelPath;
            return CacheUtil.fetchIntoCache(
                apiUrl,
                this.cache,
                apiUrl,
                options
            );
        },
        getExif(imageId, options) {
            const apiUrl = `${API_URL_BASE}/images/${imageId}/exif`;
            return CacheUtil.fetchIntoCache(
                apiUrl,
                this.exifCache,
                imageId,
                options
            );
        },
        putFlash(message, type) {
            const flashAlert = this.$refs.flashAlert;
            flashAlert.putFlash(message, type);
            flashAlert.$el.scrollIntoView({ behavior: 'smooth', block: 'end' });
        },
        //wrapper for send json so cache can be cleared after something is sent to API
        sendJson(url, method, data, options) {
            return sendJson(url, this.csrfToken, method, data).then(
                response => {
                    //assume cache needs to be cleared
                    //note that the cache could still be stale if there are multiple users
                    //updating at once, but we are going to assume that this is a single user system
                    if (!options.preserveCache) {
                        this.cache.clear();
                    }
                    return response;
                }
            );
        },
        thumbnailUrlFor(image) {
            return thumbnailUrlFor(image.thumbnail_path, this.imageUrlPrefix);
        },
        miniThumbnailUrlFor(image) {
            return thumbnailUrlFor(
                image.mini_thumbnail_path,
                this.imageUrlPrefix
            );
        },
        masterUrlFor(image) {
            if (this.imageThumbnailsOnly === '1') {
                return this.thumbnailUrlFor(image);
            }
            return getMasterUrl(image, this.imageUrlPrefix);
        },
        onB2UrlRequested(image, cacheOnly = false) {
            const cachedValue = getCachedValue();
            if (cacheOnly || cachedValue) {
                return Promise.resolve(
                    constructB2UrlResponse(
                        image,
                        cachedValue,
                        this.b2BucketPrefix
                    )
                );
            }

            return fetchJson(`${API_URL_BASE}/b2/download_token`).then(res => {
                updateCachedValue(res);
                return constructB2UrlResponse(image, res, this.b2BucketPrefix);
            });
        },
    },
};
</script>
