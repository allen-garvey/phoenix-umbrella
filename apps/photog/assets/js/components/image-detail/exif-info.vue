<template>
    <image-info-section
        heading="Exif"
    >
        <button 
            v-if="shouldShowRequestButton" 
            class="btn btn-sm btn-outline-success"
            @click="$emit('exif-requested')"
        >
            Display
        </button>
        <template 
            v-for="sectionKey in Object.keys(imageExif).sort()"
            :key="sectionKey" 
        >
            <h4 
                :class="$style['image-exif-heading']"
            >
                {{formatExifPropertyName(sectionKey)}}
            </h4>
            <dl>
                <template 
                    v-for="sectionPropertyKey in Object.keys(imageExif[sectionKey]).sort()"
                    :key="`${sectionKey}_${sectionPropertyKey}`"
                >
                    <dt 
                        
                        v-if="imageExif[sectionKey][sectionPropertyKey]"
                    >
                            {{formatExifPropertyName(sectionPropertyKey)}}
                    </dt>
                    <dd 
                        v-if="imageExif[sectionKey][sectionPropertyKey]"
                    >
                        {{imageExif[sectionKey][sectionPropertyKey]}}
                    </dd>
                </template>
            </dl>
        </template>
    </image-info-section>
</template>

<style lang="scss" module>
    .image-exif-heading{
		margin: 0 0 0.5rem;
	}
</style>

<script>
import ImageInfoSection from './image-info-section.vue';

//from: https://stackoverflow.com/questions/1026069/how-do-i-make-the-first-letter-of-a-string-uppercase-in-javascript
function capitalizeFirstLetter(string){
    return string.charAt(0).toUpperCase() + string.slice(1);
}

export default {
    props: {
        imageExif: {
            type: Object,
            required: true,
        }, 
        shouldShowRequestButton: {
            type: Boolean,
            default: false,
        },
    },
    components: {
        ImageInfoSection,
    },
    methods: {
        formatExifPropertyName(s){
            return capitalizeFirstLetter(s).replace(/_/g, ' ');
        },
    }
};
</script>