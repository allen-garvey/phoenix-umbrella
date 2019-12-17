const LiveReloadPlugin = require('webpack-livereload-plugin');
const config = require('./webpack.config.js');

config.watch = true;
config.watchOptions = {
    aggregateTimeout: 300,
    poll: 1000
};

config.plugins.push(
    new LiveReloadPlugin({
        appendScriptTag: true,
    })
);

module.exports = config;