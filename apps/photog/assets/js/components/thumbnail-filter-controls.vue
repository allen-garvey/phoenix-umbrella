<template>
<div :class="$style['thumbnail-filter-controls-container']">
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
    .thumbnail-filter-controls-container{
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
export default {
    name: 'Thumbnail-Filter-Controls',
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
                this.$emit('album-filter-mode-changed', newValue);
            }
        },
        localPersonFilterMode(newValue, oldValue){
            if(newValue != oldValue){
                this.$emit('person-filter-mode-changed', newValue);
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

