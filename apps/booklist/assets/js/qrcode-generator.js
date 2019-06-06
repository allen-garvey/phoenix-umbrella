//---------------------------------------------------------------------
// QRCode for JavaScript
//
// Copyright (c) 2009 Kazuhiko Arase
//
// URL: http://www.d-project.com/
//
// Licensed under the MIT license:
//   http://www.opensource.org/licenses/mit-license.php
//
// The word "QR Code" is registered trademark of 
// DENSO WAVE INCORPORATED
//   http://www.denso-wave.com/qrcode/faqpatent-e.html
//
//---------------------------------------------------------------------
//from: https://github.com/jeromeetienne/jquery-qrcode
//based on commit: 6c0bdd8c4ac835e0553437365d6cc0e60c11cba3
// based on file: jquery.qrcode.js

import { QRCode, QRErrorCorrectLevel } from './qrcode.js';

export function qrCodeGenerator(parentElement, options={}) {
	const defaultOptions = {
		width		: 256,
		height		: 256,
		typeNumber	: -1,
		correctLevel: QRErrorCorrectLevel.H,
        background  : "#ffffff",
        foreground  : "#000000",
        text        : '',
	};
	for(let key in defaultOptions){
		if(!(key in options)){
			options[key] = defaultOptions[key];
		}
	}

	var createCanvas	= function(){
		// create the qrcode itself
		var qrcode	= new QRCode(options.typeNumber, options.correctLevel);
		qrcode.addData(options.text);
		qrcode.make();

		// create canvas element
		var canvas	= document.createElement('canvas');
		canvas.width	= options.width;
		canvas.height	= options.height;
		var ctx		= canvas.getContext('2d');

		// compute tileW/tileH based on options.width/options.height
		var tileW	= options.width  / qrcode.getModuleCount();
		var tileH	= options.height / qrcode.getModuleCount();

		// draw in the canvas
		for( var row = 0; row < qrcode.getModuleCount(); row++ ){
			for( var col = 0; col < qrcode.getModuleCount(); col++ ){
				ctx.fillStyle = qrcode.isDark(row, col) ? options.foreground : options.background;
				var w = (Math.ceil((col+1)*tileW) - Math.floor(col*tileW));
				var h = (Math.ceil((row+1)*tileH) - Math.floor(row*tileH));
				ctx.fillRect(Math.round(col*tileW),Math.round(row*tileH), w, h);  
			}	
		}
		// return just built canvas
		return canvas;
	}


	parentElement.appendChild(createCanvas());
};