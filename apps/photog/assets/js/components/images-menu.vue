<template>
    <div class="main container">
        <h2>Images</h2>
        <ul :class="$style.list">
            <li>
                <router-link :to="{name: 'imagesIndex'}">All Images</router-link>
            </li>
            <li>
                <router-link :to="{name: 'imagesForYear', params: {year: currentYear}}">Yearly Images</router-link>
            </li>
            <li>
                <router-link :to="{name: 'imageFavoritesIndex'}">Favorite Images</router-link>
            </li>
            <li>
                <router-link :to="{name: 'imagesNotInAlbumIndex'}">Uncategorized Images</router-link>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    .list {
        margin-top: 1rem;
        font-size: 1.5rem;
        
        li {
            margin-bottom: 2rem;
        }
    }
</style>

<script>
import { getCurrentYear } from '../date-helpers';

export default {
    computed: {
        currentYear(){
            return getCurrentYear();
        },
    },
};
</script>