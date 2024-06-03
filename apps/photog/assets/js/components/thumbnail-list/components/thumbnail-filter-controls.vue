<template>
<div :class="$style.thumbnailFilterControlsContainer">
    <fieldset v-if="enableAlbumFilter">
        <label for="album_filter_mode_select">Album</label>
        <select class="form-control" id="album_filter_mode_select" v-model="localAlbumFilterMode">
            <option :value="1">All</option>
            <option :value="2">Uncategorized</option>
            <option :value="3">Categorized</option>
        </select>
    </fieldset>
    <fieldset v-if="enablePersonFilter">
        <label for="person_filter_mode_select">Person</label>
        <select class="form-control" id="person_filter_mode_select" v-model="localPersonFilterMode">
            <option :value="1">All</option>
            <option :value="2">Uncategorized</option>
            <option :value="3">Categorized</option>
        </select>
    </fieldset>
</div>
</template>

<style lang="scss" module>
    .thumbnailFilterControlsContainer{
        display: flex;
        flex-wrap: wrap;
        margin-bottom: 2em;

        //have to do this on second child,
        //since sometimes might have only 1 filter shown
        & > *:nth-child(2){
            margin-left: 4em;
        }

        fieldset{
            border: none;
            padding: 0;
        }

        legend{
            font-weight: bold;
        }
        input[type="radio"]{
            margin-right: 1em;
        }
    }
</style>

<script>
import {ALBUM_FILTER_QUERY_PARAM_NAME, PERSON_FILTER_QUERY_PARAM_NAME} from '../../../routes-helpers.js';

export default {
    props: {
        albumFilterMode: {
            type: Number,
            required: true,
        },
        enableAlbumFilter: {
            type: Boolean,
            default: false,
        },
        personFilterMode: {
            type: Number,
            required: true,
        },
        enablePersonFilter: {
            type: Boolean,
            default: false,
        },
    },
    data(){
        return {
            localAlbumFilterMode: -1,
            localPersonFilterMode: -1,
        };
    },
    watch: {
        albumFilterMode(newValue, oldValue){
            if(newValue != oldValue){
                this.localAlbumFilterMode = newValue;
            }
        },
        personFilterMode(newValue, oldValue){
            if(newValue != oldValue){
                this.localPersonFilterMode = newValue;
            }
        },
        localAlbumFilterMode(newValue, oldValue){
            if(newValue != oldValue){
                const query = {
                    ...this.$router.currentRoute._rawValue.query,
                    [ALBUM_FILTER_QUERY_PARAM_NAME]: newValue
                }
                this.$router.replace({query});
                this.$emit('update:albumFilterMode', newValue);
            }
        },
        localPersonFilterMode(newValue, oldValue){
            if(newValue != oldValue){
                const query = {
                    ...this.$router.currentRoute._rawValue.query,
                    [PERSON_FILTER_QUERY_PARAM_NAME]: newValue
                }
                this.$router.replace({query});
                this.$emit('update:personFilterMode', newValue);
            }
        },
    },
    created(){
        //since watch is not called when component created
        this.localAlbumFilterMode = this.albumFilterMode;
        this.localPersonFilterMode = this.personFilterMode;
    }
}
</script>

