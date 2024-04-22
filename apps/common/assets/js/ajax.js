/*
 * Common functions to fetch and send json to phoenix api
 */

export class FetchError extends Error {
    constructor(...args) {
        super(...args);
    }
}

export function fetchJson(url) {
    return fetch(url)
        .then((response) => {
            if (response.status >= 400) {
                throw new FetchError(
                    `Fetch response code was ${response.status}`
                );
            }
            return response.json();
        })
        .then((json) => json.data);
}

export function sendJson(url, csrfToken = '', method = 'POST', data = {}) {
    return fetch(url, {
        method,
        body: JSON.stringify(data),
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken,
        },
    }).then((data) => data.json());
}

export const fetchText = (url) => fetch(url).then((res) => res.text());
