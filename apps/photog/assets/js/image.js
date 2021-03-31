export function thumbnailUrlFor(path){
    return `/media/thumbnails/${encodeURI(path)}`;
}

export const getMasterUrl = (image) => `/media/images/${encodeURI(image.master_path)}`;
