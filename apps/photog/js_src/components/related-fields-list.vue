<template>
    <div>
        <ul class="related-fields-list">
            <li v-for="item in items" :key="item.id" class="related-fields-list-item">
                {{item.name}}
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
    },
    data(){
        return {
        };
    },
    computed: {
    },
    methods: {
    }
};
</script>