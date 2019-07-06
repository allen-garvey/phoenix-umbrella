/*
 * Used for automatic slug generation on forms
 */

import { addListener } from './events.js';

//converts string into string that can be used for slug
//RULES: limited to 80 characters long, only lowercase letters,
//numbers and hypens allowed, hyphens cannot repeat and must not
//start or end with hyphen
function slugify(text){
	if(!text){
		return '';
	}
	const slugMaxChar = 80;
	return text.toLowerCase().replace(/[\s-_]+/g, '-').replace(/@+/g, 'at').replace(/&+/g, 'and').replace(/^[-]+|[-]$|[^a-z0-9-]/g, '').slice(0, slugMaxChar);
}

function autofillSlug(target, slug, shouldForce=false){
	if(target.value && !shouldForce){
		return;
	}
	target.value = slug;
}




export function initializeAutofillSlug(){
	addListener('[data-slug-source]', 'blur', (event, element)=>{
		const slugSource = element.value;
		const slugDest = document.querySelector('[data-slug]');

    	autofillSlug(slugDest, slugify(slugSource));
	});

	//initialize regenerate button
	addListener('#autofill-image-button', 'click', (event, element)=>{
		const slugSource = document.querySelector('[data-slug-source]');
		const slugDest = document.querySelector('[data-slug]');
		if(!slugSource || !slugDest){
			return;
		}
		autofillSlug(slugDest, slugify(slugSource.value), true);
	});
}