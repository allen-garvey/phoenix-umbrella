<template>
    <div :class="$style.textListContainer">
        <div :class="$style.textListHeading">
            <h3 :class="$style.textListTitle">{{ heading }}</h3>
            <div :class="$style.buttonContainer">
                <button 
                    :disabled="isAddMode" 
                    @click="editItemsButtonAction" 
                    class="btn btn-sm" 
                    :class="{'btn-secondary': isEditMode, 'btn-outline-secondary': !isEditMode}" v-if="hasItems && !isAddMode"
                >
                    {{ editButtonText }}
                </button>
                <button 
                    :disabled="isEditMode" 
                    @click="addItemsButtonAction" 
                    class="btn btn-sm" 
                    :class="addButtonCssClass" 
                    v-if="!isEditMode || !hasItems"
                >
                    {{ addButtonText }}
                </button>
                <button 
                    :disabled="selectedItems.length === 0" 
                    v-if="isAddMode" 
                    @click="saveAddItems" 
                    class="btn btn-sm btn-success"
                >
                    Save
                </button>
            </div>
        </div>
        <div v-if="isAddMode">
            <slot 
                name="itemsSuperManager" 
                :on-selected="(itemIds) => onItemsSuperManagerItemsUpdated(itemIds, true)"
                :on-removed="(itemIds) => onItemsSuperManagerItemsUpdated(itemIds, false)"
            ></slot>
            <label>Search <input class="form-control" v-model="searchValue" v-focus /></label>
            <ul :class="$style.addItemsList">
                <li v-for="(item, index) in filteredItemsThatCanBeAdded" :key="index">
                    <input 
                        type="checkbox" 
                        :id="idForItemToBeAdded(item, index)"
                        :checked="selectedItemsMap[item.id]"
                        @change="onAddItemCheckboxChanged(item.id)" 
                    />
                    <label 
                        :for="idForItemToBeAdded(item, index)" 
                        :class="{[$style.favoritedItem]: item.is_favorite}"
                    >
                        {{ item.name }}
                    </label>
                </li>
            </ul>
        </div>
        <ul :class="$style.textList" v-if="hasItems">
            <li v-for="(item, index) in items" :key="item.id">
                <router-link 
                    :to="{name: itemRouteName, params: {id: item.id}}"
                >
                    {{ item.name }}
                </router-link>
                <button 
                    :style="{visibility: isEditMode ? 'visible' : 'hidden'}" 
                    @click="deleteItem(item, index)" 
                    class="btn btn-xs btn-outline-danger"
                >
                    Delete
                </button>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    @import '~photog-styles/site/variables';

    .textListContainer{
        margin-top: 3.5em;
    }
    .textListHeading{
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 0.5em;
    }
    .buttonContainer{
        display: flex;
        flex-wrap: wrap;
        gap: 1em;
        margin-left: 2em;
    }
    .textList{
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
    .textListTitle{
        margin: 0;
        align-self: flex-end;
    }
    .addItemsList{
        margin-top: 1em;
        display: flex;
        flex-wrap: wrap;

        li{
            margin-bottom: 0.5em;
            flex-basis: 25%;
        }

        .favoritedItem {
            color: $photog_favorited_color;
        }
    }
</style>

<script>
import focus from 'umbrella-common-js/vue/directives/focus.js';
import { API_URL_BASE } from '../../request-helpers.js';
import { arrayRemove } from '../../array-util.js';

const MODE_ADD = 1;
const MODE_DEFAULT = 2;
const MODE_EDIT = 3;

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
        getItemsApiUrl: {
            type: String,
            required: true,
        },
        currentItemsSet: {
            type: Set,
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
    directives: {
        focus,
    },
    data() {
        return {
            itemsThatCanBeAdded: [],
            selectedItemsMap: {},
            mode: MODE_DEFAULT,
            searchValue: '',
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
        selectedItems(){
            return this.itemsThatCanBeAdded.filter(({id}) => this.selectedItemsMap[id]);
        },
        filteredItemsThatCanBeAdded(){
            if(this.searchValue.length >= 2){
                return this.itemsThatCanBeAdded
                    .filter(
                        ({ name }) => name.toLowerCase().indexOf(this.searchValue.toLowerCase()) >= 0
                );
            }

            return this.itemsThatCanBeAdded;
        },
    },
    watch: {
        items(){
            if(this.items.length === 0 && this.isEditMode){
                this.mode = MODE_DEFAULT;
            }
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
        onAddItemCheckboxChanged(id){
            this.selectedItemsMap[id] = !this.selectedItemsMap[id];
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
            this.getModel(this.getItemsApiUrl).then((items) => {
                this.itemsThatCanBeAdded = items.filter(item => !this.currentItemsSet.has(item.id));
                this.selectedItemsMap = {};
                this.mode = MODE_ADD;
            });
        },
        saveAddItems(){
            const itemsToBeAdded = [...this.selectedItems];

            const data = {
                [this.itemsApiName]: itemsToBeAdded.map(({id}) => id).join(','),
            };

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
            this.sendJson(`${API_URL_BASE}${this.removeItemApiUrlBase}/${item.id}/images`, 'DELETE', {image_ids: [this.imageId]}).then((response)=>{
                //remove item from array
                this.itemsUpdatedCallback(arrayRemove(this.items, index));
            });
        },
        onItemsSuperManagerItemsUpdated(itemIds, value){
            itemIds.forEach(itemId => {
                this.selectedItemsMap[itemId] = value;
            });
        },
    }
}
</script>
