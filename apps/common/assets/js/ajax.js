/*
 * Common functions to fetch and send json to phoenix api 
 */

export function fetchJson(url){
    return fetch(url)
        .then(data => data.json())
        .then(json => json.data);
}

export function sendJson(url, csrfToken='', method='POST', data={}){
    return fetch(url, 
        {
            method,
            body: JSON.stringify(data),
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': csrfToken,
            },

        }).then(data=>data.json());
}

export const fetchText = (url) => fetch(url).then(res => res.text());