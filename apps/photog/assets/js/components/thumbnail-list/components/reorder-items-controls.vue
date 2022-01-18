<template>
    <div :class="$style.container">
        <div>
            <button class="btn" :class="reorderButtonCssClass" v-show="shouldShowReorderButton" @click="reorderButtonAction()">
                {{reorderButtonText}}
            </button>
            <button class="btn btn-success" v-show="isReordering && isListReordered" @click="saveOrder()">
                Save order
            </button>
        </div>
        <div>
            <button 
                class="btn btn-outline-warning"  
                @click="$emit('reorder-by-sort')"
                v-if="enableReorderBySort && isReordering"
            >
                Sort
            </button>
        </div>
        
    </div>
</template>

<style lang="scss" module>
    .container{
        display: flex;
        justify-content: space-between;
        flex-grow: 1;
        margin-left: 1.5em;
        min-width: 255px;
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
        enableReorderBySort: {
            type: Boolean,
            default: false,
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