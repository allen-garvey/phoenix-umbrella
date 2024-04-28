<template>
    <router-link :to="showRouteFor(item)">
        <div>{{ titleFor(item) }}</div>
        <p :class="$style.itemNotes" v-if="item.camera_model">{{ item.camera_model }}</p>
        <p :class="$style.itemNotes" v-if="item.notes">{{ item.notes }}</p>
        <ul :class="$style.albumsList">
            <li 
                v-for="album in item.albums" 
                :key="album.id"
                :class="$style.itemNotes"
            >
                {{ album.name }}
            </li>
        </ul>
        <ul :class="$style.thumbnailList">
            <li v-for="image in item.images" :key="image.id">
                <img :src="miniThumbnailUrlFor(image)" loading="lazy"/>
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
    .albumsList {
        display: flex;
        flex-wrap: wrap;
        gap: 0 0.75em;
        margin: 0.25em 0;
    }
    .itemNotes{
        color: #777;
        margin: 0;
    }
</style>

<script>
export default {
        props: {
            item: {
                type: Object,
                required: true,
            },
            miniThumbnailUrlFor: {
                type: Function,
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
        }
    };
</script>
