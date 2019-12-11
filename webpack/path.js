
function defaultEntrypointForApp(appName){
    return `${__dirname}/../apps/${appName}/assets/js/index.js`;
}

function outputPathForApp(appName, extension){
    let appDir = appName;
    let fileName = 'app';

    if(appName.match(/^artour_/)){
        appDir = 'artour';

        if(appName === 'artour_admin'){
            fileName = 'admin';
        }
    }
    else if(appName.match(/^startpage_/)){
        appDir = 'startpage';

        if(appName === 'startpage_admin'){
            fileName = 'admin';
        }
    }

    return `${appDir}/priv/static/assets/${fileName}.${extension}`;
}

module.exports = {
    defaultEntrypointForApp,
    outputPathForApp,
};