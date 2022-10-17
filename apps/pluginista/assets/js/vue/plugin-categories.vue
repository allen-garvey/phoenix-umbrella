<template>
    <div>
        <div class="form-check form-check-inline" v-for="category in activeCategoriesList">
            <input class="form-check-input" :id="getId(category)" name="categories[]" type="checkbox" :value="category.id">
            <label class="form-check-label" :for="getId(category)">{{ category.name }}</label>
        </div>
    </div>
</template>

<style lang="scss" module>
</style>

<script>
export default {
    props: {
        categories: {
            type: String,
            required: true,
        },
    },
    components: {
    },
    created(){
        this.categoriesList = JSON.parse(this.categories);
        const groupSelectEl = document.getElementById('plugin_group_id');
        this.selectedGroupId = parseInt(groupSelectEl.value);
        groupSelectEl.addEventListener('change', (e) => {
            this.selectedGroupId = parseInt(e.target.value);
        });
    },
    mounted(){
    },
    data(){
        return {
            categoriesList: [],
            selectedGroupId: -1,
        };
    },
    computed: {
        activeCategoriesList(){
            return this.categoriesList.filter(category => category.group_id === this.selectedGroupId);
        },
    },
    watch: {
    },
    methods: {
        getId(category){
            return `categories_${category.id}`;
        },
    }
};
</script>