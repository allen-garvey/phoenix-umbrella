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