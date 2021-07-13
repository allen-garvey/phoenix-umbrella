<template>
    <div :class="$style['wave-dots']" >
        <div 
            :class="[$style['wave-dot'], $style.bounce1]"
        ></div>
        <div 
            :class="[$style['wave-dot'], $style.bounce2]"
        ></div>
        <div 
            :class="[$style['wave-dot'], $style.bounce3]"
        ></div>
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

    .wave-dots {
        margin: 100px auto 0;
        width: 70px;
        text-align: center;
    }
    
    .wave-dots > .wave-dot {
        width: 18px;
        height: 18px;
        background-color: #333;
    
        border-radius: 100%;
        display: inline-block;
        -webkit-animation: wave-dots-bouncedelay 1.6s infinite ease-in-out both;
        animation: wave-dots-bouncedelay 1.5s infinite ease-in-out both;
    }
    
    .wave-dots .bounce1 {
        -webkit-animation-delay: -0.32s;
        animation-delay: -0.32s;
    }
    
    .wave-dots .bounce2 {
        -webkit-animation-delay: -0.16s;
        animation-delay: -0.16s;
    }
    
    @-webkit-keyframes wave-dots-bouncedelay {
        0%, 80%, 100% { -webkit-transform: scale(0) }
        40% { -webkit-transform: scale(1.0) }
    }
    
    @keyframes wave-dots-bouncedelay {
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
export default {};
</script>