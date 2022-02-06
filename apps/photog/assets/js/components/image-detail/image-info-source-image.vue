<template>
    <dt :class="$style.label">
        Source Image
    </dt>
    <dd>
        <router-link
            :to="{ name: 'imagesShow', params: { id: image.source_image_id, image_id: image.source_image_id } }"
            v-if="image.source_image_id && !isEditing"
        >
            View source image
        </router-link>
        <div 
            v-if="isEditing" 
            :class="$style.editContainer"
        >
            <form @submit.prevent="update()">
                <div class="form-group">
                    <input 
                        type="number" 
                        class="form-control" 
                        v-model="sourceImageIdModel"
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
            sourceImageIdModel: null,
            isEditing: false,
        };
    },
    computed: {
    },
    watch: {
        image(){
            this.isEditing = false;
            this.sourceImageIdModel = this.image.source_image_id;
        },
    },
    created(){
        this.sourceImageIdModel = this.image.source_image_id;
    },
    methods: {
        update(){
            const data = {
                image: {
                    id: this.image.id,
                    source_image_id: this.sourceImageIdModel,
                },
            };
            this.updateImage(data).then((response)=>{
                this.image.source_image_id = response.data.source_image_id;
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