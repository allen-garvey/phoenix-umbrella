<template>
    <router-link :to="showRouteFor(item)">
        <div>{{ titleFor(item) }}</div>
        <p :class="$style.itemNotes" v-if="item.camera_model">{{ item.camera_model }}</p>
        <p :class="$style.itemNotes" v-if="item.notes">{{ item.notes }}</p>
        <ul :class="$style.thumbnailList">
            <li v-for="image in item.images" :key="image.id">
                <img :src="thumbnailUrlFor(image)" loading="lazy"/>
            </li>
        </ul>
    </router-link>
</template>

<style lang="scss" module>
    .thumbnailList{
        display: inline-flex;
        flex-wrap: wrap;
        img{
            object-fit: cover;
            object-position: center;
            height: 130px;
            width: 400px;
            transition: width 0.4s, height 0.75s;
        }

        &:hover{
            img{
                height: 240px;
                width: 600px;
            }
        }
    }
    .itemNotes{
        color: #777;
        margin: 0;
    }
</style>

<script>
import { thumbnailUrlFor } from '../image.js';

export default {
        props: {
            item: {
                type: Object,
                required: true,
            },
        },
        methods: {
            showRouteFor(item){
                return {
                    name: 'importsShow',
                    params: {
                        id: item.id,
                    },
                };
            },
            titleFor(item){
                return item.name;
            },
            titleFor(item){
                return `${item.name} (${item.images_count})`;
            },
            thumbnailUrlFor(image){
                return thumbnailUrlFor(image.mini_thumbnail_path);
            },
        }
    };
</script>
