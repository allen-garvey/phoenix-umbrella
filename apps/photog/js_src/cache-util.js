import { fetchJson } from './request-helpers.js';

function fetchIntoCache(url, cacheMap, mapId, forceRefresh=false){
    if(!forceRefresh && cacheMap.has(mapId)){
        return new Promise((resolve)=>{
            resolve(cacheMap.get(mapId));
        });
    }
    return fetchJson(url).then((data)=>{
        cacheMap.set(mapId, data);
        return data;
    });
}



export default {
    fetchIntoCache,
};