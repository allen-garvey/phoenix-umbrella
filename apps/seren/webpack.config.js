const path = require('path');
const VueLoaderPlugin = require('vue-loader/lib/plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
    mode: "development",
    entry: [`${__dirname}/js_src/index.js`, `${__dirname}/sass/style.scss`,],
    output: {
        filename: 'app.js',
        path: path.resolve(__dirname, 'priv/static/js')
    },
    resolve: {
        alias: {
            // 'vue': path.resolve(__dirname, 'node_modules/vue/dist/vue.js'),
            'vue-infinite-scroll': path.resolve(__dirname, 'node_modules/vue-infinite-scroll/vue-infinite-scroll.js'),
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
                        options: {
                            minimize: true,
                        },
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
            filename: '../css/style.css',
        }),
    ],
};