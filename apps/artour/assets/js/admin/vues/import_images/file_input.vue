<template>
    <div>
        <input 
            type="file" 
            multiple 
            ref="fileInput" 
            id="file_input" 
            @change="filesSelected($event)"
        />
        <label 
            for="file_input" 
            :class="fileLabelCLass" 
            @drop.prevent="filesDropped($event)" 
            @dragover.prevent="doNothing()" 
            @dragenter="dragStart()" 
            @dragleave="dragLeave()" 
            @dragend.prevent="dragLeave()"
        >
            <div>
                <!-- from: https://material.io/tools/icons/?icon=cloud_upload&style=baseline -->
                <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24"><path d="M0 0h24v24H0z" fill="none"/><path d="M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM14 13v4h-4v-4H7l5-5 5 5h-3z"/></svg>
                <strong>Choose an image file</strong><span> or drag it here</span>
            </div>
        </label>
    </div>
</template>

<style lang="scss" module>
    /*
    * File input
    * based on: https://tympanus.net/codrops/2015/09/15/styling-customizing-file-inputs-smart-way
    * and
    * https://css-tricks.com/drag-and-drop-file-uploading/
    */
    input[type='file'] {
        width: 0.1px;
        height: 0.1px;
        opacity: 0;
        overflow: hidden;
        position: absolute;
        z-index: -1;

        & + label {
            cursor: pointer;
            font-size: 1.25em;
            display: flex;
            justify-content: center;
            align-items: center;
            border: 2px dashed #333;
            width: 100%;
            min-height: 300px;
            span{
                font-weight: 400;
            }
            svg{
                display: block;
                margin: 0 auto;
                height: 80px;
                width: 80px;
            }
        }
        
        &:focus + label,
        & + label:hover,
        & + label.dragged-over {
            background-color: #e8e8e8;
        }
        &:focus + label{
            outline: 1px dotted #000;
            outline: -webkit-focus-ring-color auto 5px;
        }
    }
</style>

<script>
export default {
    props: {
        filesUploaded: {
            type: Function,
            required: true,
        },
    },
    data(){
        return {
            // need drag enter count since dragLeave triggered on child elements
            // https://stackoverflow.com/questions/7110353/html5-dragleave-fired-when-hovering-a-child-element
            dragEnterCount: 0,
        };
    },
    computed: {
        fileLabelCLass(){
            return {
                [this.$style['dragged-over']]: this.dragEnterCount > 0,
            };
        },
    },
    methods: {
        doNothing(){
            //required to have drag over do something
        },
        dragStart(){
            this.dragEnterCount++;
        },
        dragLeave(){
            this.dragEnterCount--;
        },
        filesSelected(event){
            this.filesUploaded(this.$refs.fileInput.files);
        },
        filesDropped(event){
            this.dragEnterCount = 0;
            this.filesUploaded(event.dataTransfer.files);
        },
    }
};
</script>