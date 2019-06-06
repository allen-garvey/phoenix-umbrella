import { thumbnailUrlFor } from '../../image.js';
import CoverImageFormInput from '../cover-image-form-input.vue';

export function albumAndPersonFormMixinBuilder(){
    return {
        props: {
            //for when creating a resource with images
            images: {
                type: Array
            },
            successRedirect: {
                type: Function
            },
        },
        components: {
            'Cover-Image-Form-Input': CoverImageFormInput,
        },
        computed: {
            shouldShowCoverImageInput(){
                return this.imagesInModel.length === 0;
            },
            imagesInModel(){
                if(this.isEditForm){
                    return this.model.images;
                }
                else if(this.isCreateForm && this.images){
                    return this.images;
                }
                return [];
            },
        },
        methods: {
            thumbnailUrlFor(image){
                return thumbnailUrlFor(image.mini_thumbnail_path);
            },
        },
    };
}