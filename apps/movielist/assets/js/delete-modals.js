
import { modalConfirm } from './modal.js';


export function initializeDeleteModals(){
	document.querySelectorAll('form[data-confirm]').forEach((item)=>{
    	item.onsubmit = function(event){
	    	event.preventDefault();
	    	const message = 'Are you sure you want to delete ' + this.getAttribute('data-confirm') + '?';
	    	modalConfirm(() => {
	    		this.submit();
	    	}, {
	    		modalText: message
	    	});
	    };
    });
}