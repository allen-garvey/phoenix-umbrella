
export function fetchJson(url){
    return fetch(url).then((data) => {return data.json();}).then((json) => {return json.data;});
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