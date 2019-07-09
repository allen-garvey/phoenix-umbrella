<template>
    <div class="form-group">
        <label :for="id">{{label}}</label>
        <textarea :id="id" class="form-control" v-model="internalValue" :rows="textareaRows" v-if="isTextarea"></textarea>
        <input :id="id" class="form-control" :type="inputType" v-model="internalValue" v-if="!isTextarea" />
        <Form-Field-Errors :errors="errors" />
    </div>
</template>

<script>
import FormFieldErrors from './form-field-errors.vue';

export default {
    name: 'Form-Input',
    props: {
        id: {
            type: String,
            required: true,
        },
        value: {
            required: true,
        },
        inputType: {
            type: String,
            default: 'text',
        },
        textareaRows: {
            type: Number,
            default: 1,
        },
        label: {
            type: String,
            required: true,
        },
        errors: {
            type: Array
        },
    },
    components: {
        'Form-Field-Errors': FormFieldErrors,
    },
    created(){
        //have to create copy, otherwise have problem with mutating
        //object properties directly
        this.internalValue = this.value;
    },
    data(){
        return {
            internalValue: 0,
        };
    },
    computed: {
        isTextarea(){
            return this.inputType === 'textarea';
        }
    },
    watch: {
        internalValue(newValue){
            this.$emit('input', newValue);
        },
    },
}
</script>

