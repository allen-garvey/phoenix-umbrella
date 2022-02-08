<template>
    <dt :class="$style.label">
        {{ label }}
    </dt>
    <dd>
        <slot v-if="!isEditing">
        </slot>
        <div 
            v-if="isEditing" 
            :class="$style.editContainer"
        >
            <form @submit.prevent="update()">
                <div class="form-group">
                    <input 
                        :type="inputType" 
                        class="form-control" 
                        v-model="model"
                        ref="input"
                    />
                </div>
                <div>
                    <button @click="cancelEdit()" type="button" class="btn btn-outline-secondary btn">Cancel</button>
                    <button type="submit" class="btn btn-success btn">Save</button>
                </div>
            </form>
        </div>
        <span v-show="!isEditing">
            <button @click="edit()" class="btn btn-outline-primary btn-xs">Edit</button>
        </span>
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
import { nextTick } from 'vue';

export default {
    props: {
        label: {
            type: String,
            required: true,
        },
        inputType: {
            type: String,
            default: 'text',
        },
        modelKey: {
            type: String,
            required: true,
        },
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
            model: null,
            isEditing: false,
        };
    },
    computed: {
    },
    watch: {
        image(){
            this.isEditing = false;
            this.model = this.image[this.modelKey];
        },
    },
    created(){
        this.model = this.image[this.modelKey];
    },
    methods: {
        update(){
            const data = {
                image: {
                    id: this.image.id,
                    [this.modelKey]: this.model,
                },
            };
            this.updateImage(data).then((response)=>{
                this.isEditing = false;
            });
        },
        edit(){
            this.isEditing = true;
            nextTick().then(() => {
                this.$refs.input.focus();
            });
        },
        cancelEdit(){
            this.isEditing = false;
        },
    }
};
</script>