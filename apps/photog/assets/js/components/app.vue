<template>
    <div>
        <Photog-Header/>
        <Flash-Alert ref="flashAlert"/>
        <router-view v-slot="{ Component }">
            <component 
                ref="routerView" 
                :is="Component"
                :getModel="get" 
                :putFlash="putFlash" 
                :getExif="getExif" 
                :sendJson="sendJson" 
                :setWindowTitle="setWindowTitle" 
            />
        </router-view>
    </div>
</template>

<script>
import PhotogHeader from './header.vue'
import FlashAlert from './flash-alert.vue';
import CacheUtil from '../cache-util.js'
import { API_URL_BASE } from '../request-helpers.js';
import { sendJson } from 'umbrella-common-js/ajax.js';

export default {
    name: 'Photog-App',
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
    },
    components: {
        'Photog-Header': PhotogHeader,
        'Flash-Alert': FlashAlert,
    },
    data() {
        return {
            cache: new Map(),
            exifCache: new Map(),
        }
    },
    computed: {

    },
    watch: {
        '$route'(to, from){
            const flashAlert = this.$refs.flashAlert;
            const flashMessage = to.params.flashMessage;
            //show flash message if any
            if(flashMessage){
                this.putFlash(...flashMessage);
            }
            else{
                //have to manually clear flash alert here, because this is called first
                //while if we do it in the component it might be called later
                flashAlert.clearFlash();
            }
        },
    },
    created() {
        window.addEventListener('keyup', (e)=>{
            const routerView = this.$refs.routerView;
            if(routerView.onKeyPressed){
                routerView.onKeyPressed(e.key);
            }
        });
    },
    methods: {
        setWindowTitle(title){
            document.title = `Photog | ${title}`;
        },
        get(modelPath, options){
            const apiUrl = API_URL_BASE + modelPath;
            return CacheUtil.fetchIntoCache(apiUrl, this.cache, apiUrl, options);
        },
        getExif(imageId){
            const apiUrl = `${API_URL_BASE}/images/${imageId}/exif`;
            return CacheUtil.fetchIntoCache(apiUrl, this.exifCache, imageId);
        },
        putFlash(message, type){
            const flashAlert = this.$refs.flashAlert;
            flashAlert.putFlash(message, type);
            flashAlert.$el.scrollIntoView({behavior: 'smooth', block: 'end'});
        },
        //wrapper for send json so cache can be cleared after something is sent to API
        sendJson(url, ...args){
            return sendJson(url, this.csrfToken, ...args).then((response)=>{
                //assume cache needs to be cleared
                //note that the cache could still be stale if there are multiple users
                //updating at once, but we are going to assume that this is a single user system
                this.cache.clear();
                return response;
            });
        }
    }
}
</script>
