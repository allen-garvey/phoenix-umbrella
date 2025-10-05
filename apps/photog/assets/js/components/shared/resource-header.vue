<template>
    <div>
        <div class="spread-content" :class="$style.container">
            <div>
                <h1 :class="$style.title">
                    <span>{{ title }}</span>
                    <span :class="$style.count" v-if="countText !== false">{{
                        countText
                    }}</span>
                </h1>
                <p v-if="description" :class="$style.description">
                    {{ description }}
                </p>
            </div>
            <div class="pull-right">
                <div class="pull-right" v-if="extraLinks">
                    <router-link
                        :to="link.link"
                        class="btn"
                        :class="link.class"
                        :key="link.text"
                        v-for="link in extraLinks"
                    >
                        {{ link.text }}
                    </router-link>
                </div>
                <router-link
                    :to="newItemLink"
                    class="btn btn-success"
                    v-if="newItemLink"
                    >New</router-link
                >
                <button
                    class="btn btn-danger"
                    :class="$style.deleteButton"
                    v-if="shouldShowDelete"
                    @click="$emit('triggerDelete')"
                >
                    Delete
                </button>
                <router-link
                    :to="editItemLink"
                    class="btn btn-outline-dark"
                    v-if="editItemLink"
                >
                    Edit
                </router-link>
            </div>
        </div>
        <div>
            <router-link
                :to="previousPageLink.link"
                :class="$style.pageLink"
                v-if="previousPageLink"
            >
                {{ previousPageLink.text }}
            </router-link>
            <router-link
                :to="nextPageLink.link"
                :class="$style.pageLink"
                v-if="nextPageLink"
            >
                {{ nextPageLink.text }}
            </router-link>
        </div>
    </div>
</template>

<style lang="scss" module>
.container {
    margin-bottom: 0.5em;
}

.title {
    margin: 0;
}

.description {
    color: #777;
    margin: 0;
    font-size: 0.95em;
}

.count {
    color: #aaa;
    font-size: 1.563rem;
    margin-left: 0.2em;
}

.deleteButton {
    margin-right: 2rem;
}

.pageLink {
    display: inline-block;
    margin-bottom: 1rem;

    & + & {
        margin-left: 4rem;
    }
}
</style>

<script>
export default {
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
        previousPageLink: {
            type: Object,
        },
        nextPageLink: {
            type: Object,
        },
        shouldShowDelete: {
            type: Boolean,
            default: false,
        },
        count: {
            type: Number,
        },
        total: {
            type: Number,
        },
        extraLinks: {
            type: Array,
        },
    },
    computed: {
        countText() {
            if (!this.count && this.count !== 0) {
                return false;
            }
            if (!this.total || this.total === this.count) {
                return this.count;
            }
            return `${this.count}/${this.total}`;
        },
    },
};
</script>
