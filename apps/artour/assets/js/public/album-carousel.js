import { IMAGE_QUERY_STRING_KEY, setImageUrl, clearImageUrl } from './history';

const FIRST_IMAGE_CLASS = 'first-image';
const LAST_IMAGE_CLASS = 'last-image';
const imageLinks = document.querySelectorAll(
    '[data-slideshow-images] a[data-slideshow-image]'
);
const lightboxImage = document.getElementById('lightboxImage');
const lightboxContainer = document.getElementById('lightbox-container');
const captionBody = document.querySelector('.caption-body');

const slideData = initializeSlideData(imageLinks);
let currentImageIndex = null;
let isLightboxVisible = false;

function initializeSlideData(links) {
    return [...links].map((link) => ({
        caption: link.dataset.caption,
        src: link.dataset.src,
        srcset: link.dataset.srcset,
        id: link.dataset.slug,
    }));
}

function initializeLightbox() {
    const lightboxBackground = document.querySelector('.lightbox-background');
    lightboxBackground.onclick = hideLightbox;

    const closeButton = document.querySelector('.close-window-button');
    closeButton.onclick = hideLightbox;

    //buttons
    const leftButton = document.querySelector('.slideshow-left-button');
    leftButton.onclick = showPreviousImage;

    const rightButton = document.querySelector('.slideshow-right-button');
    rightButton.onclick = showNextImage;
}

//displays image at index
//creates img tag if necessary - used for lazy loading
function setVisibleImageAt(imageIndex) {
    currentImageIndex = imageIndex;

    // hide or show prev / next buttons
    if (imageIndex === 0) {
        lightboxContainer.classList.add(FIRST_IMAGE_CLASS);
    } else {
        lightboxContainer.classList.remove(FIRST_IMAGE_CLASS);
    }

    if (imageIndex === slideData.length - 1) {
        lightboxContainer.classList.add(LAST_IMAGE_CLASS);
    } else {
        lightboxContainer.classList.remove(LAST_IMAGE_CLASS);
    }

    const currentImageData = slideData[imageIndex];

    lightboxImage.src = currentImageData.src;
    lightboxImage.srcset = currentImageData.srcset;

    captionBody.textContent = currentImageData.caption;

    setImageUrl(currentImageData.id);
}

function displayLightbox() {
    if (isLightboxVisible) {
        return;
    }
    isLightboxVisible = true;
    lightboxContainer.classList.remove('hidden');
}

function hideLightbox() {
    isLightboxVisible = false;
    lightboxContainer.classList.add('hidden');
    clearImageUrl();
}

function initializeImageLinkClickHandlers(imageLinks) {
    imageLinks.forEach((el, i) => {
        el.onclick = (e) => {
            e.preventDefault();
            setVisibleImageAt(i);
            displayLightbox();
        };
    });
}

function initializeImageSwipeHandlers() {
    const imagesContainer = document.querySelector(
        '.lightbox-images-container'
    );
    //number of pixels allowed in diagonal between touch start and start end
    const yThreshold = 100;
    //number of pixels need to be swiped in x direction to register as swipe
    const xThreshold = 100;

    let touchStartX = null;
    let touchStartY = null;
    let activeImageContainer = null;

    imagesContainer.addEventListener('touchstart', function (e) {
        // check if pinching to zoom
        if (e.touches.length > 1) {
            activeImageContainer = null;
            return;
        }
        const touch = e.touches[0];
        touchStartX = touch.clientX;
        touchStartY = touch.clientY;
        activeImageContainer = lightboxImage;
    });
    imagesContainer.addEventListener('touchmove', function (e) {
        if (activeImageContainer === null) {
            return;
        }
        const isFirstImage = currentImageIndex === 0;
        const isLastImage = currentImageIndex === slideData.length - 1;
        const touch = e.touches[0];
        const xCoordinate = touch.clientX;

        if (
            (isFirstImage && xCoordinate > touchStartX) ||
            (isLastImage && xCoordinate < touchStartX)
        ) {
            return;
        }

        const diff = xCoordinate - touchStartX;

        activeImageContainer.style.transform = `translateX(${diff}px)`;
    });
    imagesContainer.addEventListener('touchend', function (e) {
        if (activeImageContainer === null) {
            return;
        }
        const touch = e.changedTouches[0];
        const touchEndX = touch.clientX;
        const touchEndY = touch.clientY;
        let thresholdMet = true;

        const yDifference = Math.abs(touchEndY - touchStartY);
        if (yDifference > yThreshold) {
            thresholdMet = false;
        }
        const xDifference = Math.abs(touchEndX - touchStartX);
        if (xDifference < xThreshold) {
            thresholdMet = false;
        }

        if (thresholdMet) {
            //swiped right, show previous image
            if (touchEndX > touchStartX) {
                showPreviousImage();
            } else {
                //swiped left, show next image
                showNextImage();
            }
        }

        activeImageContainer.style.transform = 'translateX(0px)';
    });
}

function initializeKeyboardShortcuts() {
    document.onkeydown = (e) => {
        if (!isLightboxVisible) {
            return;
        }
        switch (e.key) {
            case 'Escape':
                hideLightbox();
                break;
            case 'ArrowRight':
                showNextImage();
                break;
            case 'ArrowLeft':
                showPreviousImage();
                break;
        }
    };
}

function showNextImage() {
    if (currentImageIndex >= slideData.length - 1) {
        return;
    }
    setVisibleImageAt(currentImageIndex + 1);
}
function showPreviousImage() {
    if (currentImageIndex <= 0) {
        return;
    }
    setVisibleImageAt(currentImageIndex - 1);
}

// display image in lightbox on page load if image id is in hash url
function displayImageFromUrl(slideData, imageId) {
    const imageIndex = slideData.findIndex((item) => item.id === imageId);
    if (imageIndex >= 0) {
        setVisibleImageAt(imageIndex);
        displayLightbox();
    }
}

export function initializeDisplayAlbumLightbox() {
    if (!lightboxContainer) {
        return;
    }
    initializeLightbox();
    initializeImageLinkClickHandlers(imageLinks);
    initializeImageSwipeHandlers();
    initializeKeyboardShortcuts();

    //display image based if query string in url
    const imageQuery = new URLSearchParams(window.location.search).get(
        IMAGE_QUERY_STRING_KEY
    );
    displayImageFromUrl(slideData, imageQuery);
}
