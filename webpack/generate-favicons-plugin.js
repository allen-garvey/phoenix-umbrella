const path = require('path');
const fs = require('fs');

function createFileIfNotExists(filename){
    return new Promise((resolve, reject) => {
        fs.open(filename, 'a', (err, f) => {
            if(err){
                return reject(err);
            }
            fs.close(f, (err) => {
                if(err){
                    return reject(err);
                }
                return resolve(f);
            });
        });
    });
}

function createPlugin(appNames){
    return {
        apply(compiler) {
            compiler.hooks.done.tapAsync('Generate favicon plugin', (_stats, callback) => {
                const promises = appNames.map((appName) => {
                    const filename = path.join(__dirname, '..', 'apps', appName, 'priv', 'static', 'favicon.ico');
                    return createFileIfNotExists(filename);
                });
                Promise.all(promises).then(() => callback());
            });
        }
    };
}

module.exports = createPlugin;
