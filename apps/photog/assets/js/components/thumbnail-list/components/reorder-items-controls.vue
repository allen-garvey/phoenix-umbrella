<template>
    <div :class="$style['reorder-resources-controls-container']">
        <button class="btn" :class="reorderButtonCssClass" v-show="shouldShowReorderButton" @click="reorderButtonAction()">
            {{reorderButtonText}}
        </button>
        <button class="btn btn-success" v-show="isReordering && isListReordered" @click="saveOrder()">
            Save order
        </button>
    </div>
</template>

<style lang="scss" module>
    .reorder-resources-controls-container{
        display: inline-block;
        margin-left: 1.5em;   
    }
</style>

<script>
export default {
    props: {
        shouldShowReorderButton: {
            type: Boolean,
            required: true,
        },
        isReordering: {
            type: Boolean,
            required: true,
        },
        isListReordered: {
            type: Boolean,
            required: true,
        },
        reorderButtonAction: {
            type: Function,
            required: true,
        },
        saveOrder: {
            type: Function,
            required: true,
        },
    },
    computed: {
        reorderButtonCssClass(){
            return {
                'btn-outline-primary': !this.isReordering, 
                'btn-outline-secondary': this.isReordering,
            };
        },
        reorderButtonText(){
            return this.isReordering ? 'Cancel' : 'Reorder';
        },
    },
};
</script>