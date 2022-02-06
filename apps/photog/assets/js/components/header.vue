<template>
    <header :class="[$style.header, 'container']">
        <h1 :class="$style.brand"><router-link :to="{name: 'home'}">Photog</router-link></h1>
        <nav>
            <ul :class="$style['nav-list']">
                <li>
                    <router-link :to="{name: 'albumsForYearIndex'}">Yearly Albums</router-link>
                </li>
                <li><router-link :to="{name: 'albumsIndex'}">Albums</router-link></li>
                <li><router-link :to="{name: 'tagsIndex'}">Tags</router-link></li>
                <li><router-link :to="{name: 'personsIndex'}">Persons</router-link></li>
                <li><router-link :to="{name: 'imagesMenu'}">Images</router-link></li>
                <li><router-link :to="{name: 'importsIndex'}">Imports</router-link></li>
                <li><router-link :to="{name: 'importsShowLast'}">Last Import</router-link></li>
            </ul>
        </nav>
    </header>
</template>

<style lang="scss" module>
    @import "~bootstrap/functions";
    @import "~bootstrap/variables";

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
        }
    }
    .nav-list{
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
                background-color: $primary; //from bootstrap
                color: #fff;
                text-decoration: none;
            }
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
    }
}
</script>
