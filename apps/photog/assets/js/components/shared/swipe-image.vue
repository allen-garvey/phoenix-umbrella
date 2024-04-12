<template>
    <img 
        :src="src" 
        :class="imageClass"
        @touchstart="touchStart"
        @touchend="touchEnd"
    />
</template>

<script>
const X_THRESHOLD = 50;
const Y_THRESHOLD = 100;

export default {
    props: {
        src: {
            type: String,
            required: true,
        },
        imageClass: {
            type: String,
            default: '',
        },
        onSwiped: {
            type: Function,
            required: true,
        },
    },
    data(){
        return {
            touchStartX: null,
            touchStartY: null,
        };
    },
    methods: {
        touchStart($event){
            // check if pinching to zoom
            if($event.touches.length > 1){
                this.touchStartX = null;
                this.touchStartY = null;
                return;
            }
            const touch = $event.touches[0];
            this.touchStartX = touch.clientX;
            this.touchStartY = touch.clientY;

        },
        touchEnd($event){
            if(this.touchStartX === null){
                return;
            }

            const touch = $event.changedTouches[0];
            const touchEndX = touch.clientX;
            const touchEndY = touch.clientY;

            const yDifference = Math.abs(touchEndY - this.touchStartY);
            if(yDifference > Y_THRESHOLD){
                return;
            }
            const xDifference = Math.abs(touchEndX - this.touchStartX);
            if(xDifference < X_THRESHOLD){
                return;
            }

            // reverse direction, since when swiping left we really want to go right
            const key = touchEndX < this.touchStartX ? 'ArrowRight' : 'ArrowLeft';
            this.onSwiped(key);
        },
    }
};
</script>