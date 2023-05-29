<template>
<div>
    <loading-animation v-if="!isInitialLoadComplete" />
    <div v-if="isInitialLoadComplete">
        <h2><router-link :to="{name: 'imagesShow', params: {id: imageId}}">Editing {{ imageFileName }}</router-link></h2>
    </div>
</div>
</template>

<style lang="scss" module>

</style>

<script>
import LoadingAnimation from 'umbrella-common-js/vue/components/loading-animation.vue';

export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
        imageId: {
            type: Number,
            required: true,
        },
    },
    components: {
        LoadingAnimation,
    },
    created(){
        this.setup();
    },
    mounted(){
    },
    data(){
        return {
            isInitialLoadComplete: false,
            imageModel: null,
        };
    },
    computed: {
        imageFileName(){
            if(!this.imageModel){
                return this.imageId;
            }
            const fileSplit = this.imageModel.master_path.split('/');
            return fileSplit[fileSplit.length - 1];
        },
    },
    watch: {
        '$route'(to, from){
            nextTick().then(() => {
                this.setup();
            });
        }
    },
    methods: {
        setup(){
            this.isInitialLoadComplete = false;
            const imagePromise = this.getModel(`/images/${this.imageId}`).then(model => {
                this.imageModel = model;
            });

            Promise.all([imagePromise]).then(() => {
                this.isInitialLoadComplete = true;
            });
        },
    }
};
</script>