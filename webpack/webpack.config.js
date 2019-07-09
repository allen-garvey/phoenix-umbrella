const path = require('path');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

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
    mode: "development",
    entry: {
        'photog': `${__dirname}/../apps/photog/js_src/index.js`,
        'seren': `${__dirname}/../apps/seren/js_src/index.js`,
        'booklist': `${__dirname}/../apps/booklist/assets/js/app.js`,
        'bookmarker': `${__dirname}/../apps/bookmarker/assets/js/index.js`,
        'movielist': `${__dirname}/../apps/movielist/assets/js/index.js`,
        'blockquote': `${__dirname}/../apps/blockquote/assets/sass/admin.scss`,
        'artour_admin': `${__dirname}/../apps/artour/assets/js/admin/index.js`,
        'artour_public': `${__dirname}/../apps/artour/assets/js/public/index.js`,
    },
    output: {
        path: path.join(__dirname, '..', 'apps'),
        filename: (info) => {
            return outputPathForApp(info.chunk.name, 'js');
        },
    },
    resolve: {
        alias: {
            //for seren
            'vue-infinite-scroll': path.resolve(__dirname, '../node_modules/vue-infinite-scroll/vue-infinite-scroll.js'),
        }
    },
    module: {
        rules: [
            {
                test: /\.vue$/,
                loader: 'vue-loader'
            },
            {
                test: /\.scss$/,
                use: [
                    {
                        loader: MiniCssExtractPlugin.loader,
                    },
                    {
                        loader: 'css-loader',
                    },
                    {
                        loader: 'sass-loader',
                        options: {
                            outputStyle: 'compressed',
                        },
                    },
                ]
            },
        ]
    },
    plugins: [
        new VueLoaderPlugin(),
        new MiniCssExtractPlugin({
            moduleFilename: (chunk) => {
                return outputPathForApp(chunk.name, 'css');
            },
        }),
    ],
};