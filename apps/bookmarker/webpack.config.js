const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
    entry: [`${__dirname}/web/static/js/index.js`, `${__dirname}/web/static/css/app.scss`,],
    output: {
        filename: 'app.js',
        path: path.resolve(__dirname, 'priv/static/js')
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
                        MiniCssExtractPlugin.loader,
                        'css-loader',
                        {
                            loader: 'sass-loader',
                            options: {
                                outputStyle: 'compressed',
                            },
                        },
                ]
            }
        ]
    },
    plugins: [
        new VueLoaderPlugin(),
        new MiniCssExtractPlugin({ filename: '../css/app.css' }),
    ]
};
