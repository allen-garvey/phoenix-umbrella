<template>
    <div :class="$style['image-show-text-list-container']">
        <div :class="$style['image-show-text-list-heading']">
            <h3 :class="$style['image-show-text-list-title']">{{heading}}</h3>
            <div :class="$style['button-container']">
                <button :disabled="isAddMode" @click="editItemsButtonAction" class="btn btn-sm" :class="{'btn-secondary': isEditMode, 'btn-outline-secondary': !isEditMode}" v-if="hasItems && !isAddMode">{{editButtonText}}</button>
                <button :disabled="isEditMode" @click="addItemsButtonAction" class="btn btn-sm" :class="addButtonCssClass" v-if="!isEditMode || !hasItems">{{addButtonText}}</button>
                <button :disabled="!areAnyItemsToBeAddedSelected" v-if="isAddMode" @click="saveAddItems" class="btn btn-sm btn-success">Save</button>
            </div>
        </div>
        <div v-if="isAddMode">
            <ul :class="$style['image-show-add-items-list']">
                <li v-for="(item, index) in itemsThatCanBeAdded" :key="index">
                    <input type="checkbox" :id="idForItemToBeAdded(item, index)" v-model="itemsThatCanBeAddedSelected[index]" />
                    <label :for="idForItemToBeAdded(item, index)">{{item.name}}</label>
                </li>
            </ul>
        </div>
        <ul :class="$style['image-show-text-list']" v-if="hasItems">
            <li v-for="(item, index) in items" :key="item.id">
                <router-link :to="{name: itemRouteName, params: {id: item.id}}">{{item.name}}</router-link>
                <button :style="{visibility: isEditMode ? 'visible' : 'hidden'}" @click="deleteItem(item, index)" class="btn btn-xs btn-outline-danger">Delete</button>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    .image-show-text-list-container{
        margin-top: 3.5em;
    }
    .image-show-text-list-heading{
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 0.5em;

        .button-container{
            margin-left: 2em;
        }
    }
    .image-show-text-list{
        padding-left: 1em;
        li{
            margin-bottom: 0.5em;
            display: flex;
            flex-wrap: wrap;

            & > *:first-child{
                flex-basis: 25%;
            }
        }
    }
    .image-show-text-list-title{
        margin: 0;
        align-self: flex-end;
    }
    .image-show-add-items-list{
        margin-top: 1em;
        display: flex;
        flex-wrap: wrap;

        li{
            margin-bottom: 0.5em;
            flex-basis: 25%;
        }
    }
</style>

<script>
import { fetchJson } from 'umbrella-common-js/ajax.js';
import { API_URL_BASE } from '../../request-helpers.js';
import { arrayRemove } from '../../array-util.js';

const MODE_ADD = 1;
const MODE_DEFAULT = 2;
const MODE_EDIT = 3;

export default {
    name: 'Image-Items-List',
    props: {
        sendJson: {
            type: Function,
            required: true,
        },
        heading: {
            type: String,
            required: true,
        },
        itemRouteName: {
            type: String,
            required: true,
        },
        items: {
            type: Array,
            required: true,
        },
        itemsApiName: {
            type: String,
            required: true,
        },
        unusedItemsApiUrl: {
            type: String,
            required: true,
        },
        addItemsApiUrl: {
            type: String,
            required: true,
        },
        removeItemApiUrlBase: {
            type: String,
            required: true,
        },
        itemsUpdatedCallback: {
            type: Function,
            required: true,
        },
    },
    created(){
    },
    data() {
        return {
            itemsThatCanBeAdded: [],
            itemsThatCanBeAddedSelected: [],
            mode: MODE_DEFAULT,
        }
    },
    computed: {
        hasItems(){
            return this.items.length > 0;
        },
        addButtonText(){
            return this.isAddMode ? 'Cancel' : 'Add';
        },
        addButtonCssClass(){
            return this.isAddMode ? 'btn-outline-secondary' : 'btn-primary';
        },
        editButtonText(){
            return this.isEditMode ? 'Cancel' : 'Remove';
        },
        isAddMode(){
            return this.mode === MODE_ADD;
        },
        isEditMode(){
            return this.mode === MODE_EDIT;
        },
        isDefaultMode(){
            return this.mode === MODE_DEFAULT;
        },
        areAnyItemsToBeAddedSelected(){
            return this.itemsThatCanBeAddedSelected.some((isSelected)=>isSelected);
        },
    },
    methods: {
        idForItemToBeAdded(item, index){
            return `checkbox_${this.heading}_${index}_${item.id}`;
        },
        editItemsButtonAction(){
            if(this.isEditMode){
                this.mode = MODE_DEFAULT;
            }
            else{
                this.mode = MODE_EDIT;
            }
        },
        addItemsButtonAction(){
            if(this.isAddMode){
                this.mode = MODE_DEFAULT;
            }
            else{
                this.fetchAddItems();
            }
        },
        fetchAddItems(){
            fetchJson(API_URL_BASE + this.unusedItemsApiUrl).then((items) => {
                this.itemsThatCanBeAdded = items;
                this.itemsThatCanBeAddedSelected = this.itemsThatCanBeAdded.map(()=>false);
                this.mode = MODE_ADD;
            });
        },
        saveAddItems(){
            const itemIds = [];
            const itemsToBeAdded = [];
            this.itemsThatCanBeAddedSelected.forEach((isSelected, i)=>{
                if(isSelected){
                    const itemToAdd = this.itemsThatCanBeAdded[i];
                    itemIds.push(itemToAdd.id);
                    itemsToBeAdded.push(itemToAdd);
                }
            });
            const data = {};
            data[this.itemsApiName] = itemIds.join(',');

            this.sendJson(API_URL_BASE + this.addItemsApiUrl, 'POST', data).then((response)=>{
                //display error message if any
                
                //add items to array
                const itemsAddedSet = new Set(response.data);
                const itemsThatHaveBeenAdded = itemsToBeAdded.filter((item)=>{
                    return itemsAddedSet.has(item.id);
                });
                //note that the items won't be sorted correctly, but not a big deal for now
                const newItems = this.items.concat(itemsThatHaveBeenAdded);
                this.itemsUpdatedCallback(newItems);
                this.mode = MODE_DEFAULT;
            });
        },
        deleteItem(item, index){
            const removeItemUrl = this.removeItemApiUrlBase + item.id;

            this.sendJson(API_URL_BASE + removeItemUrl, 'DELETE').then((response)=>{
                //remove item from array
                this.itemsUpdatedCallback(arrayRemove(this.items, index));
            });
        },
    }
}
</script>
