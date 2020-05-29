<template>
    <nav :class="$style['nav']">
        <ul 
            :class="[$style['nav-list'], $style['nav-pills']]"
        >
            <li v-for="(tab, i) in tabs" :key="i">
                <router-link 
                    :to="tab.route(searchQuery)"
                    :active-class="$style['router-link-active']"
                >
                    {{ tab.title }}
                </router-link>
            </li>
        </ul>
    </nav>
</template>

<style lang="scss" module>
    @import '~seren-styles/variables';

    .nav{
        font-family: sans-serif;
    }

    .nav-list{
        display: flex;
        flex-wrap: wrap;
        justify-content: center;
        padding: 0;
        list-style-type: none;
    }

    .nav-pills li a{
        text-decoration: none;
        color: $accent_color_text;
        cursor: pointer;
        padding: 0.5em 1em;

        &:hover{
            color: #0056b3;
        }

        &.router-link-active{
            background: $accent_color_text;
            color: white;
            border-radius: 4px;	
        }
    }
</style>

<script>
import Models from '../models';

export default {
    name: 'Nav-Tabs',
    props: {
        searchQuery: {
            type: String,
            required: true,
        },
    },
	data(){
		return {
			tabs: Models.getTabs(),
		};
	},
	computed: {
	},
};
</script>