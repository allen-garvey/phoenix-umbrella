<template>
    <div :class="{invisible: isReordering, [$style['thumbnail-batch-select-container']]: true}">
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
            :class="$style['resource-buttons-container']" 
            v-if="isCurrentlyBatchSelect"
        >
            <div v-if="enableBatchSelectImages" class="btn-group">
                <button class="btn btn-primary" 
                    @click="setBatchResourceMode(batchEditResourceMode.ALBUMS)" 
                    :class="buttonClassForResourceMode(batchEditResourceMode.ALBUMS)">
                    Add Albums
                </button>
                <button 
                    class="btn btn-primary" 
                    @click="setBatchResourceMode(batchEditResourceMode.PERSONS)" 
                    :class="buttonClassForResourceMode(batchEditResourceMode.PERSONS)"
                >
                    Add Persons
                </button>
                <button 
                    class="btn btn-outline-primary" 
                    @click="createResourceWithImages('albumsNew')" 
                    :disabled="!anyItemsBatchSelected"
                >
                    Create Album
                </button>
                <button 
                    class="btn btn-outline-primary" 
                    @click="createResourceWithImages('personsNew')" 
                    :disabled="!anyItemsBatchSelected"
                >
                    Create Person
                </button>
            </div>
            <button 
                class="btn btn-danger" 
                @click="$emit('remove-items')"
                :disabled="!anyItemsBatchSelected"
                v-if="enableRemoveItems"
            >
                Remove items
            </button>
            <button 
                class="btn btn-primary" 
                @click="setBatchResourceMode(batchEditResourceMode.TAGS)" 
                :class="buttonClassForResourceMode(batchEditResourceMode.TAGS)" 
                v-if="enableBatchSelectAlbums"
            >
                Add Tags
            </button>
        </div>  
        <!-- 
            * List of batch edit resources that can be added to selected items
        -->
        <div v-if="shouldShowBatchResources">
            <label>Search <input class="form-control" v-model="searchValue" /></label>
            <ul :class="$style['batch-resources-list']">
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
                v-if="!isSearchEnabled && batchResources.length > batchResourcesMoreLimit" @click="toggleDisplayMoreBatchResources"
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

<style lang="scss" module>
    .batch-resources-list{
        display: flex;
        flex-wrap: wrap;
        margin-top: 1em;

        li{
            flex-basis: 25%;
            margin-bottom: 0.5em;
        }
    }
    .thumbnail-batch-select-container{
        display: inline-block;
        margin-bottom: 1em;
        width: 100%;
        
        .resource-buttons-container{
            width: 100%;
            display: flex;
            justify-content: space-between;
            margin-top: 1em;
        }
    }
</style>

<script>
import { BATCH_EDIT_RESOURCE_MODE } from '../constants/batch-edit.js';

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
        enableRemoveItems: {
            type: Boolean,
            default: false,
        },
    },
    computed: {
        batchEditResourceMode(){
            return BATCH_EDIT_RESOURCE_MODE;
        },
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
            return this.batchSelectResourceMode !== this.batchEditResourceMode.NONE;
        },
        isSearchEnabled(){
            return this.searchValue.length >= 2;
        },
        batchResourcesDisplayed(){
            if(this.isSearchEnabled){
                return this.batchResources
                    .filter(
                        ({ name }) => name.toLowerCase().indexOf(this.searchValue.toLowerCase()) >= 0
                );
            }
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
            searchValue: '',
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