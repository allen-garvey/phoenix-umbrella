<template>
    <main class="main container inner-container">
        <div>
            <h1>{{heading}}</h1>
        </div>
        <form @submit.prevent="save()">
            <slot name="inputs"></slot>

            <div class="spread-content">
                <router-link :to="backLink" class="btn btn-outline-dark">Cancel</router-link>
                <button class="btn btn-success" type="submit">Save</button>
            </div>
        </form>
    </main>
</template>

<script>
export default {
    name: 'Form-Section',
    props: {
        heading: {
            type: String,
            required: true,
        },
        backLink: {
            type: Object,
            required: true,
        },
        save: {
            type: Function,
            required: true,
        },
    },
}
</script>
