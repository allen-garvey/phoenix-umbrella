<template>
    <div class="spread-content resource-header-container">
        <div>
            <h1 class="resource-header-title" v-if="title">{{title}}</h1>
            <p v-if="description" class="resource-header-description">{{description}}</p>
        </div>
        <div class="pull-right" v-if="newItemLink || editItemLink">
            <router-link :to="newItemLink" class="btn btn-success" v-if="newItemLink">New</router-link>
            <router-link :to="editItemLink" class="btn btn-outline-dark" v-if="editItemLink">Edit</router-link>
        </div>
    </div>
</template>

<script>
export default {
    name: 'Reasource-Header',
    props: {
        title: {
            type: String,
        },
        description: {
            type: String,
        },
        newItemLink: {
            type: Object,
        },
        editItemLink: {
            type: Object,
        },
    },
    components: {
    },
    created(){
    },
    data() {
        return {
        }
    },
    computed: {
    },
    methods: {
    }
}
</script>
