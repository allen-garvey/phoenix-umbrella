<template>
    <div class="image-show-info-section" >
        <h3 class="image-info-section-heading">Exif</h3>
        <template v-for="sectionKey in Object.keys(imageExif).sort()">
            <h4 :key="sectionKey+'_heading'" class="image-exif-heading">{{formatExifPropertyName(sectionKey)}}</h4>
            <dl :key="sectionKey+'_list'">
                <template v-for="sectionPropertyKey in Object.keys(imageExif[sectionKey]).sort()">
                    <dt :key="`${sectionKey}_${sectionPropertyKey}_dt`" v-if="imageExif[sectionKey][sectionPropertyKey]">{{formatExifPropertyName(sectionPropertyKey)}}</dt>
                    <dd :key="`${sectionKey}_${sectionPropertyKey}_dd`" v-if="imageExif[sectionKey][sectionPropertyKey]">{{imageExif[sectionKey][sectionPropertyKey]}}</dd>
                </template>
            </dl>
        </template>
    </div>
</template>

<script>
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
        
    },
    computed: {
    },
    methods: {
        formatExifPropertyName(s){
            return capitalizeFirstLetter(s).replace(/_/g, ' ');
        },
    }
};
</script>