import { fetchJson } from 'umbrella-common-js/ajax.js';

function fetchIntoCache(apiUrl, cacheMap, mapId, options={}){
    const isCached = !options.forceRefresh && cacheMap.has(mapId);

    if(options.isPaginated){
        const cachedLength = isCached ? cacheMap.get(mapId).offset + cacheMap.get(mapId).limit : 0;
        const desiredLength = options.offset + options.limit;
        
        if(cachedLength >= desiredLength){
            return Promise.resolve(cacheMap.get(mapId).data.slice(0, desiredLength));
        }

        const url = new URL(apiUrl, window.location);
        const query = url.search ? url.search + '&' : '?';
        const paginatedUrl = `${url.pathname}${query}offset=${options.offset}&limit=${options.limit}`;
        return fetchJson(paginatedUrl).then((data)=>{
            const oldData = cacheMap.has(mapId) ? cacheMap.get(mapId).data : [];
            const combinedData = oldData.concat(data);
            cacheMap.set(mapId, {data: combinedData, offset: options.offset, limit: options.limit});
            return combinedData;
        });
    }

    if(isCached){
        return Promise.resolve(cacheMap.get(mapId).data);
    }

    return fetchJson(apiUrl).then((data)=>{
        cacheMap.set(mapId, {data});
        return data;
    });
}



export default {
    fetchIntoCache,
};