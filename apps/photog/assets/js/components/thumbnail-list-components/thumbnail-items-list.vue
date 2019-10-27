<template>
    <ul class="thumbnail-list" :class="thumbnailListClass">
        <li 
            v-for="(item, i) in items" 
            :key="i" 
            :class="thumbnailItemClass(i)"
            @click="batchSelectItem(item, i, $event)" 
            :draggable="isReordering" 
            @dragstart="itemDragStart(i)" 
            @dragover="itemDragOver(i, $event)"
        >
            <router-link 
                :to="showRouteFor(item, model)" 
                class="thumbnail-image-container" 
                :event="thumbnailLinkEvent" 
                :tag="isCurrentlyBatchSelect || isReordering ? 'div' : 'a'" :draggable="!isReordering"
            >
                <img 
                    :alt="altTextFor(item)" 
                    :src="thumbnailUrlFor(item)" 
                    :class="thumbnailImageClass(item)"
                    :draggable="!isReordering"
                />
            </router-link>
            <h3 
                :class="thumbnailTitleClass(item)" 
                :draggable="!isReordering"
            >
                <router-link 
                    :to="showRouteFor(item, model)" 
                    :event="thumbnailLinkEvent" 
                    :tag="isCurrentlyBatchSelect || isReordering ? 'span' : 'a'" :draggable="!isReordering">
                        {{titleFor(item)}}
                </router-link>
                <div 
                    v-if="isThumbnailFavorited(item)" 
                    class="heart" 
                    :draggable="!isReordering">
                </div>
            </h3>
        </li>
    </ul>
</template>

<script>
import { thumbnailUrlFor } from '../../image.js';

export default {
    props: {
        items: {
            type: Array,
            required: true,
        },
        model: {
            //type can be Array or Object
            type: [Object, Array],
            required: true,
        },
        showRouteFor: {
            type: Function,
            required: true,
        },
        batchSelectedItems: {
            type: Array,
            required: true,
        },
        batchSelectItem: {
            type: Function,
            required: true,
        },
        itemDragStart: {
            type: Function,
            required: true,
        },
        itemDragOver: {
            type: Function,
            required: true,
        },
        currentDragIndex: {
            type: Number,
            required: true,
        },
        thumbnailLinkEvent: {
            type: String,
            required: true,
        },
        isReordering: {
            type: Boolean,
            required: true,
        },
        isCurrentlyBatchSelect: {
            type: Boolean,
            required: true,
        },
        showDetailHover: {
            type: Boolean,
            default: false,
        },
    },
    computed: {
        thumbnailListClass(){
            return {
                'batch-select': this.isCurrentlyBatchSelect, 
                'reordering': this.isReordering,
            };
        },
    },
    methods: {
        altTextFor(item){
            if('name' in item){
                return `Thumbnail for ${item.name}`;
            }
            return `Thumbnail for image taken on ${item.creation_time.formatted.us_date}`;
        },
        titleFor(item){
            if('name' in item){
                return item.name;
            }
            return `${item.creation_time.formatted.us_date} ${item.creation_time.formatted.time}`;
        },
        imageFor(item){
            if('cover_image' in item){
                return item.cover_image;
            }
            return item;
        },
        isThumbnailFavorited(item){
            //don't show favorite heart for cover image
            if('cover_image' in item){
                return false;
            }
            return this.imageFor(item).is_favorite;
        },
        isThumbnailCoverImage(item){
            if(!('cover_image' in this.model)){
                return false;
            }
            return this.imageFor(item).id === this.model.cover_image.id;
        },
        thumbnailUrlFor(item){
            const image = this.imageFor(item);
            if(image){
                return thumbnailUrlFor(image.mini_thumbnail_path);
            }
            return '';
        },
        thumbnailImageClass(item){
            return {
                'cover-image': !this.isCurrentlyBatchSelect && this.isThumbnailCoverImage(item)
            };
        },
        thumbnailItemClass(i){
            return {
                'batch-selected': this.isCurrentlyBatchSelect && this.batchSelectedItems[i], 'reorder-select': this.isReordering && this.currentDragIndex === i, 
                'hover-detail': this.showDetailHover && this.isInThumbnailDefaultMode,
            };
        },
        thumbnailTitleClass(item){
            return {
                'thumbnail-title': true,
                'default-title': !('name' in item), 
                'thumbnail-title-favorite': this.isThumbnailFavorited(item),
            };
        },
    }
};
</script>