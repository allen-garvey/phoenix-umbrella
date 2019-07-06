import Vue from 'vue';

function extractProps(container, keys){
    const props = {};

    keys.forEach(key => {
        props[key] = container.dataset[key];
    });

    return props;
}

export function initializeVueComponent(elementId, vueComponent, propKeys){
    const container = document.getElementById(elementId);
    if(container){
        const props = extractProps(container, propKeys);

        new Vue({
            el: container,
            render: h => h(vueComponent, {props}),
        });
    }
}