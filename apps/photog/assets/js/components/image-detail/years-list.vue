<template>
    <div :class="$style.textListContainer">
        <div :class="$style.textListHeading">
            <h3 :class="$style.textListTitle">Years</h3>
        </div>
        <ul :class="$style.textList" v-if="years.length > 0">
            <li v-for="year in years" :key="year">
                {{ year }}
                <button 
                    @click="deleteItem(year)" 
                    class="btn btn-xs btn-outline-danger"
                >
                    Delete
                </button>
            </li>
        </ul>
        <div v-if="isInitialLoadComplete">
            <form @submit.prevent="addItem()">
                <input class="form-control" :class="$style.input" type="number" v-model="addYearValue" />
                <button class="btn btn-success" :disabled="isSubmitDisabled">Add</button>
            </form>
        </div>
    </div>
</template>

<style lang="scss" module>
    .textListContainer{
        margin-top: 3.5em;

        button {
            display: inline-block;
            margin-left: 1em;
        }
    }
    .textListHeading{
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 0.5em;
    }
    .textListTitle{
        margin: 0;
        align-self: flex-end;
    }
    .textList{
        padding-left: 1em;
        li{
            margin-bottom: 0.5em;

        }
    }
    .input {
        display: inline-block;
        width: 10em;
    }
</style>

<script>
import { API_URL_BASE } from '../../request-helpers.js';

export default {
    props: {
        imageId: {
            type: Number,
            required: true,
        },
        getModel: {
            type: Function,
            required: true,
        },
        sendJson: {
            type: Function,
            required: true,
        },
    },
    data() {
        return {
            addYearValue: '',
            years: [],
            isInitialLoadComplete: false,
        }
    },
    created(){
        this.refreshYears();
    },
    computed: {
        isSubmitDisabled(){
            return !this.addYearValue || this.years.includes(this.addYearValue) || isNaN(this.addYearValue);
        },
    },
    watch: {
        imageId(){
            this.refreshYears();
        },
    },
    methods: {
        deleteItem(year){
            this.sendJson(`${API_URL_BASE}/years/${year}/images/${this.imageId}`, 'DELETE')
            .then(() => this.refreshYears(true));
        },
        refreshYears(forceRefresh=false){
            this.isInitialLoadComplete = false;
            this.years = [];
            this.addYearValue = '';
            
            this.getModel(`/images/${this.imageId}/years`, {forceRefresh})
            .then(years => {
                this.years = years;
                this.isInitialLoadComplete = true;
            });
        },
        addItem(){
            if(this.isSubmitDisabled){
                return;
            }
            this.sendJson(`${API_URL_BASE}/year_images`, 'POST', {
                year: this.addYearValue, 
                image_id: this.imageId,
            })
            .then(() => this.refreshYears(true));
        },
    }
}
</script>
