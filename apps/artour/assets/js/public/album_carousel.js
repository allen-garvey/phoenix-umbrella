/*
 * Functionality to display album show pages in lightbox
 */

import { createDiv, getData, mapElements } from './dom-helpers';
import { IMAGE_QUERY_STRING_KEY, setImageUrl, clearImageUrl } from './history';

const FIRST_IMAGE_CLASS = 'first-image';
const LAST_IMAGE_CLASS = 'last-image';
const imageLinks = document.querySelectorAll('.post-thumbnails a');
const slideData = initializeSlideData(imageLinks);
let currentImageIndex = null;
let isLightboxVisible = false;

function initializeSlideData(links){
    return mapElements(links, (link)=>{
        return {
            caption: getData(link, 'caption'),
            src: getData(link, 'src'),
            srcset: getData(link, 'srcset'),
            id: getData(link, 'slug'),
            isInitialized: false,
        };
    });
}

function initializeLightbox(numImageLinks){
    const lightboxBackground = document.querySelector('.lightbox-background');
    lightboxBackground.onclick = hideLightbox;

    const imagesContainer = document.querySelector('.lightbox-images-container');
    const imagesFragment = document.createDocumentFragment();
    //add empty placeholder divs for images
    //will be lazy loaded by inserting img tag when necessary
    for(let i=0; i<numImageLinks;i++){
        imagesFragment.appendChild(createDiv('image-container'));
    }
    imagesContainer.appendChild(imagesFragment);

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
function setVisibleImageAt(imageIndex){
    currentImageIndex = imageIndex;

    // hide or show prev / next buttons
    const controlsContainer = document.getElementById('lightbox-container');
    if(imageIndex === 0){
        controlsContainer.classList.add(FIRST_IMAGE_CLASS);
    }
    else {
        controlsContainer.classList.remove(FIRST_IMAGE_CLASS);
    }

    if(imageIndex === slideData.length - 1){
        controlsContainer.classList.add(LAST_IMAGE_CLASS);
    }
    else {
        controlsContainer.classList.remove(LAST_IMAGE_CLASS);
    }

    const parentSelector = `.lightbox-images-container .image-container:nth-child(${(imageIndex + 1)})`;
    const parent = document.querySelector(parentSelector);
    const currentImageData = slideData[imageIndex];
    //initialize img tag if necessary
    if(!currentImageData.isInitialized){
        currentImageData.isInitialized = true;
        const imgTag = document.createElement('img');
        imgTag.src = currentImageData.src;
        imgTag.srcset = currentImageData.srcset;
        parent.appendChild(imgTag);
    }
    document.querySelector('.caption-body').textContent = currentImageData.caption;
    
    setImageUrl(currentImageData.id);

    document.querySelectorAll('.lightbox-images-container>.image-container')
        .forEach((element, i)=>{
            const action = i === imageIndex ? 'add' : 'remove';
            element.classList[action]('active');
            element.style.transform = '';
        });
}

function displayLightbox(){
    isLightboxVisible = true;
    document.querySelector('.lightbox-container').classList.remove('hidden');
}

function hideLightbox(){
    isLightboxVisible = false;
    document.querySelector('.lightbox-container').classList.add('hidden');
    clearImageUrl();
}

function initializeImageLinkClickHandlers(imageLinks){
    imageLinks.forEach((el, i)=>{
        el.onclick = (e)=>{
            e.preventDefault();
            setVisibleImageAt(i);
            displayLightbox();
        };
    });
}

function initializeImageSwipeHandlers(){
    const imagesContainer = document.querySelector('.lightbox-images-container');
    //number of pixels allowed in diagonal between touch start and start end
    const yThreshold = 100;
    //number of pixels need to be swiped in x direction to register as swipe
    const xThreshold = 100;

    let touchStartX = null;
    let touchStartY = null;
    let activeImageContainer= null;

    imagesContainer.addEventListener('touchstart', function(e){
        // check if pinching to zoom
        if(e.touches.length > 1){
            activeImageContainer = null;
            return;
        }
        const touch = e.touches[0];
        touchStartX = touch.clientX;
        touchStartY = touch.clientY;
        activeImageContainer = document.querySelector('.lightbox-images-container .image-container.active');
    });
    imagesContainer.addEventListener('touchmove', function(e){
        if(activeImageContainer === null){
            return;
        }
        const isFirstImage = currentImageIndex === 0;
        const isLastImage = currentImageIndex === slideData.length - 1;
        const touch = e.touches[0];
        const xCoordinate = touch.clientX;

        if((isFirstImage && xCoordinate > touchStartX) || (isLastImage && xCoordinate < touchStartX)){
            return;
        }

        activeImageContainer.style.transform = `translateX(calc(${xCoordinate}px - 50%))`;
    });
    imagesContainer.addEventListener('touchend', function(e){
        if(activeImageContainer === null){
            return;
        }
        const touch = e.changedTouches[0];
        const touchEndX = touch.clientX;
        const touchEndY = touch.clientY;
        let thresholdMet = true;

        const yDifference = Math.abs(touchEndY - touchStartY);
        if(yDifference > yThreshold){
            thresholdMet = false;
        }
        const xDifference = Math.abs(touchEndX - touchStartX);
        if(xDifference < xThreshold){
            thresholdMet = false;
        }

        if(!thresholdMet){
            activeImageContainer.style.transform = 'translateX(0px)';
            return;
        }

        //swiped right, show previous image
        if(touchEndX > touchStartX){
            if(currentImageIndex > 0){
                showPreviousImage();
                return;
            }
        }
        //swiped left, show next image
        else {
            if(currentImageIndex < slideData.length - 2){
                showNextImage();
                return;
            }
        }

        activeImageContainer.style.transform = 'translateX(0px)';
    });
}

function initializeKeyboardShortcuts(){
    document.onkeydown = function(e){
        //don't do anything if lightbox is invisible
        if (!isLightboxVisible){
            return;
        }
        switch(e.keyCode){
            //escape key
            case 27:
                hideLightbox();       
                break;
            //right arrow
            case 39:
                showNextImage();
                break;
            //left arrow
            case 37:
                showPreviousImage();
                break;
        }
    };
}

function showNextImage(){
    //stop at the end
    if(currentImageIndex >= slideData.length - 1){
        return;
    }
    setVisibleImageAt(currentImageIndex + 1);
}
function showPreviousImage(){
    //stop at beginning
    if(currentImageIndex <= 0){
        return;
    }
    setVisibleImageAt(currentImageIndex - 1);

}

//display image in lightbox on page load if image id is in
//hash url
function displayImageFromUrl(slideData, imageId){
    if(!imageId){
        return;
    }
    for(let i=0;i<slideData.length;i++){
        if(slideData[i].id === imageId){
            setVisibleImageAt(i);
            displayLightbox();
            break;
        }
    }
}

export function initializeDisplayAlbumLightbox(){
    if(!document.querySelector('.lightbox-container')){
        return;
    }
    initializeLightbox(imageLinks.length);
    initializeImageLinkClickHandlers(imageLinks);
    initializeImageSwipeHandlers();
    initializeKeyboardShortcuts();
    
    //display image based if query string in url
    const imageQuery = (new URLSearchParams(window.location.search)).get(IMAGE_QUERY_STRING_KEY);
    displayImageFromUrl(slideData, imageQuery);
}