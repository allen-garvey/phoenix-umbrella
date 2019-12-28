<template>
    <div class="image-show-info-section">
        <h3 class="image-info-section-heading">Info</h3>
        <dl>
            <dt>Master path</dt>
            <dd class="image-info-master-path">
                <template v-for="(part, i) in masterPathSplit">
                    <span :key="i">{{part}}</span><strong :key="`${i}-slash`" class="image-info-master-path-slash">/</strong>
                </template>
            </dd>
            <dt>Date Taken</dt>
            <dd>{{image.creation_time.formatted.us_date}} {{image.creation_time.formatted.time}}</dd>
            <dt class="image-info-completion-date">Completion Date</dt>
            <dd>
                <div v-show="!isEditingCompletionDate">{{formatIsoDate(image.completion_date)}}</div>
                <div v-if="isEditingCompletionDate" class="image-info-edit-container">
                    <div class="form-group"><input type="date" class="form-control" v-model="completionDateModel"/></div>
                    <div>
                        <button @click="cancelEditCompletionDate()" class="btn btn-outline-secondary btn-sm">Cancel</button>
                        <button @click="updateImageCompletionDate()" class="btn btn-success btn-sm">Save</button>
                    </div>
                </div>
                <div v-show="!isEditingCompletionDate">
                    <button @click="enableEditCompletionDate()" class="btn btn-outline-primary btn-sm">Edit</button>
                </div>
            </dd>
            <dt>Favorite</dt>
            <dd>{{image.is_favorite ? 'true' : 'false'}}</dd>
            <template v-if="image.import">
                <dt>Import</dt>
                <dd>
                    <router-link :to="{name: 'importsShow', params: {id: image.import.id}}" class="preview-container">
                            {{image.import.name}}
                    </router-link>
                </dd>
            </template>
        </dl>
    </div>
</template>

<script>
import { isoFormattedDateToUs } from '../../date-helpers';

export default {
    props: {
        image: {
            type: Object,
            required: true
        },
        updateImage: {
            type: Function,
            required: true,
        },
    },
    data(){
        return {
            completionDateModel: null,
            isEditingCompletionDate: false,
        };
    },
    computed: {
        masterPathSplit(){
            return this.image.master_path.split('/');
        },
    },
    watch: {
        image(){
            this.isEditingCompletionDate = false;
            this.completionDateModel = this.image.completion_date;
        },
    },
    methods: {
        formatIsoDate(date){
            return isoFormattedDateToUs(date);
        },
        updateImageCompletionDate(){
            const data = {
                image: {
                    id: this.image.id,
                    completion_date: this.completionDateModel,
                },
            };
            this.updateImage(data).then((response)=>{
                this.image.completion_date = response.data.completion_date;
                this.isEditingCompletionDate = false;
            });
        },
        enableEditCompletionDate(){
            this.isEditingCompletionDate = true;
        },
        cancelEditCompletionDate(){
            this.isEditingCompletionDate = false;
        },
    }
};
</script>