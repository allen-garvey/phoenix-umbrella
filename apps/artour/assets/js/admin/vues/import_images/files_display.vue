<template>
    <div :class="$style['images-list-container']">
        <div 
            class="alert alert-danger" 
            v-show="errors" 
            ref="errorAlert"
        >
            <p>Oops, something went wrong! Please check the errors below.</p>
        </div>
        <ul>
            <li v-for="(image, i) in images" :key="i">
                <div :class="$style['image-form']">
                    <div class="form-group">
                        <label class="control-label" :for="`image_${i}_title`">Title</label>
                        <input class="form-control" type="text" :id="`image_${i}_title`" :value="image.title" @change="valueChanged($event, i, 'title')" />
                        <form-input-errors :errors="getError(i, 'title')" />
                    </div>
                    <div class="form-group">
                        <label class="control-label" :for="`image_${i}_slug`">Slug</label>
                        <input class="form-control" type="text" :id="`image_${i}_slug`" :value="image.slug" @change="valueChanged($event, i, 'slug')" />
                        <form-input-errors :errors="getError(i, 'slug')" />
                    </div>
                    <div class="form-group">
                        <label class="control-label" :for="`image_${i}_description`">Description</label>
                        <input class="form-control" type="text" :id="`image_${i}_description`" @change="valueChanged($event, i, 'description')" />
                        <form-input-errors :errors="getError(i, 'description')" />
                    </div>
                    <div class="form-group">
                        <label class="control-label" :for="`image_${i}_format`">Format</label>
                        <select class="form-control" :id="`image_${i}_format`" :value="image.format_id" @change="valueChanged($event, i, 'format_id')">
                            <option v-for="(format, i) in formats" :key="i" :value="format.id">{{format.name}}</option>
                        </select>
                        <form-input-errors :errors="getError(i, 'format_id')" />
                    </div>
                    <div class="form-group">
                        <label class="control-label" :for="`image_${i}_completion_date`">Completion date</label>
                        <input class="form-control" type="date" :id="`image_${i}_completion_date`" @change="valueChanged($event, i, 'completion_date')" />
                        <form-input-errors :errors="getError(i, 'completion_date')" />
                    </div>
                    <div 
                        class="form-group"
                        :class="$style['form-group-fixed']"
                    >
                        <label>Filename large</label>{{image.filename_large}}
                    </div>
                    <div 
                        class="form-group"
                        :class="$style['form-group-fixed']"
                    >
                        <label>Filename medium</label>{{image.filename_medium}}
                    </div>
                    <div 
                        class="form-group"
                        :class="$style['form-group-fixed']"
                    >
                        <label>Filename small</label>{{image.filename_small}}
                    </div>
                    <div 
                        class="form-group"
                        :class="$style['form-group-fixed']"
                    >
                        <label>Filename thumbnail</label>{{image.filename_thumbnail}}
                    </div>
                </div>
                <figure>
                    <img :src="imageFiles[i].src" v-if="imageFiles[i].src"/>
                </figure>
            </li>
        </ul>
        <div :class="$style['button-container']">
            <button class="btn btn-success" @click="save()">Save</button>
        </div>
    </div>
</template>

<style lang="scss" module>
    .images-list-container{
        ul{
            padding-left: 0;
            list-style-type: none;
        }
        li{
            display: flex;
            justify-content: space-between;
            padding: 2em 0;
            border-bottom: 1px solid #e5e5e5;

            &:last-of-type{
                padding-bottom: 0;
                border-bottom: 0;
            }

            .image-form{
                flex-basis: 100%;
                padding-right: 2em;
            }
            figure{
                flex-basis: 300px;
            }
        }
        .form-group-fixed{
            label{
                min-width: 165px;
            }
        }
        .button-container{
            display: flex;
            justify-content: flex-end;
        }
        img{
            max-width: 300px;
            max-height: 240px;
        }
    }
</style>

<script>
import FormInputErrors from '../form_input_errors.vue';

export default {
    props: {
        images: {
            type: Array,
            required: true,
        },
        imageFiles: {
            type: Array,
            required: true,
        },
        formats: {
            type: Array,
            required: true,
        },
        valueChanged: {
            type: Function,
            required: true,
        },
        save: {
            type: Function,
            required: true,
        },
        errors: {
            type: Array,
        },
    },
    components: {
        FormInputErrors,
    },
    methods: {
        getError(index, key){
            if(!this.errors || !this.errors[index] || !this.errors[index][key]){
                return [];
            }
            return this.errors[index][key];
        },
    }
};
</script>