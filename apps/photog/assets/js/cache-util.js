import { fetchJson } from 'umbrella-common-js/ajax.js';

/**
 * 
 * interface options {
 *      forceRefresh: boolean; don't use cache
 *      onlyIfCached: boolean; only return data from cache if available, don't fetch, superceded by forceRefresh
 *      isPaginated: boolean; if api route is paginated; the way pagination works is that the total number of items in the cache are returned up to the total number of items requested determined by offset and limit
 *      offset: number; number to start at for api pagination, zero indexed
 *      limit: number; maximum number of items to return starting at pagination
 * }
 */
function fetchIntoCache(apiUrl, cacheMap, mapId, options={}){
    const isCached = !options.forceRefresh && cacheMap.has(mapId);

    if(options.isPaginated){
        const cachedLength = isCached ? cacheMap.get(mapId).offset + cacheMap.get(mapId).limit : 0;
        const desiredLength = options.offset + options.limit;
        
        // check if cache contains enough items to fulfill request
        if(cachedLength >= desiredLength){
            return Promise.resolve(cacheMap.get(mapId).data.slice(0, desiredLength));
        }

        if(options.onlyIfCached){
            return Promise.resolve(null);
        }

        const adjustedOffset = Math.max(options.offset, cachedLength);
        const adjustedLimit = desiredLength - cachedLength;

        const url = new URL(apiUrl, window.location);
        const query = url.search ? url.search + '&' : '?';
        const paginatedUrl = `${url.pathname}${query}offset=${adjustedOffset}&limit=${adjustedLimit}`;
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

    if(options.onlyIfCached){
        return Promise.resolve(null);
    }

    return fetchJson(apiUrl).then((data)=>{
        cacheMap.set(mapId, {data});
        return data;
    });
}



export default {
    fetchIntoCache,
};