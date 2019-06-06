/*
 * Functionality to show QR Code of booklist on location book list
 * 
 */

 import { qrCodeGenerator } from './qrcode-generator.js';
 import { closest } from './dom.js';
 import { modalAlert } from './modal.js';

 const parentClassName = 'js_qr_parent';

function displayQrCode(caller){
	/*
	var book_list_html = '<ul class="qr_code_list">';
	var book_list_string = '';
	*/
	const fragment = document.createDocumentFragment();
	const qrCodeListNode = document.createElement('ul');
	qrCodeListNode.classList.add('qr_code_list');
	fragment.appendChild(qrCodeListNode);

	let qrCodeContent = '';
	
	closest(caller, (el)=>{return el.classList.contains(parentClassName);}).querySelectorAll('[data-role="qr-list"] > li').forEach((node)=>{
		//check if checkbox checked
		if(!node.querySelector('[data-role="qr-checkbox"]:checked')){
			return;
		}
		const title = node.querySelector('[data-role="qr-title"]').textContent;
		const callNumberNode = node.querySelector('[data-role="qr-call-number"]');
		const callNumber = callNumberNode ? callNumberNode.textContent : '';

		qrCodeContent += `${title} ${callNumber}\n`;
		const newListNode = document.createElement('li');
		newListNode.textContent = `${title} ${callNumber}`;
		qrCodeListNode.appendChild(newListNode);
	});

	const qrCodeElement = document.createElement('div');
	fragment.appendChild(qrCodeElement);
	
	//length is limited to QR Code version 40, which has 4296 character limit
	const qrCodeLengthLimit = 4296;
	if(qrCodeContent.length > qrCodeLengthLimit){
		modalAlert({bodyText: `QR Code limited to ${qrCodeLengthLimit} characters!`});
	}
	else if(qrCodeContent){
		modalAlert({bodyFragment : fragment});
		generateQrCode(qrCodeContent, qrCodeElement);
	}
	else{
		modalAlert({bodyText: 'No books checked for QR Code!'});
	}
	
};

function generateQrCode(textContent, qrCodeElement){
	qrCodeGenerator(qrCodeElement, {
		text : textContent,
		width : 500,
		height : 500
	});	
};


export function initializeQRCodeButtons(){
	document.querySelectorAll(`.${parentClassName} [data-role="qr-button"]`).forEach((button)=>{
		button.onclick = () => { 
			displayQrCode(button);
		};
	});
}
