<template>
    <div 
        class="spread-content"
        :class="$style['resource-header-container']"
    >
        <div>
            <h1 
                :class="$style['resource-header-title']" 
            >
                {{title}}
            </h1>
            <p 
                v-if="description" 
                :class="$style['resource-header-description']"
            >
                {{description}}
            </p>
        </div>
        <div class="pull-right" v-if="newItemLink || editItemLink">
            <router-link :to="newItemLink" class="btn btn-success" v-if="newItemLink">New</router-link>
            <router-link :to="editItemLink" class="btn btn-outline-dark" v-if="editItemLink">Edit</router-link>
        </div>
    </div>
</template>

<style lang="scss" module>
    .resource-header-container{
        margin-bottom: 0.5em;
    }

    .resource-header-title{
        margin: 0;
    }

    .resource-header-description{
        color: #777;
        margin: 0;
        font-size: 0.95em;
    }
</style>

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
}
</script>
