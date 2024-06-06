<template>
    <div :class="$style.container" v-if="isInitialLoadComplete">
        <label>Clans
            <select v-model="selectedClan" class="form-control">
                <option v-for="clan in clans" :key="clan.id" :value="clan">{{ clan.name }}</option>
            </select>
        </label>
        <button @click="onClanSelected" :disabled="selectedClan === null" class="btn btn-primary" :class="$style.button">Add</button>
    </div>
</template>

<style lang="scss" module>
    .container {
        display: flex;
        gap: 1em;
        margin-bottom: 1em;
    }
    .button {
        align-self: flex-end;
    }
</style>

<script>
export default {
    props: {
        getModel: {
            type: Function,
            required: true,
        },
        onSelected: {
            type: Function,
            required: true,
        },
    },
    created(){
        this.isInitialLoadComplete = false;
        this.getModel('/clans?excerpt=false')
            .then(clans => {
                this.clans = clans;
                this.isInitialLoadComplete = true;
            });
    },
    data(){
        return {
            isInitialLoadComplete: false,
            clans: [],
            selectedClan: null,
        };
    },
    computed: {
    },
    methods: {
        onClanSelected(){
            this.onSelected(this.selectedClan.person_ids);
        }
    }
};
</script>