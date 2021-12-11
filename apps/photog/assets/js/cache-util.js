import { fetchJson } from 'umbrella-common-js/ajax.js';

function fetchIntoCache(url, cacheMap, mapId, options={}){
    if(!options.forceRefresh && cacheMap.has(mapId)){
        return Promise.resolve(cacheMap.get(mapId));
    }
    return fetchJson(url).then((data)=>{
        cacheMap.set(mapId, data);
        return data;
    });
}



export default {
    fetchIntoCache,
};