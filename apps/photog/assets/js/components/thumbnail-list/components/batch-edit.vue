<template>
    <div class="thumbnail-batch-select-container" :class="{invisible: isReordering}">
        <button
            :class="toggleBatchEditButtonClass" 
            @click="toggleBatchSelect"
        >
            {{isCurrentlyBatchSelect ? 'Cancel' : 'Batch edit'}}
        </button>
        <button 
            class="btn btn-outline-primary" 
            @click="batchSelectAll" 
            v-if="isCurrentlyBatchSelect">
            {{anyItemsBatchSelected ? 'Deselect all' : 'Select all'}}
        </button>
        <!-- 
        * Batch edit controls when in batch edit mode
        -->
        <div 
            class="resource-buttons-container" 
            v-if="isCurrentlyBatchSelect"
        >
            <div v-if="enableBatchSelectImages" class="btn-group">
                <button class="btn btn-primary" 
                    @click="setBatchResourceMode(1)" 
                    :class="buttonClassForResourceMode(1)">
                    Add Albums
                </button>
                <button 
                    class="btn btn-primary" 
                    @click="setBatchResourceMode(2)" 
                    :class="buttonClassForResourceMode(2)"
                >
                    Add Persons
                </button>
                <button 
                    class="btn btn-outline-primary" 
                    @click="createResourceWithImages('albumsNew')" :disabled="!anyItemsBatchSelected"
                >
                    Create Album
                </button>
                <button 
                    class="btn btn-outline-primary" 
                    @click="createResourceWithImages('personsNew')" :disabled="!anyItemsBatchSelected"
                >
                    Create Person
                </button>
            </div>
            <button 
                class="btn btn-primary" 
                @click="setBatchResourceMode(3)" 
                :class="buttonClassForResourceMode(3)" 
                v-if="enableBatchSelectAlbums"
            >
                Add Tags
            </button>
        </div>  
        <!-- 
            * List of batch edit resources that can be added to selected items
        -->
        <div v-if="shouldShowBatchResources">
            <ul class="batch-resources-list">
                <li 
                    v-for="(resource, index) in batchResourcesDisplayed" 
                    :key="resource.id"
                >
                    <input 
                        type="checkbox" 
                        :id="idForBatchResource(resource, index)" v-model="batchResourcesSelected[index]" 
                    />
                    <label 
                        :for="idForBatchResource(resource, index)">
                        {{resource.name}}
                    </label>
                </li>
            </ul>
            <button 
                class="btn btn-outline-dark" 
                v-if="batchResources.length > batchResourcesMoreLimit" @click="toggleDisplayMoreBatchResources"
            >
                {{batchResourcesDisplayed.length < batchResources.length ? 'Show more' : 'Show less'}}
            </button>
            <button 
                class="btn btn-success" 
                :disabled="!anyBatchResourcesSelected || !anyItemsBatchSelected"
                @click="saveBatchSelected(batchResourcesSelected)"
            >
                Save
            </button>
        </div>
    </div>
</template>

<script>
export default {
    props: {
        isCurrentlyBatchSelect: {
            type: Boolean,
            required: true,
        },   
        isReordering: {
            type: Boolean,
            required: true,
        },
        toggleBatchSelect: {
            type: Function,
            required: true,
        },
        batchSelectAll: {
            type: Function,
            required: true,
        },
        enableBatchSelectImages: {
            type: Boolean,
            required: true,
        },
        enableBatchSelectAlbums: {
            type: Boolean,
            required: true,
        },
        batchSelectResourceMode: {
            type: Number,
            required: true,
        },
        setBatchResourceMode: {
            type: Function,
            required: true,
        },
        createResourceWithImages: {
            type: Function,
            required: true,
        },
        batchResources: {
            type: Array,
            required: true,
        },
        saveBatchSelected: {
            type: Function,
            required: true,
        },
        anyItemsBatchSelected: {
            type: Boolean,
            required: true,
        },
    },
    computed: {
        anyBatchResourcesSelected(){
            return this.batchResourcesSelected.some((isSelected)=>isSelected);
        },
        toggleBatchEditButtonClass(){
            return {
                'btn': true,
                'btn-outline-primary' : !this.isCurrentlyBatchSelect, 
                'btn-outline-secondary': this.isCurrentlyBatchSelect,
            };
        },
        shouldShowBatchResources(){
            // TODO, pass in batch resource mode constants as prop or import as module
            // return this.batchSelectResourceMode !== BATCH_RESOURCE_MODE_NONE;
            return this.batchSelectResourceMode !== 0;
        },
        batchResourcesDisplayed(){
            if(this.shouldShowAllBatchResources){
                return this.batchResources;
            }
            return this.batchResources.slice(0, this.batchResourcesMoreLimit);
        },
    },
    watch: {
        //called when model changes
        batchResources(newValue){
            this.shouldShowAllBatchResources = false;
            this.batchResourcesSelected = this.batchResources.map(()=>false);
        },
    },
    data(){
        return {
            shouldShowAllBatchResources: false,
            batchResourcesMoreLimit: 8,
            batchResourcesSelected: [],
        };
    },
    methods: {
        idForBatchResource(item, index){
            return `batch_resource_id_${item.id}_${index}`;
        },
        buttonClassForResourceMode(resourceMode){
            return resourceMode === this.batchSelectResourceMode ? 'btn-primary' : 'btn-secondary';
        },
        toggleDisplayMoreBatchResources(){
            this.shouldShowAllBatchResources = !this.shouldShowAllBatchResources;
        },
    }
};
</script>