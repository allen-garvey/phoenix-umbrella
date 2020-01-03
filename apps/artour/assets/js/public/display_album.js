/*
 * Functionality to display album show pages in lightbox
 */
import { aQuery as $ } from './aquery.js';

export function initializeDisplayAlbumLightbox(){
    var imageLinks = $('.post-thumbnails a');
    //used to keep track on if an image has been initialized to lightbox already
    //used to lazy-load images
    var imageInitializedMap = imageLinks.map(function(){ return false; });
    var currentImageIndex = null;
    var isLightboxVisible = false;

    //history stuff
    var BASE_URL = `${window.location.origin}${window.location.pathname}`;
    var IMAGE_QUERY_STRING_KEY = 'image';
    var history = window.history;

    function createDiv(className){
        var div = document.createElement('div');
        div.className = className;
        return div;
    }

    function initializeLightbox(numImageLinks){
    	var lightboxContainer = createDiv('lightbox-container hidden');
    	
        var lightboxBackground = createDiv('lightbox-background');
    	lightboxBackground.onclick = hideLightbox;

        var imagesContainer = createDiv('lightbox-images-container');
        
        //add empty placeholder divs for images
        //will be lazy loaded by inserting img tag
        //when necessary
        for(var i=0; i<numImageLinks;i++){
            imagesContainer.appendChild(createDiv('image-container'));
        }

        //add close 'X' button
        //have to add this after the .image-containers,
        //because nth-child and nth-of-type do not work
        //on class selectors, only elements
        var closeButton = createDiv('close-window-button');
        closeButton.onclick = hideLightbox;
        imagesContainer.appendChild(closeButton);

        var bottomContainer = createDiv('lightbox-bottom-container');

        //captions

        var captionContainer = createDiv('caption-container');
        bottomContainer.appendChild(captionContainer);

        captionContainer.appendChild(createDiv('caption-body'));
        captionContainer.appendChild(createDiv('caption-overlay'));

        //buttons
        var buttonContainer = createDiv('lightbox-button-container');
        bottomContainer.appendChild(buttonContainer);

        var leftButton = createDiv('slideshow-left-button');
        leftButton.onclick = showPreviousImage;
        buttonContainer.appendChild(leftButton);

        var rightButton = createDiv('slideshow-right-button');
        rightButton.onclick = showNextImage;
        buttonContainer.appendChild(rightButton);
    	
        lightboxContainer.appendChild(bottomContainer);
        lightboxContainer.appendChild(imagesContainer);
    	lightboxContainer.appendChild(lightboxBackground);
    	document.body.appendChild(lightboxContainer);
    }

    //displays image at index
    //creates img tag if necessary - used for lazy loading
    function setVisibleImageAt(imageIndex){
        currentImageIndex = imageIndex;
        var parentSelector = '.lightbox-images-container>div:nth-child('+(imageIndex + 1) + ')';
        var imageLink = $(imageLinks.elementList[imageIndex]);
        //initialize img tag if necessary
        if(!imageInitializedMap[imageIndex]){
            imageInitializedMap[imageIndex] = true;
            var imgTag = document.createElement('img');
            imgTag.src = imageLink.data('src');
            imgTag.srcset = imageLink.data('srcset');
            document.querySelector(parentSelector).appendChild(imgTag);
        }
        document.querySelector('.caption-body').textContent = imageLink.data('caption');
        
        //set history state
        var imageSlug = imageLink.data('slug');
        history.replaceState({image_slug: imageSlug}, '', BASE_URL+'?'+IMAGE_QUERY_STRING_KEY+'='+imageSlug);

        $('.lightbox-images-container>.image-container').addClass('hidden');
        $(parentSelector).removeClass('hidden');
    }

    function displayLightbox(imageIndex){
        isLightboxVisible = true;
        $('.lightbox-container').removeClass('hidden');
    }

    function hideLightbox(){
        isLightboxVisible = false;
        $('.lightbox-container').addClass('hidden');
        //clear history
        history.replaceState({}, '', BASE_URL);
    }

    function initializeImageLinkClickHandlers(imageLinks){
        //can't use on function since we need index
        imageLinks.each(function(i, el){
            el.onclick = function(e){
                e.preventDefault();
                setVisibleImageAt(i);
                displayLightbox();
            };
        });
    }

    function initializeImageSwipeHandlers(){
        var imagesContainer = document.querySelector('.lightbox-images-container');
        //number of pixels allowed in diagonal between touch start and start end
        var yThreshold = 100;
        //number of pixels need to be swiped in x direction to register as swipe
        var xThreshold = 50;

        var touchStartX = null;
        var touchStartY = null;

        imagesContainer.addEventListener('touchstart', function(e){
            var touch = e.touches[0];
            touchStartX = touch.clientX;
            touchStartY = touch.clientY;
        });
        imagesContainer.addEventListener('touchend', function(e){
            var touch = e.changedTouches[0];
            var touchEndX = touch.clientX;
            var touchEndY = touch.clientY;

            var yDifference = Math.abs(touchEndY - touchStartY);
            if(yDifference > yThreshold){
                return;
            }
            var xDifference = Math.abs(touchEndX - touchStartX);
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
        var matchFound = false;
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
        var queryString = window.location.search.substring(1); 
        var imageQueryStringRegex = new RegExp('^'+IMAGE_QUERY_STRING_KEY+'=|[&].*$', 'g');
        displayImageFromUrl(imageLinks, queryString.replace(imageQueryStringRegex, ''));
    })();


}