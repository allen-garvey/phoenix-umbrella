export function createDiv(className){
    const div = document.createElement('div');
    div.className = className;
    return div;
}

export function getData(el, dataAttributeName){
    return el.getAttribute(`data-${dataAttributeName}`);
}

export function mapElements(elements, callback){
    const ret = [];

    elements.forEach((...args)=>{
        ret.push(callback(...args));
    });

    return ret;
}