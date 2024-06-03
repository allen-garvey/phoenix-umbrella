<template>
    <div v-if="initialLoadComplete">
        <ul 
            class="list-group"
            :class="$style.tagsList"
        >
            <li 
                class="list-group-item list-group-item-info"
                :class="$style.listHeadingContainer"
            >
                <div :class="$style.list-header">
                    <h4 :class="$style.listHeading">Tags</h4>
                    <div v-show="!addTagMode">
                        <button class="btn btn-primary" @click="addButtonAction()" :disabled="busy">Add</button>
                    </div>
                </div>
                <div class="alert alert-warning" v-if="addTagMode && tagsThatCanBeAdded.length === 0">
                    This post has already been tagged with all available tags. <a :href="newTagUrl" target="_blank">Want to create more?</a>
                </div>
                <div :class="$style.addTagsContainer" v-show="addTagMode">
                    <div>
                        <label v-for="(tag, index) in tagsThatCanBeAdded" :key="tag.id">
                            <input type="checkbox" @change="tagSelected(index)">{{tag.name}}
                        </label>
                    </div>
                    <div :class="$style.addTagLink">
                        <a :href="newTagUrl" target="_blank">Create tag</a>
                    </div>
                    <div :class="$style.buttonContainerRight">
                        <button class="btn btn-primary" @click="cancelButtonAction()">Cancel</button>
                        <button class="btn btn-success" @click="saveButtonAction()" :disabled="busy">Save</button>
                    </div>
                </div>
            </li>
            <li 
                class="list-group-item" 
                :class="$style.tagItem"
                v-for="tag in tags" 
                :key="tag.id"
            >
                {{tag.name}}
                <button class="btn btn-danger btn-sm" @click="removeTag(tag.id)">Remove</button>
            </li>
        </ul>
    </div>
</template>

<style lang="scss" module>
    .tagsList{
        margin-bottom: 40px;
    }
    .listHeadingContainer{
        padding-top: 1.5em;
        padding-bottom: 1.5em;
    }
    .list-header{
        display: flex;
        justify-content: space-between;
    }
    .listHeading{
        margin-top: 0;
        font-size: 1.563em;
    }
    .addTagLink{
        margin-top: 0.5em;
        a:before{
            content: '+';
            //so not underlined on hover
            display: inline-block;
            margin-right: 0.2em;
            font-weight: bold;
        }
    }
    .addTagsContainer{
        label{
            margin-right: 16px;
        }
        input[type="checkbox"]{
            margin-right: 10px;
        }
        .buttonContainerRight{
            display: flex;
            justify-content: flex-end;
            button{
                margin-right: 12px;
                &:last-of-type{
                    margin-right: 0;
                }
            }
        }
    }
    .tagItem{
        display: flex;
        justify-content: space-between;
        padding-top: 1em;
        padding-bottom: 1em;
    }
</style>

<script>
import { fetchJson, sendJson } from 'umbrella-common-js/ajax.js';

export default {
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        postId: {
            type: String,
            required: true,
        },
        newTagUrl: {
            type: String,
            required: true,
        },
        apiBaseUrl: {
            type: String,
            required: true,
        },
    },
    created(){
        fetchJson(this.apiBaseUrl).then((data)=>{
            this.tags = data;
            this.initialLoadComplete = true;
        });
    },
    data(){
        return {
            initialLoadComplete: false,
            tags: [],
            tagsThatCanBeAdded: [],
            addTagMode: false,
            busy: false,
        };
    },
    computed: {
    },
    methods: {
        addButtonAction(){
            this.busy = true;
            fetchJson(`${this.apiBaseUrl}?unused=true`).then((data)=>{
                this.tagsThatCanBeAdded = data;
                this.addTagMode = true;
                this.busy = false;
            });
        },
        tagSelected(index){
            this.tagsThatCanBeAdded[index].selected = !this.tagsThatCanBeAdded[index].selected;
        },
        cancelButtonAction(){
            this.addTagMode = false;
        },
        saveButtonAction(){
            this.busy = true;
            const selectedTags = this.tagsThatCanBeAdded.filter(tag=>tag.selected);
            const selectedTagIds = selectedTags.map(tag=>tag.id);
            const data = {tags: selectedTagIds};

            sendJson(this.apiBaseUrl, this.csrfToken, 'POST', data).then((json)=>{
                this.busy = false;
                if(json.error){
                    console.log(json.error);
                    return;
                }
                this.tags = this.tags.concat(selectedTags);
                this.addTagMode = false;
            });
        },
        removeTag(tagId){
            sendJson(`${this.apiBaseUrl}/${tagId}`, this.csrfToken, 'DELETE').then((json)=>{
                //don't need to do anything here, since we are optimistically assuming succeeeded
            });
            //optimistic remove
            this.tags = this.tags.filter(tag=>tag.id !==tagId);
        },
    }
};
</script>