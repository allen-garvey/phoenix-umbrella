<template>
    <div :class="$style['search-bar-container']">
        <input 
            type="search" 
            placeholder="Search tracks" 
            :value="value"
            @input="$emit('input', $event.target.value)"
            @keyup.enter="onSearchRequested" 
            aria-labelledby="Search tracks"
        />
        <button 
            @click="onSearchRequested" 
            :disabled="!value" 
            :class="$style['outline-button']"
        >
            Search
        </button>
    </div>
</template>

<style lang="scss" module>
    @import '~seren-styles/variables';

    .search-bar-container{
		display: flex;
		justify-content: center;

		& > *{
			font-size: 16px;
		}
    }
    
    .outline-button {
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
        value: {
            type: String,
            required: true,
        },
        onSearchRequested: {
            type: Function,
            required: true,
        },
    },
};
</script>