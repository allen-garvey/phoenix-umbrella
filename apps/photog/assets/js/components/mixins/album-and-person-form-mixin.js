export function albumAndPersonFormMixinBuilder() {
    return {
        props: {
            miniThumbnailUrlFor: {
                type: Function,
                required: true,
            },
        },
        data() {
            return {
                previousRoute: null,
            };
        },
        computed: {
            shouldShowCoverImageInput() {
                return this.imagesInModel.length === 0;
            },
            imagesInModel() {
                if (this.isCreateForm) {
                    return JSON.parse(history.state.images || '[]');
                }
                return [];
            },
            hasImages() {
                return this.imagesInModel.length > 0;
            },
            successRedirect() {
                return history.state.successRedirect;
            },
        },
    };
}
