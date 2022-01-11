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
                v-show="isReordering"
                @click="reorderByDate()"
            >
                Order by date
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
        reorderByDate: {
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