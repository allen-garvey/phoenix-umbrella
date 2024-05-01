const TEN_MINUTES_IN_MILLISECONDS = 600_000;

let b2DownloadInfo = null;
let lastFetchedTime = 0;

export const getCachedValue = () => {
    if (performance.now() - lastFetchedTime > TEN_MINUTES_IN_MILLISECONDS) {
        return null;
    }
    return b2DownloadInfo;
};

export const updateCachedValue = (value) => {
    b2DownloadInfo = value;
    lastFetchedTime = performance.now();
};

export const constructB2UrlResponse = (
    image,
    b2DownloadInfo,
    b2BucketPrefix
) => {
    if (!b2DownloadInfo) {
        return null;
    }
    return {
        url: `${b2DownloadInfo.download_url}/file/${b2BucketPrefix}/${image.master_path}?Authorization=${b2DownloadInfo.download_token}`,
        imageId: image.id,
    };
};
