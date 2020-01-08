const history = window.history;
const BASE_URL = `${window.location.origin}${window.location.pathname}`;

export const IMAGE_QUERY_STRING_KEY = 'image';

export function setImageUrl(image_slug){
    const url = `${BASE_URL}?${IMAGE_QUERY_STRING_KEY}=${image_slug}`;
    history.replaceState({image_slug}, '', url);
}

export function clearImageUrl(){
    history.replaceState({}, '', BASE_URL);
}