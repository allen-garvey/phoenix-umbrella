import ThumbnailList from './components/thumbnail-list.vue';

export function getOptionalParams(routeParams, optionalParams, props={}){
    for(const param of optionalParams){
        if(param in routeParams){
            props[param] = routeParams[param];
        }
    }
    return props;
}

export function buildImagesIndexVariant(path, name, props={}){
    return { 
        path,
        name, 
        component: ThumbnailList,
        props: (route) => {
            const defaultProps = {
                showRouteFor: (item, _model)=>{
                    return {
                        name: 'imagesShow',
                        params: {
                            id: item.id,
                            image_id: item.id,
                        },
                    };
                },
            }; 
            return Object.assign(defaultProps, props);
        },
    };
}

export function buildImportsShowVariant(path, name){
    return { 
        path,
        name, 
        component: ThumbnailList,
        props: (route) => {
            const props = {
                apiPath: route.path,
                itemsListKey: 'images',
                enableHasAlbumFilter: true,
                enableHasPersonFilter: true,
                enableBatchSelectImages: true,
                getDescription: (importModel) => importModel.notes,
                editItemLinkFor: (model) => ({name: 'importsEdit', params: {id: model.id}}),
                showRouteFor: (item, model)=>{
                    return {
                        name: 'importImagesShow',
                        params: {
                            import_id: model.id,
                            image_id: item.id,
                        },
                    };
                },
            };
            return props;
        },
    };
};