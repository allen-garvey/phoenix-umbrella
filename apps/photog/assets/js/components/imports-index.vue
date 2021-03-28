<template>
    <Text-List 
        :title="pageTitle" 
        :itemsList="itemsList" 
        :isInitialLoadComplete="isInitialLoadComplete" :loadMoreItemsCallback="loadMoreItems"
    >
        <template v-slot:item="{item, index}">
            <router-link :to="showRouteFor(item)">
                <div>{{titleFor(item)}}</div>
                <ul :class="$style['imports-index-mini-thumbnail-list']">
                    <li v-for="image in item.images" :key="image.id">
                        <img :src="thumbnailUrlFor(image)"/>
                    </li>
                </ul>
            </router-link>
        </template>
    </Text-List>
</template>

<style lang="scss" module>
    .imports-index-mini-thumbnail-list{
        display: inline-flex;
        flex-wrap: wrap;
        img{
            object-fit: cover;
            object-position: center;
            height: 130px;
            width: 140px;
            transition: width 0.4s, height 0.75s;
        }

        &:hover{
            img{
                height: 240px;
                width: 280px;
            }
        }
    }
</style>

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
