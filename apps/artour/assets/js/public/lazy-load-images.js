/**
 * Adapted from: https://blog.bitsrc.io/lazy-loading-images-using-the-intersection-observer-api-5a913ee226d
 */

export function initializeImageLazyLoading(){
    const imageObserver = new IntersectionObserver((entries, imgObserver) => {
        entries.forEach((entry) => {
            if(entry.isIntersecting){
                const lazyImage = entry.target
                lazyImage.src = lazyImage.dataset.src
                lazyImage.classList.remove('lazy-image-placeholder');
                imgObserver.unobserve(lazyImage);
            }
        });
    });
    document.querySelectorAll('img[data-src]').forEach((img) => {
        imageObserver.observe(img);
    });
}