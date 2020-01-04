/*
 * aQuery - lightweight version of jQuery 
 */

export function aQuery(selector){
	function aQueryObject(selector){
		if(typeof selector === 'string'){
			this.elementList = document.querySelectorAll(selector);
		}
		else if(selector instanceof Element){
			this.elementList = [selector];
		}
		else{
			//assume elementList
			this.elementList = selector;
		}
		this.length = this.elementList.length >= 0 ? this.elementList.length : 1;
	}
	/*
	* General utility methods
	*/
	//callback - index, element
	aQueryObject.prototype.each = function(func){
		for (var i = 0; i < this.length; i++) {
			func.call(this.elementList[i], i, this.elementList[i]);
		}
	}

	//callback - element, index
	aQueryObject.prototype.map = function(func){
		var ret = [];
		for (var i = 0; i < this.length; i++) {
			ret.push(func.call(this.elementList[i], this.elementList[i], i));
		}
		return ret;
	}

	aQueryObject.prototype.data = function(key){
		if(this.length < 1){
			return '';
		}
		return this.elementList[0].getAttribute('data-' + key);
	}



	/*
	* CSS Class methods
	*/
	aQueryObject.prototype.addClass = function(className){
		this.each(function(i, element){
			element.classList.add(className);
		});
		return this;
	};

	return (new aQueryObject(selector));
}