const path = require('path');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

const pathHelpers = require('./path.js');

module.exports = {
    mode: "development",
    entry: {
        'photog': pathHelpers.defaultEntrypointForApp('photog'),
        'seren': pathHelpers.defaultEntrypointForApp('seren'),
        'booklist': pathHelpers.defaultEntrypointForApp('booklist'),
        'bookmarker': pathHelpers.defaultEntrypointForApp('bookmarker'),
        'movielist': pathHelpers.defaultEntrypointForApp('movielist'),
        'blockquote': `${__dirname}/../apps/blockquote/assets/sass/admin.scss`,
        'artour_admin': `${__dirname}/../apps/artour/assets/js/admin/index.js`,
        'artour_public': `${__dirname}/../apps/artour/assets/js/public/index.js`,
    },
    output: {
        path: path.join(__dirname, '..', 'apps'),
        filename: (info) => {
            return pathHelpers.outputPathForApp(info.chunk.name, 'js');
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
                return pathHelpers.outputPathForApp(chunk.name, 'css');
            },
        }),
    ],
};