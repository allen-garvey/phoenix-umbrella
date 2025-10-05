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
            <div :class="$style.thumbnailImageContainer" v-if="isLinkDisabled">
                <img
                    :alt="altTextFor(item)"
                    :src="thumbnailUrlFor(item)"
                    :class="thumbnailImageClass(item)"
                    :draggable="!isReordering"
                    loading="lazy"
                    v-if="thumbnailUrlFor(item)"
                />
                <div :class="$style.imagePlaceholder" v-else></div>
            </div>
            <router-link
                :to="showRouteFor(item, model)"
                :class="$style.thumbnailImageContainer"
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
                    v-if="thumbnailUrlFor(item)"
                />
                <div :class="$style.imagePlaceholder" v-else></div>
            </router-link>
            <h3 :class="thumbnailTitleClass(item)" :draggable="!isReordering">
                <span v-if="isLinkDisabled">
                    <item-title
                        :title="titleFor(item)"
                        :itemsCount="item.items_count"
                    />
                </span>
                <router-link
                    :to="showRouteFor(item, model)"
                    :event="thumbnailLinkEvent"
                    :draggable="!isReordering"
                    v-else
                >
                    <item-title
                        :title="titleFor(item)"
                        :itemsCount="item.items_count"
                    />
                </router-link>
                <heart
                    v-if="
                        isThumbnailFavoriteUpdateSupported ||
                        isThumbnailFavorited(item)
                    "
                    :isInteractive="isThumbnailFavoriteUpdateSupported"
                    :checked="isThumbnailFavorited(item)"
                    :draggable="!isReordering"
                    @click="onHeartClicked(item)"
                >
                </heart>
            </h3>
        </li>
    </ul>
</template>

<style lang="scss" module>
@use '~photog-styles/site/variables';
$thumbnail_dimensions: 205px;
$thumbnail_dimensions_big: 287px;

.thumbnailList {
    display: grid;
    grid-template-columns: repeat(auto-fill, $thumbnail_dimensions);
    grid-gap: 20px;

    &.batchSelect li {
        opacity: 0.65;
        cursor: pointer;
        &:hover {
            opacity: 1;
        }
        border: 6px solid transparent;
        border-radius: 5px;

        &.batchSelected {
            border-color: variables.$photog_favorited_color;
            background-color: variables.$photog_favorited_color;
            color: white;
            opacity: 1;
        }
    }
    &.reordering li {
        border: 6px solid transparent;
        border-radius: 5px;

        &.reorderSelect {
            border-color: variables.$photog_selected_reorder_color;
            background-color: variables.$photog_selected_reorder_color;
        }
    }
}

.thumbnailImageContainer {
    position: relative; //for image hearts

    img,
    .imagePlaceholder {
        background-color: gray;
        height: $thumbnail_dimensions;
        width: $thumbnail_dimensions;
        border-radius: 4px;
        object-fit: cover;
        transition: height 0.3s 0.15s ease-in;

        &.coverImage {
            border: 4px solid variables.$photog_cover_image_color;
        }
    }
}
.thumbnailTitle {
    display: flex;
    justify-content: space-between;
    align-items: baseline;
    min-height: 2em;
    font-weight: normal;
    margin: 8px 0 0;
    font-size: 1.125rem;

    a {
        color: black;

        @media (prefers-color-scheme: dark) {
            & {
                color: #fff;
            }
        }
    }

    &.thumbnailTitleFavorite {
        a {
            color: variables.$photog_favorited_color;
        }
    }

    &.defaultTitle {
        font-size: 0.98rem;
    }
}

.big.thumbnailList {
    grid-template-columns: repeat(auto-fill, $thumbnail_dimensions_big);

    .thumbnailImageContainer {
        img {
            height: $thumbnail_dimensions_big;
            width: $thumbnail_dimensions_big;
        }
    }
}
</style>

<script>
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
        selectedItemsToBatchReorder: {
            type: Object,
            default: () => ({}),
        },
        isCurrentlyBatchSelect: {
            type: Boolean,
            default: false,
        },
        miniThumbnailUrlFor: {
            type: Function,
            required: true,
        },
        useBigThumbnails: {
            type: Boolean,
            default: false,
        },
        updateItemFavorite: {
            type: Function,
        },
    },
    components: {
        heart,
        itemTitle,
    },
    computed: {
        thumbnailListClass() {
            return {
                [this.$style.thumbnailList]: true,
                [this.$style.batchSelect]: this.isCurrentlyBatchSelect,
                [this.$style.reordering]: this.isReordering,
                [this.$style.big]: this.useBigThumbnails,
            };
        },
        isLinkDisabled() {
            return this.isCurrentlyBatchSelect || this.isReordering;
        },
        thumbnailLinkEvent() {
            return this.isLinkDisabled ? '' : 'click';
        },
        isThumbnailFavoriteUpdateSupported() {
            return !!this.updateItemFavorite;
        },
    },
    methods: {
        altTextFor(item) {
            if ('name' in item) {
                return `Thumbnail for ${item.name}`;
            }
            return `Thumbnail for image taken on ${item.creation_time.formatted.us_date}`;
        },
        titleFor(item) {
            if ('name' in item) {
                return item.name;
            }
            return `${item.creation_time.formatted.us_date} ${item.creation_time.formatted.time}`;
        },
        imageFor(item) {
            if ('cover_image' in item) {
                return item.cover_image;
            }
            return item;
        },
        isThumbnailFavorited(item) {
            return !!item.is_favorite;
        },
        isThumbnailCoverImage(item) {
            if ('cover_album_id' in this.model) {
                return item.id === this.model.cover_album_id;
            }
            if (!('cover_image' in this.model)) {
                return false;
            }
            return this.imageFor(item).id === this.model.cover_image.id;
        },
        thumbnailUrlFor(item) {
            const image = this.imageFor(item);
            if (image) {
                return this.miniThumbnailUrlFor(image);
            }
            return '';
        },
        thumbnailImageClass(item) {
            return {
                [this.$style.coverImage]:
                    !this.isCurrentlyBatchSelect &&
                    this.isThumbnailCoverImage(item),
            };
        },
        thumbnailItemClass(i) {
            return {
                [this.$style.batchSelected]:
                    this.isCurrentlyBatchSelect && this.batchSelectedItems[i],
                [this.$style.reorderSelect]:
                    this.isReordering &&
                    (this.currentDragIndex === i ||
                        this.selectedItemsToBatchReorder[i]),
            };
        },
        thumbnailTitleClass(item) {
            return {
                [this.$style.thumbnailTitle]: true,
                [this.$style.defaultTitle]: !('name' in item),
                [this.$style.thumbnailTitleFavorite]:
                    this.isThumbnailFavorited(item),
            };
        },
        onItemHovered(item, $event) {
            this.$emit('itemHover', { item, $event });
        },
        onItemHoveredEnd() {
            this.$emit('itemHoverEnd');
        },
        onHeartClicked(item) {
            if (!this.isThumbnailFavoriteUpdateSupported) {
                return;
            }
            this.updateItemFavorite(item);
        },
    },
};
</script>
