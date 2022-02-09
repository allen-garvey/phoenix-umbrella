<template>
    <ul :class="thumbnailListClass">
        <li 
            v-for="(item, i) in items" 
            :key="i" 
            :class="thumbnailItemClass(i)"
            @click="onThumbnailItemClicked(item, i, $event)" 
            :draggable="isReordering" 
            @dragstart="itemDragStart(i)" 
            @dragover="itemDragOver(i, $event)"
            @mouseenter="onItemHovered(item, $event)"
            @mouseleave="onItemHoveredEnd"
        >
            <div 
                :class="$style['thumbnail-image-container']" 
                v-if="isLinkDisabled"
            >
                <img 
                    :alt="altTextFor(item)" 
                    :src="thumbnailUrlFor(item)" 
                    :class="thumbnailImageClass(item)"
                    :draggable="!isReordering"
                    loading="lazy"
                />
            </div>
            <router-link 
                :to="showRouteFor(item, model)" 
                :class="$style['thumbnail-image-container']" 
                :event="thumbnailLinkEvent" 
                :draggable="!isReordering"
                v-else
            >
                <img 
                    :alt="altTextFor(item)" 
                    :src="thumbnailUrlFor(item)" 
                    :class="thumbnailImageClass(item)"
                    :draggable="!isReordering"
                    loading="lazy"
                />
            </router-link>
            <h3 
                :class="thumbnailTitleClass(item)" 
                :draggable="!isReordering"
            >
                <span
                    v-if="isLinkDisabled"
                >
                    <item-title :title="titleFor(item)" :itemsCount="item.items_count" />
                </span>
                <router-link 
                    :to="showRouteFor(item, model)" 
                    :event="thumbnailLinkEvent" 
                    :draggable="!isReordering"
                    v-else
                >
                    <item-title :title="titleFor(item)" :itemsCount="item.items_count" />
                </router-link>
                <heart 
                    v-if="isThumbnailFavorited(item)" 
                    :draggable="!isReordering">
                </heart>
            </h3>
        </li>
    </ul>
</template>

<style lang="scss" module>
    @import '~photog-styles/site/variables';
    $thumbnail_dimensions: 205px;

    .thumbnail-list{
        display: grid;
        grid-template-columns: repeat(auto-fill, 205px);
        grid-gap: 20px;

        li{
            flex-basis: $thumbnail_dimensions;
            margin-bottom: 25px;
        }

        &.batch-select li{
            opacity: 0.65;
            cursor: pointer;
            &:hover{
                opacity: 1;
            }
            border: 6px solid transparent;
            border-radius: 5px;

            &.batch-selected{
                border-color: $photog_selected_highlight_color;
                background-color: $photog_selected_highlight_color;
                color: white;
                opacity: 1;
            }
        }
        &.reordering li{
            border: 6px solid transparent;
            border-radius: 5px;

            &.reorder-select{
                border-color: $photog_selected_reorder_color;
                background-color: $photog_selected_reorder_color;
            }
        }
    }

    .thumbnail-image-container{
        position: relative; //for image hearts

        img{
            height: $thumbnail_dimensions;
            width: $thumbnail_dimensions;
            border-radius: 10px;
            object-fit: cover;
            transition: height 0.3s 0.15s ease-in;

            &.cover-image{
                border: 4px solid magenta;
            }
        }
    }
    .thumbnail-title{
        display: flex;
        justify-content: space-between;
        align-items: baseline;
        min-height: 2em;
        font-weight: normal;
        margin: 8px 0 0;
        font-size: 1.125rem;

        a{
            color: black;
        }

        &.thumbnail-title-favorite{
            a{
                color: $photog_selected_highlight_color;
            }
        }

        &.default-title{
            font-size: 0.98rem;
        }
    }
</style>

<script>
import { thumbnailUrlFor } from '../../../image.js';
import heart from './heart.vue';
import itemTitle from './item-title.vue';

export default {
    props: {
        items: {
            type: Array,
            required: true,
        },
        model: {
            //type can be Array or Object
            type: [Object, Array],
            default: () => [],
        },
        showRouteFor: {
            type: Function,
            required: true,
        },
        batchSelectedItems: {
            type: Array,
            default: () => [],
        },
        onThumbnailItemClicked: {
            type: Function,
            default: () => {},
        },
        itemDragStart: {
            type: Function,
            default: () => {},
        },
        itemDragOver: {
            type: Function,
            default: () => {},
        },
        currentDragIndex: {
            type: Number,
            default: -1,
        },
        isReordering: {
            type: Boolean,
            default: false,
        },
        isCurrentlyBatchSelect: {
            type: Boolean,
            default: false,
        },
    },
    components: {
        heart,
        itemTitle,
    },
    computed: {
        thumbnailListClass(){
            return {
                [this.$style['thumbnail-list']]: true,
                [this.$style['batch-select']]: this.isCurrentlyBatchSelect, 
                [this.$style['reordering']]: this.isReordering,
            };
        },
        isLinkDisabled(){
            return this.isCurrentlyBatchSelect || this.isReordering;
        },
        thumbnailLinkEvent(){
            return this.isLinkDisabled ? '' : 'click';
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
            return !!item.is_favorite;
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
                [this.$style['cover-image']]: !this.isCurrentlyBatchSelect && this.isThumbnailCoverImage(item)
            };
        },
        thumbnailItemClass(i){
            return {
                [this.$style['batch-selected']]: this.isCurrentlyBatchSelect && this.batchSelectedItems[i], 
                [this.$style['reorder-select']]: this.isReordering && this.currentDragIndex === i, 
            };
        },
        thumbnailTitleClass(item){
            return {
                [this.$style['thumbnail-title']]: true,
                [this.$style['default-title']]: !('name' in item), 
                [this.$style['thumbnail-title-favorite']]: this.isThumbnailFavorited(item),
            };
        },
        onItemHovered(item, $event){
            this.$emit('itemHover', {item, $event});
        },
        onItemHoveredEnd(){
            this.$emit('itemHoverEnd');
        },
    }
};
</script>