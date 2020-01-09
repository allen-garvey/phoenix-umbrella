/*
 * Functionality to display album show pages in lightbox
 */

import { createDiv, getData, mapElements } from './dom-helpers';
import { IMAGE_QUERY_STRING_KEY, setImageUrl, clearImageUrl } from './history';

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
            slug: getData(link, 'slug'),
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
    const parentSelector = `.lightbox-images-container>div:nth-child(${(imageIndex + 1)})`;
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
    
    setImageUrl(currentImageData.slug);

    document.querySelectorAll('.lightbox-images-container>.image-container')
        .forEach((element, i)=>{
            const action = i === imageIndex ? 'remove' : 'add';
            element.classList[action]('hidden');
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
    const xThreshold = 50;

    let touchStartX = null;
    let touchStartY = null;

    imagesContainer.addEventListener('touchstart', function(e){
        const touch = e.touches[0];
        touchStartX = touch.clientX;
        touchStartY = touch.clientY;
    });
    imagesContainer.addEventListener('touchend', function(e){
        const touch = e.changedTouches[0];
        const touchEndX = touch.clientX;
        const touchEndY = touch.clientY;

        const yDifference = Math.abs(touchEndY - touchStartY);
        if(yDifference > yThreshold){
            return;
        }
        const xDifference = Math.abs(touchEndX - touchStartX);
        if(xDifference < xThreshold){
            return;
        }
        //swiped right, show previous image
        if(touchEndX > touchStartX){
            showPreviousImage();
        }
        //swiped left, show next image
        else{
            showNextImage();
        }
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
    //don't do anything if we are at the last image
    if(currentImageIndex >= slideData.length - 1){
        return;
    }
    setVisibleImageAt(currentImageIndex + 1);
}
function showPreviousImage(){
    //don't do anything if we are at the first image
    if(currentImageIndex <= 0){
        return;
    }
    setVisibleImageAt(currentImageIndex - 1);

}

//display image in lightbox on page load if image slug is in
//hash url
function displayImageFromUrl(slideData, imageSlugUrl){
    if(!imageSlugUrl){
        return;
    }
    for(let i=0;i<slideData.length;i++){
        if(slideData[i].slug === imageSlugUrl){
            setVisibleImageAt(i);
            displayLightbox();
            break;
        }
    }
}

export function initializeDisplayAlbumLightbox(){
    initializeLightbox(imageLinks.length);
    initializeImageLinkClickHandlers(imageLinks);
    initializeImageSwipeHandlers();
    initializeKeyboardShortcuts();
    
    //display image based if query string in url
    const imageQuery = (new URLSearchParams(window.location.search)).get(IMAGE_QUERY_STRING_KEY);
    displayImageFromUrl(slideData, imageQuery);
}