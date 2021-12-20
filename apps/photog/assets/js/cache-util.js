import { fetchJson } from 'umbrella-common-js/ajax.js';

function fetchIntoCache(apiUrl, cacheMap, mapId, options={}){
    if(options.isPaginated){
        const desiredLength = options.offset + options.limit;
        
        if(!options.forceRefresh && cacheMap.has(mapId) && cacheMap.get(mapId).length >= desiredLength){
            return Promise.resolve(cacheMap.get(mapId).slice(0, desiredLength));
        }

        const url = new URL(apiUrl, window.location);
        const query = url.search ? url.search + '&' : '?';
        const paginatedUrl = `${url.pathname}${query}offset=${options.offset}&limit=${options.limit}`;
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

    return fetchJson(apiUrl).then((data)=>{
        cacheMap.set(mapId, data);
        return data;
    });
}



export default {
    fetchIntoCache,
};