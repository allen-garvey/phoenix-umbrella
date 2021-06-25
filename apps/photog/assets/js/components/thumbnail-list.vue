<template>
    <main class="main container" :class="$style.container">
        <!-- 
            * Header
        -->
        <Resource-Header 
            :title="titleForPage" 
            :editItemLink="editItemLink"
            :shouldShowDelete="isDeleteEnabled && thumbnailList.length === 0 && isInitialLoadComplete"
            @triggerDelete="triggerDelete" 
            :newItemLink="newItemLink" 
            :previousPageLink="previousPageLink"
            :nextPageLink="nextPageLink"
            :description="model.description" 
            :count="filteredThumbnailList.length"
        />

        <!-- 
            * Related fields list
        -->
        <Related-Fields-List :items="model[relatedFieldsKey]" :routeName="`${relatedFieldsKey}Show`" v-if="relatedFieldsKey && isInitialLoadComplete" />
        
        <!-- 
            * Filtering controls 
        -->
        <Thumbnail-Filter-Controls 
            :class="{invisible: isCurrentlyBatchSelect || isReordering}" :enableAlbumFilter="enableHasAlbumFilter" 
            :enablePersonFilter="enableHasPersonFilter" 
            v-model:albumFilterMode="albumFilterMode" 
            v-model:personFilterMode="personFilterMode"
        />

        <!-- 
            * Batch edit controls 
        -->
        <batch-edit
            :isCurrentlyBatchSelect="isCurrentlyBatchSelect"
            :isReordering="isReordering"
            :toggleBatchSelect="toggleBatchSelect"
            :batchSelectAll="batchSelectAll"
            :enableBatchSelectImages="enableBatchSelectImages"
            :enableBatchSelectAlbums="enableBatchSelectAlbums"
            :batchSelectResourceMode="batchSelectResourceMode"
            :setBatchResourceMode="setBatchResourceMode"
            :createResourceWithImages="createResourceWithImages"
            :batchResources="batchResources"
            :saveBatchSelected="saveBatchSelected"
            :anyItemsBatchSelected="anyItemsBatchSelected"
            v-if="supportsBatchSelect"
        >
        </batch-edit>
        <!-- 
            * Reorder items controls 
        -->
        <reorder-items-controls
            :shouldShowReorderButton="shouldShowReorderButton"
            :isListReordered="isListReordered"
            :isReordering="isReordering"
            :reorderButtonAction="reorderButtonAction"
            :saveOrder="saveOrder"
            v-if="supportsReorder"
        >
        </reorder-items-controls>
        <image-preview 
            v-if="hoveredItem"
            :item="hoveredItem"
            :mousePosition="hoveredItemEvent"
            :contentCallback="itemPreviewContentCallback"
        />
        
        <thumbnail-items-list
            :items="filteredThumbnailList"
            :model="model"
            :showRouteFor="showRouteFor"
            :batchSelectedItems="batchSelectedItems"
            :batchSelectItem="batchSelectItem"
            :itemDragStart="itemDragStart"
            :itemDragOver="itemDragOver"
            :currentDragIndex="currentDragIndex"
            :thumbnailLinkEvent="thumbnailLinkEvent"
            :isReordering="isReordering"
            :isCurrentlyBatchSelect="isCurrentlyBatchSelect"
            @itemHover="onItemHovered"
            @itemHoverEnd="onItemHoveredEnd"
        >
        </thumbnail-items-list>
    </main>
</template>

<style lang="scss" module>
    .container {
        position: relative;
    }

</style>

<script>
import ResourceHeader from './resource-header.vue';
import ThumbnailFilterControls from './thumbnail-filter-controls.vue';
import RelatedFieldsList from './related-fields-list.vue';
import BatchEdit from './thumbnail-list/components/batch-edit.vue';
import ReorderItemsControls from './thumbnail-list/components/reorder-items-controls.vue';
import ThumbnailItemsList from './thumbnail-list/components/thumbnail-items-list.vue';
import ImagePreview from './thumbnail-list/components/image-preview.vue';

import { API_URL_BASE } from '../request-helpers.js';

//thumbnail filtering
const PERSON_FILTER_MODE_ALL = 1;
const PERSON_FILTER_MODE_NO_PERSONS = 2;
const PERSON_FILTER_MODE_HAS_PERSONS = 3;

const ALBUM_FILTER_MODE_ALL = 1;
const ALBUM_FILTER_MODE_NO_ALBUMS = 2;
const ALBUM_FILTER_MODE_HAS_ALBUMS = 3;

//thumbnail batch select
import { BATCH_EDIT_RESOURCE_MODE } from './thumbnail-list/constants/batch-edit.js';
import { ALBUM_FILTER_QUERY_PARAM_NAME, PERSON_FILTER_QUERY_PARAM_NAME } from '../routes-helpers.js';

export default {
    name: 'Thumbnail-List',
    props: {
        setWindowTitle: {
            type: Function,
            required: true,
        },
        putFlash: {
            type: Function,
            required: true,
        },
        sendJson: {
            type: Function,
            required: true,
        },
        getModel: {
            type: Function,
            required: true,
        },
        apiPath: {
            type: String,
            required: true,
        },
        showRouteFor: {
            type: Function,
            required: true,
        },
        itemsListKey: {
            type: String,
        },
        newItemLink: {
            type: Object,
        },
        editItemLink: {
            type: Object,
        },
        isDeleteEnabled: {
            type: Boolean,
            default: false,
        },
        pageTitle: {
            type: String,
        },
        enableHasAlbumFilter: {
            type: Boolean,
            default: false,
        },
        enableHasPersonFilter: {
            type: Boolean,
            default: false,
        },
        //batchSelectImages and batchSelectAlbums
        //are mutually exclusive
        enableBatchSelectImages: {
            type: Boolean,
            default: false,
        },
        enableBatchSelectAlbums: {
            type: Boolean,
            default: false,
        },
        reorderPathSuffix: {
            type: String,
        },
        reorderItemsKey: {
            type: String,
        },
        relatedFieldsKey: {
            type: String,
            default: null,
        },
        itemPreviewContentCallback: {
            type: Function,
            default: null,
        },
        previousPageLink: {
            type: Object,
        },
        nextPageLink: {
            type: Object,
        },
    },
    components: {
        ResourceHeader,
        ThumbnailFilterControls,
        RelatedFieldsList,
        ReorderItemsControls,
        BatchEdit,
        ThumbnailItemsList,
        ImagePreview,
    },
    data() {
        return {
            isInitialLoadComplete: false,
            model: [],
            thumbnailList: [],
            albumFilterMode: ALBUM_FILTER_MODE_ALL,
            personFilterMode: PERSON_FILTER_MODE_ALL,
            //following used for batch select multiple items
            isCurrentlyBatchSelect: false,
            batchSelectedItems: [], //thumbnails selected in batch select mode
            previouslySelectedBatchItemIndex: 0, //last thumbnail selected in batch select mode
            batchResources: [], //the resources (albums, persons) that can be added to thumbnails in batch select mode
            batchSelectResourceMode: BATCH_EDIT_RESOURCE_MODE.NONE,
            //following for reordering resources
            isReordering: false,
            isListReordered: false,
            reorderedThumbnailList: [],
            currentDragIndex: -1,
            hoveredItem: null,
            hoveredItemEvent: null,
            hoveredEventTimout: null,
        }
    },
    computed: {
        titleForPage(){
            if(!this.isInitialLoadComplete){
                return '';
            }
            return this.pageTitle ? this.pageTitle : this.model.name;
        },
        thumnailListSource(){
            //this might happen when vue changed but model not yet loaded
            if(this.itemsListKey && !this.model[this.itemsListKey]){
                return [];
            }
            if(this.itemsListKey){
                return this.model[this.itemsListKey];
            }
            return this.model;

        },
        filteredThumbnailList(){
            if(this.isReordering){
                return this.reorderedThumbnailList;
            }
            return this.thumbnailList.filter((item)=>{
                return this.shouldShowItem(item);
            });
        },
        thumbnailListSelectedItems(){
            return this.filteredThumbnailList.filter((item, i) => this.batchSelectedItems[i]);
        },
        //so thumbnail links are disabled when we are in batch select mode
        thumbnailLinkEvent(){
            return !this.isInThumbnailDefaultMode ? '' : 'click';
        },
        isInThumbnailDefaultMode(){
            return !this.isCurrentlyBatchSelect && !this.isReordering;
        },
        anyItemsBatchSelected(){
            return this.batchSelectedItems.some((isSelected)=>isSelected);
        },
        supportsBatchSelect(){
            return (this.enableBatchSelectImages || this.enableBatchSelectAlbums) && this.filteredThumbnailList.length > 0;
        },
        /**
         * Reordering stuff
         */
        supportsReorder(){
            return this.reorderPathSuffix && this.reorderItemsKey;
        },
        shouldShowReorderButton(){
            return this.supportsReorder && !this.isCurrentlyBatchSelect && this.albumFilterMode === ALBUM_FILTER_MODE_ALL && this.personFilterMode === PERSON_FILTER_MODE_ALL && this.filteredThumbnailList.length > 1;
        },
    },
    created(){
        this.setup();
    },
    watch: {
        // changes when route changes, and is for some reason faster
        // than watching the route
        apiPath(){
            this.setup();
        },
    },
    methods: {
        setup(){
            const queryParams = this.$router.currentRoute._rawValue.query;
            const albumFilterQueryParam = parseInt(queryParams[ALBUM_FILTER_QUERY_PARAM_NAME]);
            const personFilterQueryParam = parseInt(queryParams[PERSON_FILTER_QUERY_PARAM_NAME]);

            this.isInitialLoadComplete = false;
            this.model = [];
            this.albumFilterMode = !isNaN(albumFilterQueryParam) ? albumFilterQueryParam : ALBUM_FILTER_MODE_ALL;
            this.personFilterMode = !isNaN(personFilterQueryParam) ? personFilterQueryParam : PERSON_FILTER_MODE_ALL;
            this.isCurrentlyBatchSelect = false;
            this.batchSelectedItems = [];
            this.previouslySelectedBatchItemIndex = 0;
            this.batchResources = [];
            this.batchSelectResourceMode = BATCH_EDIT_RESOURCE_MODE.NONE;
            this.shouldShowAllBatchResources = false;
            this.hoveredItem = null;
            this.hoveredItemEvent = null;
            clearTimeout(this.hoveredEventTimout);
            
            this.loadModel().then(()=>{
                this.isInitialLoadComplete = true;
                this.setWindowTitle(this.titleForPage);
            });
        },
        loadModel(){
            this.thumbnailList = [];
            return this.getModel(this.apiPath).then((items)=>{
                this.modelLoaded(items);
            });
        },
        modelLoaded(items){
            this.model = items;
            this.thumbnailList = this.thumnailListSource.slice();
        },
        refreshModel(){
            return this.getModel(this.apiPath, true).then((items)=>{
                this.modelLoaded(items);
            });
        },
        shouldShowItem(item){
            let albumValidation = true;
            if(this.albumFilterMode == ALBUM_FILTER_MODE_NO_ALBUMS){
                albumValidation = !item.albums || item.albums.length === 0;
            }
            else if(this.albumFilterMode == ALBUM_FILTER_MODE_HAS_ALBUMS){
                albumValidation = item.albums && item.albums.length > 0;
            }

            let personValidation = true;
            if(this.personFilterMode == PERSON_FILTER_MODE_NO_PERSONS){
                personValidation = !item.persons || item.persons.length === 0;
            }
            else if(this.personFilterMode == PERSON_FILTER_MODE_HAS_PERSONS){
                personValidation = item.persons && item.persons.length > 0;
            }

            return albumValidation && personValidation;
        },
        toggleBatchSelect(){
            this.isCurrentlyBatchSelect = !this.isCurrentlyBatchSelect;
            this.batchSelectResourceMode = BATCH_EDIT_RESOURCE_MODE.NONE;
            if(this.isCurrentlyBatchSelect){
                this.batchSelectedItems = this.filteredThumbnailList.map(()=>false);
                this.previouslySelectedBatchItemIndex = 0;
            }
        },
        batchSelectItem(item, i, event){
            if(!this.isCurrentlyBatchSelect){
                return;
            }
            //if shift key is enabled, select all in range
            if(event.shiftKey){
                let startIndex = this.previouslySelectedBatchItemIndex;
                let endIndex = i;
                if(startIndex > endIndex){
                    const temp = startIndex;
                    startIndex = endIndex;
                    endIndex = temp;
                }
                //for loop is inclusive
                for(let index=startIndex;index<=endIndex;index++){
                    this.batchSelectedItems[index] = true;
                }
            }
            else{
                this.batchSelectedItems[i] = !this.batchSelectedItems[i];
            }
            this.previouslySelectedBatchItemIndex = i;
        },
        batchSelectAll(){
            const anySelected = this.anyItemsBatchSelected;
            this.batchSelectedItems = this.batchSelectedItems.map((isSelected)=>!anySelected);
        },
        setBatchResourceMode(newResourceMode){
            if(this.batchSelectResourceMode === newResourceMode){
                return;
            }
            this.batchSelectResourceMode = newResourceMode;
            if(newResourceMode === BATCH_EDIT_RESOURCE_MODE.NONE){
                return;
            }
            let apiUrl = '/albums?excerpt=true';
            if(newResourceMode === BATCH_EDIT_RESOURCE_MODE.PERSONS){
                apiUrl = '/persons?excerpt=true';
            }
            else if(newResourceMode === BATCH_EDIT_RESOURCE_MODE.TAGS){
                //no need for tags excerpt, since tags already only returns name and id
                apiUrl = '/tags?sort=newest';
            }

            this.getModel(apiUrl).then((data)=>{
                this.batchResources = data;
            });

        },
        saveBatchSelected(batchResourcesSelected){
            //default is album_images
            let apiUrl = `${API_URL_BASE}/album_images`;
            let resourcesKey = 'album_ids';
            let thumbnailsKey = 'image_ids';

            if(this.batchSelectResourceMode === BATCH_EDIT_RESOURCE_MODE.PERSONS){
                apiUrl = `${API_URL_BASE}/person_images`;
                resourcesKey = 'person_ids';
            }
            else if(this.batchSelectResourceMode === BATCH_EDIT_RESOURCE_MODE.TAGS){
                apiUrl = `${API_URL_BASE}/album_tags`;
                resourcesKey = 'tag_ids';
                thumbnailsKey = 'album_ids';
            }
            const data = {};
            data[thumbnailsKey] = this.thumbnailListSelectedItems.map((item)=>item.id);
            data[resourcesKey] = this.batchResources.filter((item, i)=>batchResourcesSelected[i]).map((item)=>item.id);

            this.sendJson(apiUrl, 'POST', data).then((response)=>{
                const hasAtLeastOneThingSucceeded = response.data && response.data.length > 0;
                const hasErrors = response.error && response.error.length > 0;
                //don't do anything unless at 1 thing succeeded
                if(hasAtLeastOneThingSucceeded){
                    this.toggleBatchSelect();
                    //model has to be refreshed or image details pages will show old data
                    this.refreshModel();
                }
                //show flash message based on results
                if(hasAtLeastOneThingSucceeded && hasErrors){
                    this.putFlash('Some updates succeeded and some failed', 'warning');
                }
                else if(hasAtLeastOneThingSucceeded){
                    this.putFlash('All updates successful', 'info');
                }
                else{
                    this.putFlash('All updates failed', 'danger');
                }

            });
        },
        createResourceWithImages(pathName){
            const selectedImages = this.thumbnailListSelectedItems.map(image => ({id: image.id, mini_thumbnail_path: image.mini_thumbnail_path}));
            this.$router.push({
                name: pathName, 
                params: {
                    images: JSON.stringify(selectedImages), 
                    successRedirect: '1'
                    }
            });
        },
        triggerDelete(){
            if(confirm('Sure you want to delete?')){
                const apiUrl = `${API_URL_BASE}${this.apiPath}`;
                const indexRouteName = this.$router.currentRoute._rawValue.name.replace(/Show$/, 'Index');

                this.sendJson(apiUrl, 'DELETE').then(() => 
                    this.$router.push({
                        name: indexRouteName
                    })
                );
            }
        },
        /**
         * Reordering resources
         */
        reorderButtonAction(){
            if(!this.isReordering){
                this.isListReordered = false;
                this.reorderedThumbnailList = this.thumbnailList.slice();
                this.currentDragIndex = -1;
                this.isReordering = true;
            }
            else{
                //when reordering is false, list is automatically put back in original order
                this.reorderedThumbnailList = [];
                this.isReordering = false;
            }
        },
        saveOrder(){
            const url = `${API_URL_BASE}${this.apiPath}${this.reorderPathSuffix}`;
            const data = {};
            data[this.reorderItemsKey] = this.reorderedThumbnailList.map(item=>item.id);
            this.sendJson(url, 'PATCH', data).then((response)=>{
                this.thumbnailList = this.reorderedThumbnailList;
                this.isReordering = false;
            });
        },
        itemDragStart(index){
            this.currentDragIndex = index;
        },
        itemDragOver(index, $event){
            if(this.currentDragIndex === index){
                return;
            }
            $event.target.scrollIntoView({
                behavior: 'smooth',
                block: 'center',
            });
            this.isListReordered = true;
            //reorder array
            //https://stackoverflow.com/questions/5306680/move-an-array-element-from-one-array-position-to-another/6470794
            this.reorderedThumbnailList.splice(index, 0, this.reorderedThumbnailList.splice(this.currentDragIndex, 1)[0]);
            this.currentDragIndex = index;
        },
        onItemHovered({item, $event}){
            if(this.isCurrentlyBatchSelect){
                return;
            }
            clearTimeout(this.hoveredEventTimout);
            this.hoveredEventTimout = setTimeout(() => {
                this.hoveredItem = item;
                this.hoveredItemEvent = $event;
            }, 300);
        },
        onItemHoveredEnd(){
            this.hoveredItem = null;
            this.hoveredItemEvent = null;
            clearTimeout(this.hoveredEventTimout);
        },
        /**
         * Keyboard shortcuts
         */
        onKeyPressed(key){
            switch(key){
                //start reorder
                case 'r':
                    if(!this.isReordering && this.shouldShowReorderButton){
                        this.reorderButtonAction()
                    }
                    break;
                //start batch edit
                case 'b':
                    if(!this.isCurrentlyBatchSelect && this.supportsBatchSelect && !this.isReordering){
                        this.toggleBatchSelect();
                    }
                    break;
                case 'Escape':
                    //cancel reordering
                    if(this.isReordering){
                        this.reorderButtonAction()
                    }
                    //cancel batch select
                    else if(this.isCurrentlyBatchSelect){
                        this.toggleBatchSelect();
                    }
                    break;
            }
        },
    }
}
</script>
