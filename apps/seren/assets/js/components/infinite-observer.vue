<template>
  <div>

  </div>
</template>

<script>
//based on: https://vueschool.io/articles/vuejs-tutorials/build-an-infinite-scroll-component-using-intersection-observer-api/
export default {
    props: {
        options: {
            type: Object,
            default() {
                return {
                    root: null,
                    threshold: 1.0,
                };
            },
        },
        onTrigger: {
            type: Function,
            required: true,
        },
        },
    data(){
        return {
            observer: null,
            isParentLoading: false,
        };
    },
    mounted() {
        this.observer = new IntersectionObserver(([entry]) => {
            if (!this.isParentLoading && entry && entry.isIntersecting) {
                this.isParentLoading = true;
                this.onTrigger(this.buildCallbackObject());
            }
        }, this.options);

        this.observer.observe(this.$el);
    },
    destroyed() {
        this.disconnectObserver();
    },
    methods:{
        disconnectObserver(){
            if(this.observer){
                this.observer.disconnect();
                this.observer = null;
            }
        },
        buildCallbackObject(){
            return {
                    loaded: ()=>{
                        this.isParentLoading = false;
                },
                complete: ()=>{
                    this.disconnectObserver();
                },
            };
        },
    },
};
</script>