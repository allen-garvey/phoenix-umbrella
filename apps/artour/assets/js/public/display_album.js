/*
 * Functionality to display album show pages in lightbox
 */
import { aQuery as $ } from './aquery.js';

export function initializeDisplayAlbumLightbox(){
    const imageLinks = $('.post-thumbnails a');
    //used to keep track on if an image has been initialized to lightbox already
    //used to lazy-load images
    const imageInitializedMap = {};
    let currentImageIndex = null;
    let isLightboxVisible = false;

    //history stuff
    const BASE_URL = `${window.location.origin}${window.location.pathname}`;
    const IMAGE_QUERY_STRING_KEY = 'image';
    const history = window.history;

    function createDiv(className){
        const div = document.createElement('div');
        div.className = className;
        return div;
    }

    function initializeLightbox(numImageLinks){
        const lightboxBackground = document.querySelector('.lightbox-background');
    	lightboxBackground.onclick = hideLightbox;

        const imagesContainer = document.querySelector('.lightbox-images-container');
        //add empty placeholder divs for images
        //will be lazy loaded by inserting img tag
        //when necessary
        for(let i=0; i<numImageLinks;i++){
            imagesContainer.appendChild(createDiv('image-container'));
        }

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
        const imageLink = $(imageLinks.elementList[imageIndex]);
        //initialize img tag if necessary
        if(!imageInitializedMap[imageIndex]){
            imageInitializedMap[imageIndex] = true;
            const imgTag = document.createElement('img');
            imgTag.src = imageLink.data('src');
            imgTag.srcset = imageLink.data('srcset');
            parent.appendChild(imgTag);
        }
        document.querySelector('.caption-body').textContent = imageLink.data('caption');
        
        //set history state
        const imageSlug = imageLink.data('slug');
        history.replaceState({image_slug: imageSlug}, '', `${BASE_URL}?${IMAGE_QUERY_STRING_KEY}=${imageSlug}`);

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
        //clear history
        history.replaceState({}, '', BASE_URL);
    }

    function initializeImageLinkClickHandlers(imageLinks){
        //can't use on function since we need index
        imageLinks.each((i, el)=>{
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

    function showNextImage(){
        //don't do anything if we are at the last image
        if(currentImageIndex >= imageLinks.length - 1){
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

    //display image in lightbox on page load if image slug is in
    //hash url
    function displayImageFromUrl(imageLinks, imageSlugUrl){
        if(!imageSlugUrl){
            return;
        }
        let matchFound = false;
        imageLinks.each(function(index, el){
            if(!matchFound && $(el).data('slug') === imageSlugUrl){
                matchFound = true;
                setVisibleImageAt(index);
                displayLightbox();
            }
        });
    }

    (function(){
        initializeLightbox(imageLinks.length);
        initializeImageLinkClickHandlers(imageLinks);
        initializeImageSwipeHandlers();
        
        //display image based if query string in url
        const imageQuery = (new URLSearchParams(window.location.search)).get(IMAGE_QUERY_STRING_KEY);
        displayImageFromUrl(imageLinks, imageQuery);
    })();
}