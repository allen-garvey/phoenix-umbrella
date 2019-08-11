<template>
    <div>
        <ul class="related-fields-list">
            <li v-for="item in items" :key="item.id" class="related-fields-list-item">
                <a :href="urlForItem(item)">{{item.name}}</a>
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
        urlBase: {
            type: String,
            required: true,
        },
    },
    data(){
        return {
        };
    },
    methods: {
        urlForItem(item){
            return `${this.urlBase}/${item.id}`;
        }
    }
};
</script>