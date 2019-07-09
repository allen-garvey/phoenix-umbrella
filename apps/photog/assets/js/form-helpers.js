export function toApiResource(item){
    const resource = {};
    for(const key in item){
        const resourceKeyName = key;
        resource[resourceKeyName] = nullifyValue(item[key]);
    }

    return resource;
}

//returns null for empty strings or other values that should be null
//when sending to api
function nullifyValue(value){
    if(value === '' || value === undefined){
        return null;
    }
    return value;
}
        