<template>
    <div :class="$style.searchBarContainer">
        <form @submit.prevent="onFormSubmitted">
            <input 
                type="search" 
                placeholder="Search tracks" 
                v-model="searchValue"
                aria-labelledby="Search tracks"
            />
            <button 
                type="submit" 
                :disabled="!searchValue" 
                :class="$style.button"
            >
                Search
            </button>
        </form>
    </div>
</template>

<style lang="scss" module>
    @import '~seren-styles/variables';

    .searchBarContainer{
		display: flex;
		justify-content: center;

		& > *{
			font-size: 16px;
		}
    }
    
    .button {
        color: $accent_color_text;
        background: rgba(0,0,0,0);
        border: solid 1px $accent_color_text;
        border-radius: 2px;

        &[disabled]{
            color: $outline_button_disabled_color;
            border-color: $outline_button_disabled_color;
            cursor: not-allowed;
        }
        &:hover:enabled{
            color: white;
            background: $accent_color_text;
        }
        &:active{
            border-color: $accent_color_text_darker;
            color: white;
            background: $accent_color_text_darker;
        }
    }
</style>

<script>
export default {
    props: {
        initialValue: {
            type: String,
            required: true,
        },

    },
    data(){
        return {
            searchValue: '',
        };
    },
    created(){
        this.searchValue = this.initialValue;
    },
    watch: {
        initialValue(newValue){
            this.searchValue = newValue;
        },
    },
    methods: {
        onFormSubmitted(){
            this.$router.push({name: 'searchTracks', query: { q: this.searchValue }});
        },
    },
};
</script>