<template>
    <div v-if="initialLoadComplete">
        <ul class="list-group post-tags-list">
            <li class="list-group-item list-group-item-info">
                <div class="list-header">
                    <h4 class="list-heading">Tags</h4>
                    <div class="header-buttons-container" v-show="!addTagMode">
                        <button class="btn btn-primary" @click="addButtonAction()" :disabled="busy">Add</button>
                    </div>
                </div>
                <div class="alert alert-warning error-container" v-if="addTagMode && tagsThatCanBeAdded.length === 0">
                    This post has already been tagged with all available tags. <a :href="newTagUrl" target="_blank">Want to create more?</a>
                </div>
                <div class="add-tags-container" v-show="addTagMode">
                    <div class="tag-checkboxes">
                        <label v-for="(tag, index) in tagsThatCanBeAdded" :key="tag.id">
                            <input type="checkbox" @change="tagSelected(index)">{{tag.name}}
                        </label>
                    </div>
                    <div class="add-tag-link">
                        <a :href="newTagUrl" target="_blank">Create tag</a>
                    </div>
                    <div class="button-container-right">
                        <button class="btn btn-default" @click="cancelButtonAction()">Cancel</button>
                        <button class="btn btn-success" @click="saveButtonAction()" :disabled="busy">Save</button>
                    </div>
                </div>
            </li>
            <li class="list-group-item tag-item" v-for="tag in tags" :key="tag.id">
                {{tag.name}}
                <button class="btn btn-danger btn-xs" @click="removeTag(tag.id)">Remove</button>
            </li>
        </ul>
    </div>
</template>

<script>
import { fetchJson, sendJson } from '../ajax.js';

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