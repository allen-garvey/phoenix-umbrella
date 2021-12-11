import { fetchJson } from 'umbrella-common-js/ajax.js';

function fetchIntoCache(url, cacheMap, mapId, options={}){
    if(options.isPaginated){
        const paginatedUrl = `${url}?offset=${options.offset}&limit=${options.limit}`;
        return fetchJson(paginatedUrl).then((data)=>{
            const oldData = cacheMap.has(mapId) ? cacheMap.get(mapId) : [];
            const combinedData = oldData.concat(data);
            cacheMap.set(mapId, combinedData);
            return combinedData;
        });
    }
    
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