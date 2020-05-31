<template>
  <div>
    <div :class="$style['infinite-observer-wave-dots']" 
        v-if="isParentLoading"
    >
        <div 
            :class="[$style['infinite-observer-wave-dot'], $style.bounce1]"
        ></div>
        <div 
            :class="[$style['infinite-observer-wave-dot'], $style.bounce2]"
        ></div>
        <div 
            :class="[$style['infinite-observer-wave-dot'], $style.bounce3]"
        ></div>
    </div>
  </div>
</template>

<style lang="scss" module>
    //  based on: https://tobiasahlin.com/spinkit/
    // https://github.com/tobiasahlin/SpinKit
    /*
    The MIT License (MIT)

    Copyright (c) 2015 Tobias Ahlin

    Permission is hereby granted, free of charge, to any person obtaining a copy of
    this software and associated documentation files (the "Software"), to deal in
    the Software without restriction, including without limitation the rights to
    use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
    the Software, and to permit persons to whom the Software is furnished to do so,
    subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
    FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
    COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
    IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
    CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
    */  

    .infinite-observer-wave-dots {
        margin: 100px auto 0;
        width: 70px;
        text-align: center;
    }
    
    .infinite-observer-wave-dots > .infinite-observer-wave-dot {
        width: 18px;
        height: 18px;
        background-color: #333;
    
        border-radius: 100%;
        display: inline-block;
        -webkit-animation: infinite-observer-wave-dots-bouncedelay 1.6s infinite ease-in-out both;
        animation: infinite-observer-wave-dots-bouncedelay 1.5s infinite ease-in-out both;
    }
    
    .infinite-observer-wave-dots .bounce1 {
        -webkit-animation-delay: -0.32s;
        animation-delay: -0.32s;
    }
    
    .infinite-observer-wave-dots .bounce2 {
        -webkit-animation-delay: -0.16s;
        animation-delay: -0.16s;
    }
    
    @-webkit-keyframes infinite-observer-wave-dots-bouncedelay {
        0%, 80%, 100% { -webkit-transform: scale(0) }
        40% { -webkit-transform: scale(1.0) }
    }
    
    @keyframes infinite-observer-wave-dots-bouncedelay {
        0%, 80%, 100% { 
        -webkit-transform: scale(0);
        transform: scale(0);
        } 40% { 
        -webkit-transform: scale(1.0);
        transform: scale(1.0);
        }
    }
</style>

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
                    this.isParentLoading = false;
                    this.disconnectObserver();
                },
            };
        },
    },
};
</script>