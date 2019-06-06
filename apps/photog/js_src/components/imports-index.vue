<template>
    <Text-List :title="pageTitle" :items-list="itemsList" :is-initial-load-complete="isInitialLoadComplete" :load-more-items-callback="loadMoreItems">
        <template v-slot:item="{item, index}">
            <router-link :to="showRouteFor(item)" class="imports-index-item-link">
                <div>{{titleFor(item)}}</div>
                <ul class="imports-index-mini-thumbnail-list">
                    <li v-for="image in item.images" :key="image.id">
                        <img :src="thumbnailUrlFor(image)"/>
                    </li>
                </ul>
            </router-link>
        </template>
    </Text-List>
</template>

<script>
import { thumbnailUrlFor } from '../image.js';
import IndexTextListMixinBuilder from './mixins/index-text-list-mixin.js';

export default {
        name: 'Imports-Index',
        mixins: [IndexTextListMixinBuilder('Imports')],
        data() {
            return {
                modelPath: '/imports/?limit=20',
                showRouteName: 'importsShow',
            }
        },
        methods: {
            titleFor(item){
                return `${item.name} (${item.images_count})`;
            },
            thumbnailUrlFor(image){
                return thumbnailUrlFor(image.mini_thumbnail_path);
            },
            //to make the code a bit easier, there are only 2 states for the infinite scroll
            //at first load we only load the most recent imports, but if you scroll down we just load everything
            //instead of incremental loads with offsets
            loadMoreItems($state){
                this.getModel('/imports').then((itemsJson)=>{
                    this.model = itemsJson;
                    $state.complete();
                });
            },
        }
    };
</script>
