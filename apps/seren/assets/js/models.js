import { fetchJson } from 'umbrella-common-js/ajax.js';
import { API_URL_BASE } from './api-helpers';

export const loadModelAndMap = (modelName, target, itemsMap) => {
    const url = `${API_URL_BASE}/${modelName}`;
    return fetchJson(url).then(items => {
        target[modelName] = items;

        items.forEach(item => {
            itemsMap.set(item.id, item);
        });
    });
};
