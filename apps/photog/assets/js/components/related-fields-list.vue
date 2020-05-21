<template>
    <div>
        <ul :class="$style['related-fields-list']">
            <li 
                v-for="item in items" 
                :key="item.id" 
                :class="$style['related-fields-list-item']"
            >
                <router-link :to="routeForItem(item)">{{item.name}}</router-link>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    .related-fields-list{
        display: flex;
        flex-wrap: wrap;
    }

    .related-fields-list-item{
        padding: 1em;
        background-color: #eee;
        border-radius: 4px;
        margin-right: 1em;
    }
</style>

<script>
export default {
    props: {
        items: {
            type: Array,
            default: [],
        },
        routeName: {
            type: String,
            required: true,
        },
    },
    data(){
        return {
        };
    },
    methods: {
        routeForItem(item){
            return {
                name: this.routeName,
                params: {
                    id: item.id,
                },

            };
        }
    }
};
</script>