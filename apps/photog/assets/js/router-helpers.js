export function getOptionalParams(routeParams, optionalParams, props={}){
    for(const param of optionalParams){
        if(param in routeParams){
            props[param] = routeParams[param];
        }
    }
    return props;
}

// export function mergeObjects(objectsList){
//     const props = {};
//     for(const object of objectsList){
//         for(const key in object){
//             props[key] = object[key];
//         }
//     }
//     return props;
// }