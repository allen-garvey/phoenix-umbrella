import Vue from 'vue'


export function instantiateVue(containerId, vueComponent, propKeys=[], options={}){
    const containerEl = document.getElementById(containerId);
    if(!containerEl){
        return;
    }
    const props = propKeys.reduce((props, key)=>{
        props[key] = containerEl.dataset[key];
        return props;
    }, {});

    options.el = containerEl;
    options.render = h => h(vueComponent, {props});
    
    new Vue(options);
}