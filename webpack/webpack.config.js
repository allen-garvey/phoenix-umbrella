const path = require('path');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
    mode: "development",
    entry: {
        'photog': `${__dirname}/../apps/photog/js_src/index.js`,
        'seren': `${__dirname}/../apps/seren/js_src/index.js`,
        'booklist': `${__dirname}/../apps/booklist/assets/js/app.js`,
        'bookmarker': `${__dirname}/../apps/bookmarker/assets/js/index.js`,
        'movielist': `${__dirname}/../apps/movielist/assets/js/app.js`,
        'blockquote': `${__dirname}/../apps/blockquote/assets/sass/admin.scss`,
    },
    output: {
        path: path.join(__dirname, '..', 'apps'),
        filename: (info) => {
            return `${info.chunk.name}/priv/static/assets/app.js`;
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
            filename: '[name]/priv/static/assets/style.css',
        }),
    ],
};