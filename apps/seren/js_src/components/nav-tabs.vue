<template>
    <nav class="nav">
        <ul class="nav-list nav-pills">
            <li v-for="(tab, i) in tabs" :key="i">
                <router-link :to="tab.route(searchQuery)">{{ tab.title }}</router-link>
            </li>
        </ul>
    </nav>
</template>

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
	methods: {
	}
};
</script>