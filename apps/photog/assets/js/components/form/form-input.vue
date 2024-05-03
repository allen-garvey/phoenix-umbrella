<template>
    <div class="form-group">
        <label :for="id">{{label}}</label>
        <textarea :id="id" class="form-control" v-model="internalValue" :rows="textareaRows" v-if="isTextarea"></textarea>
        <input :id="id" :class="inputClass" :type="inputType" v-model="internalValue" v-if="!isTextarea" />
        <Form-Field-Errors :errors="errors" />
    </div>
</template>

<script>
import FormFieldErrors from './form-field-errors.vue';

export default {
    props: {
        id: {
            type: String,
            required: true,
        },
        modelValue: {
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
        FormFieldErrors,
    },
    created(){
        //have to create copy, otherwise have problem with mutating
        //object properties directly
        this.internalValue = this.modelValue;
    },
    data(){
        return {
            internalValue: 0,
        };
    },
    computed: {
        isTextarea(){
            return this.inputType === 'textarea';
        },
        inputClass(){
            if(this.inputType === 'checkbox'){
                return 'form-check-input';
            }
            return 'form-control';
        },
    },
    watch: {
        internalValue(newValue){
            this.$emit('update:modelValue', newValue);
        },
    },
}
</script>

