<template>
    <nav :class="$style.nav">
        <ul :class="[$style.navList, $style.navPills]">
            <li v-for="(tab, i) in tabs" :key="i">
                <router-link
                    :to="tab.route(searchQuery)"
                    :active-class="$style.routerLinkActive"
                >
                    {{ tab.title }}
                </router-link>
            </li>
        </ul>
    </nav>
</template>

<style lang="scss" module>
@use '~seren-styles/variables';

.nav {
    font-family: sans-serif;
}

.navList {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    padding: 0;
    list-style-type: none;
}

.navPills li a {
    color: var(--seren-accent-color-text);
    cursor: pointer;
    padding: 0.5em 1em;

    &:hover {
        color: #0056b3;
    }

    &.routerLinkActive {
        background: var(--seren-accent-color-text);
        color: white;
        border-radius: 4px;
    }
}

@media (prefers-color-scheme: dark) {
    .navPills li a {
        &.routerLinkActive {
            background: #6875ca;
        }
    }
}
</style>

<script>
export default {
    props: {
        searchQuery: {
            type: String,
            required: true,
        },
    },
    computed: {
        tabs() {
            return [
                {
                    title: 'Artists',
                    route(searchQuery) {
                        return {
                            name: 'artistsIndex',
                        };
                    },
                },
                {
                    title: 'Albums',
                    route(searchQuery) {
                        return {
                            name: 'albumsIndex',
                        };
                    },
                },
                {
                    title: 'Composers',
                    route(searchQuery) {
                        return {
                            name: 'composersIndex',
                        };
                    },
                },
                {
                    title: 'Tracks',
                    route(searchQuery) {
                        return {
                            name: 'tracksIndex',
                        };
                    },
                },
                {
                    title: 'Search Results',
                    route(searchQuery) {
                        return {
                            name: 'searchTracks',
                            query: {
                                q: searchQuery,
                            },
                        };
                    },
                },
            ];
        },
    },
};
</script>
