import { createApp } from 'vue';


export function instantiateVue(containerId, vueComponent, propKeys=[], router=null){
    const containerEl = document.getElementById(containerId);
    if(!containerEl){
        return;
    }
    const props = propKeys.reduce((props, key)=>{
        props[key] = containerEl.dataset[key];
        return props;
    }, {});

    const app = createApp(vueComponent, props);
    
    if(router){
        app.use(router);
    }

    app.mount(containerEl);
}