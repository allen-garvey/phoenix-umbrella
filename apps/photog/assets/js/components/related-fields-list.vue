<template>
    <div>
        <ul class="related-fields-list">
            <li v-for="item in items" :key="item.id" class="related-fields-list-item">
                <router-link :to="routeForItem(item)">{{item.name}}</router-link>
            </li>
        </ul>
    </div>
</template>

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