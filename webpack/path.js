
function defaultEntrypointForApp(appName){
    return `${__dirname}/../apps/${appName}/assets/js/index.js`;
}

function outputPathForApp(appName, extension){
    let appDir = appName;
    let fileName = 'app';

    if(appName === 'artour_admin'){
        appDir = 'artour';
        fileName = 'admin';
    }
    else if(appName === 'artour_public'){
        appDir = 'artour';
    }

    return `${appDir}/priv/static/assets/${fileName}.${extension}`;
}

module.exports = {
    defaultEntrypointForApp,
    outputPathForApp,
};