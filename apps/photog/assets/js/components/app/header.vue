<template>
    <header :class="[$style.header, 'container']">
        <h1 :class="$style.brand"><router-link :to="{name: 'home'}">Photog</router-link></h1>
        <nav>
            <ul :class="$style.navList">
                <li>
                    <router-link :to="{name: 'albumsForYearIndex'}">Yearly Albums</router-link>
                </li>
                <li><router-link :to="{name: 'albumsIndex'}">Albums</router-link></li>
                <li><router-link :to="{name: 'tagsIndex'}">Tags</router-link></li>
                <li><router-link :to="{name: 'personsIndex'}">Persons</router-link></li>
                <li><router-link :to="{name: 'clansIndex'}">Clans</router-link></li>
                <li><router-link :to="{name: 'imagesMenu'}">Images</router-link></li>
                <li><router-link :to="{name: 'importsIndex'}">Imports</router-link></li>
                <li><router-link :to="{name: 'importsShowLast'}">Last Import</router-link></li>
            </ul>
        </nav>
    </header>
</template>

<style lang="scss" module>
    .header{
        display: flex;
        align-items: baseline;
        flex-wrap: wrap;
        padding-top: 1rem;
        nav{
            flex-grow: 1;
        }
    }

    .brand{
        font-size: 1.563rem;
        margin-right: 3.126rem;
        font-weight: normal;
        a{
            color: black;

            @media (prefers-color-scheme: dark) {
                & {
                    color: #fff;
                }
            }
        }
    }
    .navList{
        display: flex;
        flex-wrap: wrap;
        justify-content: space-between;
        margin-bottom: 0;

        li{
            margin-bottom: 1.5em;
        }

        @media screen and (max-width: 400px){
            &{
                flex-direction: column;
            }
        }

        a{
            padding: 0.75rem; //to match btn horizontal padding
            border-radius: 5px;

            &:hover, &.router-link-exact-active{
                // can't use bootstrap $primary variable due to incompatibility with @use
                background-color: #0d6efd;
                color: #fff;
                text-decoration: none;
            }
        }
    }
</style>

<script>
import { getCurrentYear } from '../../date-helpers';

export default {
    computed: {
        currentYear(){
            return getCurrentYear();
        },
    }
}
</script>
