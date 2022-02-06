<template>
    <dt :class="$style.label">Completion Date</dt>
    <dd>
        <div v-show="!isEditingCompletionDate">{{formatIsoDate(image.completion_date)}}</div>
        <div 
            v-if="isEditingCompletionDate" 
            :class="$style.editContainer"
        >
            <div class="form-group">
                <input type="date" class="form-control" v-model="completionDateModel"/>
            </div>
            <div>
                <button @click="cancelEditCompletionDate()" class="btn btn-outline-secondary btn">Cancel</button>
                <button @click="updateImageCompletionDate()" class="btn btn-success btn">Save</button>
            </div>
        </div>
        <div v-show="!isEditingCompletionDate">
            <button @click="enableEditCompletionDate()" class="btn btn-outline-primary btn-xs">Edit</button>
        </div>
    </dd>
</template>

<style lang="scss" module>
.label{
    margin-bottom: 1.5em;
}
.editContainer{
    display: flex;
    .form-control{
        max-width: 14em;
    }
    .form-group{
        margin-right: 1rem;
    }
}
</style>

<script>
import { isoFormattedDateToUs } from '../../date-helpers';

export default {
    props: {
        image: {
            type: Object,
            required: true,
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
    },
    watch: {
        image(){
            this.isEditingCompletionDate = false;
            this.completionDateModel = this.image.completion_date;
        },
    },
    created(){
        this.completionDateModel = this.image.completion_date;
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