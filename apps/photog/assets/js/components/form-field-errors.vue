<template>
    <div v-if="errorsFlattened.length > 0" class="alert alert-danger form-field-errors">
        <ul>
            <li v-for="(error, i) in errorsFlattened" :key="i">{{error}}</li>
        </ul>
    </div>
</template>

<script>
import vue from 'vue';

import { fetchJson, sendJson } from 'umbrella-common-js/ajax.js';

export default {
    name: 'Form-Field-Errors',
    props: {
        errors: {
            type: Array,
        },
    },
    data() {
        return {
        }
    },
    computed: {
        errorsFlattened(){
            if(!this.isArray(this.errors)){
                return [];
            }
            //note edge and safari < 12 do not have flatMap
            return this.errors.flatMap((item)=>{
                if(this.isArray(item)){
                    return item;
                }
                if(item !== undefined){
                    return [item];
                }
                return [];
            });
        },
    },
    methods: {
        isArray(variable){
            return variable instanceof Array;
        },
    }
}
</script>
