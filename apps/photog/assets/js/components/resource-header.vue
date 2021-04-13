<template>
    <div 
        class="spread-content"
        :class="$style.container"
    >
        <div>
            <h1 
                :class="$style.title" 
            >
                <span>{{title}}</span>
                <span :class="$style.count" v-if="count">{{count}}</span>
            </h1>
            <p 
                v-if="description" 
                :class="$style.description"
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
    .container{
        margin-bottom: 0.5em;
    }

    .title{
        margin: 0;
    }

    .description{
        color: #777;
        margin: 0;
        font-size: 0.95em;
    }

    .count {
        color: #aaa;
        font-size: 1.563rem;
        margin-left: 0.2em;
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
        count: {
            type: Number,
        },
    },
}
</script>
