import { sendJson } from 'umbrella-common-js/ajax.js';

export function initDeleteButtons(){
    document.querySelectorAll('[data-confirm][data-method="delete"]').forEach((deleteButton)=>{
        deleteButton.addEventListener('click', (e)=>{
            e.preventDefault();
            
            const data = deleteButton.dataset;
            if(!confirm(data.confirm)){
                return;
            }
            const csrf = data.csrf;
            const url = data.to;

            sendJson(url, csrf, 'DELETE').then(()=>{
                window.location.reload();
            }).catch(()=>{
                window.location.reload();
            });
        });
    });
}