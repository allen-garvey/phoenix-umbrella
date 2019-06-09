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