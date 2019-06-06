function hideModal(){
	document.getElementById('modal_container').style.display = 'none';
};

function showModal(){
	document.getElementById('modal_overlay').onclick = hideModal;
	document.getElementById('modal_container').style.display = '';
};

export function modalConfirm(callback, options = {}){
	const modal = document.getElementById('modal');
	modal.classList.remove('alert');
	modal.classList.add('confirm');
	document.getElementById('modal_body').textContent = options.modalText || "";
	const confirmButton = document.getElementById('modal_confirm_confirm');
	confirmButton.textContent = options.confirmButtonText || 'Delete';
	const cancelButton = document.getElementById('modal_confirm_cancel');
	cancelButton.textContent = options.cancelButtonText || 'Cancel';
	cancelButton.onclick = hideModal;
	confirmButton.onclick = callback;
	showModal();
};

export function modalAlert(options = {}){
	const modal = document.getElementById('modal');
	modal.classList.remove('confirm');
	modal.classList.add('alert');
	if(options.bodyFragment){
		const modalBody = document.getElementById('modal_body');
		modalBody.innerHTML = '';
		modalBody.appendChild(options.bodyFragment);
	}
	else if(options.bodyText){
		const modalBody = document.getElementById('modal_body');
		modalBody.textContent = options.bodyText;
	}
	const confirmButton = document.getElementById('modal_alert_confirm');
	confirmButton.textContent = options.confirmButtonText || 'Ok';
	confirmButton.onclick = hideModal;
	showModal();
};