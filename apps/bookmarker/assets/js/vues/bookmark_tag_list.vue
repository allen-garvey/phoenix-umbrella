<template>
    <div v-if="initialLoadComplete">
        <ul class="list-group tag-list">
            <li class="list-group-item list-group-item-info">
            <div class="tag-list-header">
                <h4>Tags</h4>
                <div>
                    <button class="btn btn-success" @click="addButtonAction()" :disabled="busy" v-show="!addTagMode">Add</button>
                </div>
            </div>
            <div class="add-tag-container" v-show="addTagMode">
                <div class="add-tag-select-container" v-show="tagsThatCanBeAdded.length > 0">
                    <select class="form-control tag-select" ref="tagSelect">
                        <option v-for="tag in tagsThatCanBeAdded" :key="tag.id">{{tag.name}}</option>
                    </select>
                    <div>
                        <button class="btn btn-default" @click="cancelButtonAction()">Cancel</button>
                        <button class="btn btn-success" @click="saveButtonAction()" :disabled="busy">Save</button>
                    </div>
                </div>
                <div class="add-tag-alert alert alert-warning" v-show="tagsThatCanBeAdded.length === 0">
                    This bookmark has already been tagged with all available tags. <a :href="newTagUrl">Want to create more?</a>
                </div>
            </div>
            </li>
            <li class="list-group-item" v-for="tag in tags" :key="tag.id">
                <div><a :href="tag.urls.show">{{tag.name}}</a></div>
                <div>
                    <button class="btn btn-danger btn-xs" @click="removeTag(tag.id)">Remove</button>
                </div>
            </li>
        </ul>
    </div>
</template>

<script>
import { getJson, sendJson } from '../ajax.js';

export default {
    name: 'bookmark-tag-list',
    props: {
        csrfToken: {
            type: String,
            required: true,
        },
        bookmarkId: {
            type: String,
            required: true,
        },
        newTagUrl: {
            type: String,
            required: true,
        },
        newBookmarkTagUrl: {
            type: String,
            required: true,
        },
        deleteBookmarkTagUrl: {
            type: String,
            required: true,
        },
        tagsUrl: {
            type: String,
            required: true,
        },
        unusedTagsUrl: {
            type: String,
            required: true,
        },
    },
    created(){
        getJson(this.tagsUrl).then((data)=>{
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
            getJson(this.unusedTagsUrl).then((data)=>{
                this.tagsThatCanBeAdded = data;
                this.addTagMode = true;
                this.busy = false;
            });
        },
        cancelButtonAction(){
            this.addTagMode = false;
        },
        saveButtonAction(){
            const selectedTag = this.tagsThatCanBeAdded[this.$refs.tagSelect.selectedIndex];
            this.busy = true;
            const data = {bookmark_id: this.bookmarkId, tag_id: selectedTag.id};

            sendJson(this.newBookmarkTagUrl, this.csrfToken, 'POST', data).then((json)=>{
                this.busy = false;
                if(json.error){
                    console.log(json.error);
                    return;
                }
                this.addTagMode = false;
                this.tags.push(selectedTag);
            });
        },
        removeTag(tagId){
            const data = {bookmark_id: this.bookmarkId, tag_id: tagId};
            sendJson(this.deleteBookmarkTagUrl, this.csrfToken, 'DELETE', data).then((json)=>{
                //don't need to do anything here, since we are optimistically assuming succeeeded
            });
            //optimistic remove
            this.tags = this.tags.filter(tag=>tag.id !==tagId);
        },
    }
};
</script>