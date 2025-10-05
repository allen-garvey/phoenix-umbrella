const joinUrlParts = urlParts => urlParts.filter(part => !!part).join('/');

export const thumbnailUrlFor = (path, prefix = '') =>
    path ? joinUrlParts(['/media/thumbnails', prefix, encodeURI(path)]) : '';

export const getMasterUrl = (image, prefix = '') =>
    joinUrlParts(['/media/images', prefix, encodeURI(image.master_path)]);
