<template>
    <header class="header container">
        <h1 class="brand"><router-link :to="{name: 'home'}">Photog</router-link></h1>
        <nav>
            <ul class="nav-list">
                <li><router-link :to="{name: 'albumsIndex'}">Albums</router-link></li>
                <li><router-link :to="{name: 'tagsIndex'}">Tags</router-link></li>
                <li><router-link :to="{name: 'personsIndex'}">Persons</router-link></li>
                <li><router-link :to="{name: 'imageFavoritesIndex'}">Favorites</router-link></li>
                <li><router-link :to="{name: 'imagesNotInAlbumIndex'}">Uncategorized Images</router-link></li>
                <li><router-link :to="{name: 'importsIndex'}">Imports</router-link></li>
                <li><router-link :to="{name: 'importsShowLast'}">Last Import</router-link></li>
            </ul>
        </nav>
    </header>
</template>

<script>
export default {
    name: 'Photog-Header',
    props: {

    },
    components: {
    },
    data() {
        return {

        }
    },
    computed: {

    },
    created() {
    },
    methods: {

    }
}
</script>
